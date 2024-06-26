import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/home/data/repositories/socket_connection_repository.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/data/repositories/user_repository.dart';
import 'package:sparkduet/features/users/data/store/enums.dart';
import 'package:sparkduet/features/users/data/store/user_state.dart';

class UserCubit extends Cubit<UserState> {

  final UserRepository userRepository;
  final SocketConnectionRepository socketConnectionRepository;
  StreamSubscription? ablySubscription;
  UserCubit({required this.userRepository, required this.socketConnectionRepository}) : super(const UserState());

  void listenToServerNotificationUpdates({required AuthUserModel? authUser}) async {
    final channelId = "users.${authUser?.id}.unread-profile-views-counted";
    final channel = socketConnectionRepository.realtimeInstance?.channels.get("public:$channelId");
    ablySubscription = channel?.subscribe().listen((event) {
      final data = event.data as Map<Object?, Object?>;
      final json = convertMap(data);
      final count = json['count'] as int;
      emit(state.copyWith(status: UserStatus.countUnreadProfileViewersInProgress));
      emit(state.copyWith(status: UserStatus.countUnreadProfileViewersSuccessful, unreadViewersCount: count));

    });

  }

  void setUser(UserModel user) {
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


}