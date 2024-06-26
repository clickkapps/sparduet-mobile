import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/notifications/data/models/notification_model.dart';
import 'package:sparkduet/features/notifications/data/store/enums.dart';

part 'notifications_state.g.dart';

@CopyWith()
class NotificationsState extends Equatable{
  final String? message;
  final NotificationStatus status;
  final List<NotificationModel> notifications;
  final int count;

  const NotificationsState({this.status = NotificationStatus.initial,
    this.message, this.count = 0,
    this.notifications = const  []
  });

  @override
  List<Object?> get props => [count, status, message, notifications];

}