import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/notifications/data/store/enums.dart';

part 'notifications_state.g.dart';

@CopyWith()
class NotificationsState extends Equatable{
  final String? message;
  final NotificationStatus status;
  final int count;

  const NotificationsState({this.status = NotificationStatus.initial, this.message, this.count = 0});

  @override
  List<Object?> get props => [count, status, message];

}