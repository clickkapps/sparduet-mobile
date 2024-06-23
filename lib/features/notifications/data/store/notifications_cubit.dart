import 'dart:async';
import 'package:ably_flutter/ably_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/home/data/events/home_broadcast_event.dart';
import 'package:sparkduet/features/home/data/repositories/home_broadcast_repository.dart';
import 'package:sparkduet/features/home/data/repositories/socket_connection_repository.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_state.dart';
import '../repositories/notifications_repository.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  
  final NotificationsRepository notificationsRepository;
  final SocketConnectionRepository socketConnectionRepository;
  StreamSubscription? ablySubscription;
  NotificationsCubit({required this.notificationsRepository, required this.socketConnectionRepository}) : super (const NotificationsState());

  void listenToServerNotificationUpdates({required AuthUserModel? authUser}) async {
    final channelId = "users.${authUser?.id}.general-notifications";
    final channel = socketConnectionRepository.realtimeInstance?.channels.get("public:$channelId");
    ablySubscription = channel?.subscribe().listen((message) {
      debugPrint('Message received: ${message.data}');
    });

  }

  @override
  Future<void> close() {
    ablySubscription?.cancel();
    return super.close();
  }


}