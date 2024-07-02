import 'dart:async';
import 'package:ably_flutter/ably_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/home/data/events/home_broadcast_event.dart';
import 'package:sparkduet/features/home/data/repositories/home_broadcast_repository.dart';
import 'package:sparkduet/features/home/data/repositories/socket_connection_repository.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';
import 'package:sparkduet/features/notifications/data/models/notification_model.dart';
import 'package:sparkduet/features/notifications/data/store/enums.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_state.dart';
import '../repositories/notifications_repository.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  
  final NotificationsRepository notificationsRepository;
  final SocketConnectionRepository socketConnectionRepository;
  StreamSubscription? ablySubscription;
  NotificationsCubit({required this.notificationsRepository, required this.socketConnectionRepository}) : super (const NotificationsState());

  void listenToServerNotificationUpdates({required AuthUserModel? authUser}) async {
    final channelId = "users.${authUser?.id}.count-general-unseen-notifications";
    final channel = socketConnectionRepository.realtimeInstance?.channels.get("public:$channelId");
    ablySubscription = channel?.subscribe().listen((event) {
      final data = event.data as Map<Object?, Object?>;
      final json = convertMap(data);
      final count = json['count'] as int;
      emit(state.copyWith(status: NotificationStatus.countUnseenNotificationsInProgress));
      emit(state.copyWith(status: NotificationStatus.countUnseenNotificationsSuccessful,
          count: count
      ));

    });

  }

  @override
  Future<void> close() {
    ablySubscription?.cancel();
    return super.close();
  }

  void clearState() {
    emit(const NotificationsState());
  }

  void countUnseenNotifications() async {
    emit(state.copyWith(status: NotificationStatus.countUnseenNotificationsInProgress));
    final either = await notificationsRepository.countUnseenNotifications();
    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: NotificationStatus.countUnseenNotificationsFailed, message: l));
      return;
    }
    final r = either.asRight();
    emit(state.copyWith(status: NotificationStatus.countUnseenNotificationsSuccessful,
      count: r.toInt()
    ));
  }

  Future<(String?, List<NotificationModel>?)> fetchNotifications({int? pageKey}) async {

    emit(state.copyWith(status: NotificationStatus.fetchNotificationsInProgress));
    final either = await notificationsRepository.fetchNotifications(pageKey: pageKey);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: NotificationStatus.fetchNotificationsFailed, message: l));
      return (l, null);
    }


    final newItems = either.asRight();
    final List<NotificationModel> list = <NotificationModel>[...state.notifications];
    if(pageKey == 1){
      // if its first page request remove all existing threads
      list.clear();
    }
    list.addAll(newItems);
    emit(state.copyWith(status: NotificationStatus.fetchNotificationsSuccessful, notifications: list));
    return (null, newItems);

  }

  void markNotificationAsSeen() async {
    emit(state.copyWith(status: NotificationStatus.markNotificationAsSeenInProgress));
    final either = await notificationsRepository.markNotificationsAsSeen();
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: NotificationStatus.markNotificationAsSeenFailed, message: l));
      return;
    }
    // successful
    emit(state.copyWith(status: NotificationStatus.markNotificationAsSeenSuccessful, count: 0));

  }

  void markNotificationAsRead({int? notificationId}) async {
    emit(state.copyWith(status: NotificationStatus.markNotificationAsReadInProgress));
    final either = await notificationsRepository.markNotificationAsRead(notificationId: notificationId);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: NotificationStatus.markNotificationAsReadFailed, message: l));
      return;
    }

    final notifications = <NotificationModel>[...state.notifications];
    final index = notifications.indexWhere((element) => element.id == notificationId);
    if(index > -1) {
      notifications[index] = notifications[index].copyWith(
        readAt: DateTime.now()
      );
    }
    // successful
    emit(state.copyWith(status: NotificationStatus.markNotificationAsReadSuccessful, notifications: notifications));

  }

}