// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NotificationModelCWProxy {
  NotificationModel id(int? id);

  NotificationModel title(String? title);

  NotificationModel message(String? message);

  NotificationModel readAt(DateTime? readAt);

  NotificationModel seenAt(DateTime? seenAt);

  NotificationModel type(String? type);

  NotificationModel createdAt(DateTime? createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationModel(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationModel call({
    int? id,
    String? title,
    String? message,
    DateTime? readAt,
    DateTime? seenAt,
    String? type,
    DateTime? createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNotificationModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNotificationModel.copyWith.fieldName(...)`
class _$NotificationModelCWProxyImpl implements _$NotificationModelCWProxy {
  const _$NotificationModelCWProxyImpl(this._value);

  final NotificationModel _value;

  @override
  NotificationModel id(int? id) => this(id: id);

  @override
  NotificationModel title(String? title) => this(title: title);

  @override
  NotificationModel message(String? message) => this(message: message);

  @override
  NotificationModel readAt(DateTime? readAt) => this(readAt: readAt);

  @override
  NotificationModel seenAt(DateTime? seenAt) => this(seenAt: seenAt);

  @override
  NotificationModel type(String? type) => this(type: type);

  @override
  NotificationModel createdAt(DateTime? createdAt) =>
      this(createdAt: createdAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationModel(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? readAt = const $CopyWithPlaceholder(),
    Object? seenAt = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return NotificationModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      readAt: readAt == const $CopyWithPlaceholder()
          ? _value.readAt
          // ignore: cast_nullable_to_non_nullable
          : readAt as DateTime?,
      seenAt: seenAt == const $CopyWithPlaceholder()
          ? _value.seenAt
          // ignore: cast_nullable_to_non_nullable
          : seenAt as DateTime?,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
    );
  }
}

extension $NotificationModelCopyWith on NotificationModel {
  /// Returns a callable class that can be used as follows: `instanceOfNotificationModel.copyWith(...)` or like so:`instanceOfNotificationModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NotificationModelCWProxy get copyWith =>
      _$NotificationModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      seenAt: json['seen_at'] == null
          ? null
          : DateTime.parse(json['seen_at'] as String),
      type: json['type'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'title': instance.title,
      'read_at': instance.readAt?.toIso8601String(),
      'seen_at': instance.seenAt?.toIso8601String(),
      'type': instance.type,
      'created_at': instance.createdAt?.toIso8601String(),
    };
