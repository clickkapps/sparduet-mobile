import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_state.dart';
import 'package:sparkduet/network/api_routes.dart';

import '../../../home/data/repositories/socket_connection_repository.dart';
import '../repositories/notifications_repository.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  
  final NotificationsRepository notificationsRepository;
  final SocketConnectionRepository socketConnectionRepository;
  NotificationsCubit({required this.notificationsRepository, required this.socketConnectionRepository}) : super (const NotificationsState());


  void listenToNotificationsCount(AuthUserModel? authUser) async {
    
    socketConnectionRepository.getWebSocketConnection(AppApiRoutes.webSocketConnection(userId: authUser?.id), onEvent: (event) {
      debugPrint("customLog:listenToNotificationsCount: data received: ${event.data}");
    });
    
  }


}