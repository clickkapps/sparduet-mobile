import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/feeds/data/models/feed_broadcast_event.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_broadcast_repository.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/home/data/repositories/socket_connection_repository.dart';
import 'package:sparkduet/features/users/data/models/user_disciplinary_record_model.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/data/repositories/user_repository.dart';
import 'package:sparkduet/features/users/data/store/enums.dart';
import 'package:sparkduet/features/users/data/store/user_state.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';

class UserCubit extends Cubit<UserState> {

  final UserRepository userRepository;
  final SocketConnectionRepository socketConnectionRepository;
  final FeedBroadcastRepository feedBroadcastRepository;
  StreamSubscription<FeedBroadCastEvent>? feedBroadcastRepositoryStreamListener;

  void clearState() {
    emit(const UserState());
  }

  UserCubit({required this.userRepository, required this.socketConnectionRepository, required this.feedBroadcastRepository}) : super(const UserState()) {
    listenForFeedUpdate();
  }

  /// This method updates feed when there's a change in state
  void listenForFeedUpdate() async {

    await feedBroadcastRepositoryStreamListener?.cancel();
    feedBroadcastRepositoryStreamListener = feedBroadcastRepository.stream.listen((FeedBroadCastEvent event) {

      if(event.action == FeedBroadcastAction.censorUpdated){
        final feedId = event.data['id'] as int?;
        final disAction = event.data['action'] as String?;
        if(feedId == state.user?.introductoryPost?.id) {
          final introPostUpdated = state.user?.introductoryPost?.copyWith(
              disciplinaryAction: disAction
          );
          final updatedUser = state.user?.copyWith(
            introductoryPost: introPostUpdated
          );
          setUser(updatedUser);
        }
      }


    });
  }

  void listenToServerNotificationUpdates({required AuthUserModel? authUser}) async {

   socketConnectionRepository.realtimeInstance?.channels.get("public:users.${authUser?.id}.unread-profile-views-counted")
    .subscribe().listen((event) {
      final data = event.data as Map<Object?, Object?>;
      final json = convertMap(data);
      final count = json['count'] as int;
      emit(state.copyWith(status: UserStatus.countUnreadProfileViewersInProgress));
      emit(state.copyWith(status: UserStatus.countUnreadProfileViewersSuccessful, unreadViewersCount: count));

    });

   socketConnectionRepository.realtimeInstance?.channels.get("public:users.${authUser?.id}.block-status-changed")
       .subscribe().listen((event) {
      //get user block status
     getUserBlockStatus(profileId: state.user?.id);
   });

   socketConnectionRepository.realtimeInstance?.channels.get("public:users.${authUser?.id}.disciplinary-record-updated")
       .subscribe().listen((event) {
      //get user block status
     final data = event.data as Map<Object?, Object?>;
     final messageObj = data['disciplinaryRecord'] as Map<Object?, Object?>?;
     final disRecordId = data['disRecordId'] as int;
     emit(state.copyWith(status: UserStatus.getDisciplinaryRecordInProgress));
     if(messageObj == null) {
       if(state.disciplinaryRecord != null) {
         if(disRecordId == state.disciplinaryRecord?.id) {
           emit(state.copyWith(status: UserStatus.getDisciplinaryRecordSuccessful, disciplinaryRecord: null));
         }
       }
       return;
     }
     final messageJson = convertMap(messageObj!);
     final disRecord = UserDisciplinaryRecordModel.fromJson(messageJson);
     emit(state.copyWith(status: UserStatus.getDisciplinaryRecordSuccessful, disciplinaryRecord: disRecord));


   });

    socketConnectionRepository.realtimeInstance?.channels.get("public:users.${authUser?.id}.online-users.status-changed")
        .subscribe().listen((event) {
      final data = event.data as Map<Object?, Object?>;
      final idsObjs = data['ids'] as List<Object?>;
      final ids = convertToIntList(idsObjs);
      debugPrint("ids online: $ids");
      debugPrint("auth user id: ${authUser?.id}");
      final activeIds = ids.where((e) => e  != authUser?.id).toList();
      emit(state.copyWith(status: UserStatus.refreshOnlineListInProgress));
      emit(state.copyWith(status: UserStatus.refreshOnlineListCompleted, onlineUserIds: activeIds));

    });

  }

  void setUserBlockedStatus({bool? youBlockedUser, bool? userBlockedYou}) {
    emit(state.copyWith(status: UserStatus.setUserBlockedStatusInProgress));
    emit(state.copyWith(status: UserStatus.setUserBlockedStatusCompleted,
        youBlockedUser: youBlockedUser ?? state.youBlockedUser,
        userBlockedYou: userBlockedYou ?? userBlockedYou
    ));
  }

  void setUser(UserModel? user) {
      emit(state.copyWith(status: UserStatus.setUserInProgress));
      emit(state.copyWith(status: UserStatus.setUserCompleted, user: user));
  }


  void fetchUserInfo({required int? userId}) async {
    emit(state.copyWith(status: UserStatus.fetchUserInfoInProgress));
    final either = await userRepository.fetchUserProfile(userId: userId);
    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.fetchUserInfoFailed, message: l));
      return;
    }

    final r = either.asRight();
    setUser(r);
    emit(state.copyWith(status: UserStatus.fetchUserInfoSuccessful));
  }

  void saveProfileView({required int? profileId}) async {
    emit(state.copyWith(status: UserStatus.saveProfileViewInProgress));
    final either = await userRepository.saveProfileView(profileId: profileId);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.saveProfileViewFailed, message: l));
      return;
    }
    emit(state.copyWith(status: UserStatus.saveProfileViewSuccessful));
  }


  Future<(String?, List<UserModel>?)> fetchUnreadProfileViewers({int? pageKey}) async {

    emit(state.copyWith(status: UserStatus.fetchUnreadProfileViewersInProgress));
    final either = await userRepository.fetchUnreadProfileViewers(pageKey: pageKey);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.fetchUnreadProfileViewersFailed, message: l));
      return (l, null);
    }


    final newItems = either.asRight();
    final List<UserModel> users = <UserModel>[...state.unreadViewers];
    if(pageKey == 1){
      // if its first page request remove all existing threads
      users.clear();
    }
    users.addAll(newItems);
    emit(state.copyWith(status: UserStatus.fetchUnreadProfileViewersSuccessful,
        unreadViewers: users,
        unreadViewersCount: 0
    ));
    return (null, newItems);

  }

  Future<void> countUnreadProfileViews() async {

    emit(state.copyWith(status: UserStatus.countUnreadProfileViewersInProgress));
    final either = await userRepository.countUnreadProfileViews();
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.countUnreadProfileViewersFailed, message: l));
      return;
    }

    final count = either.asRight();
    emit(state.copyWith(status: UserStatus.countUnreadProfileViewersSuccessful, unreadViewersCount: count));
    return;

  }

  Future<(String?, List<UserModel>?)> fetchPostLikedUsers({required int? pageKey, required int? postId}) async {

    emit(state.copyWith(status: UserStatus.fetchPostLikedUsersInProgress));
    final either = await userRepository.fetchPostLikedUsers(pageKey: pageKey, postId: postId);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.fetchPostLikedUsersFailed, message: l));
      return (l, null);
    }


    final newItems = either.asRight();
    final List<UserModel> users = <UserModel>[...state.postLikedUsers];
    if(pageKey == 1){
      // if its first page request remove all existing threads
      users.clear();
    }
    users.addAll(newItems);
    emit(state.copyWith(status: UserStatus.fetchPostLikedUsersSuccessful,
        postLikedUsers: users
    ));
    return (null, newItems);

  }


  Future<(String?, List<UserModel>?)> fetchUsersOnline({int? pageKey}) async {

    emit(state.copyWith(status: UserStatus.fetchUsersOnlineInProgress));
    final either = await userRepository.fetchUsersOnline(pageKey: pageKey);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.fetchUsersOnlineFailed, message: l));
      return (l, null);
    }


    final newItems = either.asRight();
    final List<UserModel> users = <UserModel>[...state.onlineUsers];
    if(pageKey == 1){
      // if its first page request remove all existing threads
      users.clear();
    }
    users.addAll(newItems);
    emit(state.copyWith(status: UserStatus.fetchUsersOnlineSuccessful,
        onlineUsers: users
    ));
    return (null, newItems);

  }

  Future<void> getOnlineUserIds(int? authUserId) async {

    emit(state.copyWith(status: UserStatus.getOnlineUserIdsInProgress));
    final either = await userRepository.getOnlineUserIds();
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.getOnlineUserIdsFailed, message: l));
      return;
    }

    final ids = either.asRight();
    final activeIds = ids.where((e) => e  != authUserId).toList();
    emit(state.copyWith(status: UserStatus.getOnlineUserIdsSuccessful, onlineUserIds: activeIds));
    return;

  }

  Future<void> addOnlineUser({required int? userId}) async {

    emit(state.copyWith(status: UserStatus.addOnlineUserInProgress));
    final either = await userRepository.addOnlineUser(userId: userId);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.addOnlineUserFailed, message: l));
      return;
    }
    emit(state.copyWith(status: UserStatus.addOnlineUserSuccessful));
    return;

  }

  Future<void> removeOnlineUser({required int? userId}) async {

    emit(state.copyWith(status: UserStatus.removeOnlineUserInProgress));
    final either = await userRepository.removeOnlineUser(userId: userId);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.removeOnlineUserFailed, message: l));
      return;
    }

    emit(state.copyWith(status: UserStatus.removeOnlineUserSuccessful));
    return;

  }


  /// report user
  Future<void> reportUser({required int? offenderId, required String reason}) async {

    failed(String message) {
      emit(state.copyWith(status: UserStatus.reportUserFailed, message: message));
    }


    emit(state.copyWith(status: UserStatus.reportUserInProgress));

    // once user is connected to the network, just assume post is successful
    if(!(await isNetworkConnected())) {
      failed("You're not connected to the internet");
      return;
    }

    emit(state.copyWith(status: UserStatus.reportUserSuccessful));
    final either = await userRepository.reportUser(offenderId: offenderId, reason: reason);
    if(either.isLeft()){
      final l = either.asLeft();
      failed(l);
      return;
    }

    // successful do nothing

  }

  Future<void> getUserBlockStatus({required int? profileId}) async {
    emit(state.copyWith(status: UserStatus.getUserBlockStatusInProgress));
    final either = await userRepository.getUserBlockStatus(profileId: profileId);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.getUserBlockStatusFailed, message: l));
      return;
    }

    final r = either.asRight();
    final youBlockedUser = r.$1;
    final userBlockedYou = r.$2;
    setUserBlockedStatus(youBlockedUser: youBlockedUser, userBlockedYou: userBlockedYou);
    emit(state.copyWith(status: UserStatus.getUserBlockStatusSuccessful));
  }

  Future<void> blockUser({required int? offenderId, required String reason}) async {

    failed(String message) {
      emit(state.copyWith(status: UserStatus.blockUserFailed, message: message));
    }


    emit(state.copyWith(status: UserStatus.blockUserInProgress));

    // once user is connected to the network, just assume post is successful
    if(!(await isNetworkConnected())) {
      failed("You're not connected to the internet");
      return;
    }

    emit(state.copyWith(status: UserStatus.blockUserSuccessful));
    setUserBlockedStatus(youBlockedUser: true);
    final either = await userRepository.blockUser(offenderId: offenderId, reason: reason);
    if(either.isLeft()){
      final l = either.asLeft();
      failed(l);
      return;
    }

    // successful do nothing

  }

  Future<void> unBlockUser({required int? offenderId}) async {

    failed(String message) {
      emit(state.copyWith(status: UserStatus.unBlockUserFailed, message: message));
    }


    emit(state.copyWith(status: UserStatus.unBlockUserInProgress));

    // once user is connected to the network, just assume post is successful
    if(!(await isNetworkConnected())) {
      failed("You're not connected to the internet");
      return;
    }

    emit(state.copyWith(status: UserStatus.unBlockUserSuccessful));
    setUserBlockedStatus(youBlockedUser: false);
    final either = await userRepository.unblockUser(offenderId: offenderId);
    if(either.isLeft()){
      final l = either.asLeft();
      failed(l);
      return;
    }

    // successful do nothing

  }


  Future<void> getDisciplinaryRecord({required int? userId}) async {

    emit(state.copyWith(status: UserStatus.getDisciplinaryRecordInProgress));
    final either = await userRepository.getDisciplinaryRecord(userId: userId);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.getDisciplinaryRecordFailed, message: l));
      return;
    }

    final disRecord = either.asRight();
    emit(state.copyWith(status: UserStatus.getDisciplinaryRecordSuccessful, disciplinaryRecord: disRecord));
    return;

  }

  Future<void> markDisciplinaryRecordAsRead({required int? id}) async {

    emit(state.copyWith(status: UserStatus.markDisciplinaryRecordAsReadInProgress));
    final either = await userRepository.markDisciplinaryRecordAsRead(id: id);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.markDisciplinaryRecordAsReadFailed, message: l));
      return;
    }

    emit(state.copyWith(status: UserStatus.markDisciplinaryRecordAsReadSuccessful));
    return;

  }


}