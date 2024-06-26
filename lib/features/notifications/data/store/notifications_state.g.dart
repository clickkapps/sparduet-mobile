// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NotificationsStateCWProxy {
  NotificationsState status(NotificationStatus status);

  NotificationsState message(String? message);

  NotificationsState count(int count);

  NotificationsState notifications(List<NotificationModel> notifications);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationsState(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationsState call({
    NotificationStatus? status,
    String? message,
    int? count,
    List<NotificationModel>? notifications,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNotificationsState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNotificationsState.copyWith.fieldName(...)`
class _$NotificationsStateCWProxyImpl implements _$NotificationsStateCWProxy {
  const _$NotificationsStateCWProxyImpl(this._value);

  final NotificationsState _value;

  @override
  NotificationsState status(NotificationStatus status) => this(status: status);

  @override
  NotificationsState message(String? message) => this(message: message);

  @override
  NotificationsState count(int count) => this(count: count);

  @override
  NotificationsState notifications(List<NotificationModel> notifications) =>
      this(notifications: notifications);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationsState(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationsState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? notifications = const $CopyWithPlaceholder(),
  }) {
    return NotificationsState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as NotificationStatus,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      count: count == const $CopyWithPlaceholder() || count == null
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as int,
      notifications:
          notifications == const $CopyWithPlaceholder() || notifications == null
              ? _value.notifications
              // ignore: cast_nullable_to_non_nullable
              : notifications as List<NotificationModel>,
    );
  }
}

extension $NotificationsStateCopyWith on NotificationsState {
  /// Returns a callable class that can be used as follows: `instanceOfNotificationsState.copyWith(...)` or like so:`instanceOfNotificationsState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NotificationsStateCWProxy get copyWith =>
      _$NotificationsStateCWProxyImpl(this);
}
