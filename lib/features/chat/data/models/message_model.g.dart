// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MessageModelCWProxy {
  MessageModel id(String? id);

  MessageModel message(String? message);

  MessageModel parent(MessageModel? parent);

  MessageModel sentBy(ChatUserModel? sentBy);

  MessageModel sentTo(ChatUserModel? sentTo);

  MessageModel createdAt(DateTime? createdAt);

  MessageModel attachments(List<String>? attachments);

  MessageModel delivered(bool delivered);

  MessageModel seen(bool seen);

  MessageModel deleted(bool deleted);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MessageModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MessageModel(...).copyWith(id: 12, name: "My name")
  /// ````
  MessageModel call({
    String? id,
    String? message,
    MessageModel? parent,
    ChatUserModel? sentBy,
    ChatUserModel? sentTo,
    DateTime? createdAt,
    List<String>? attachments,
    bool? delivered,
    bool? seen,
    bool? deleted,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMessageModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMessageModel.copyWith.fieldName(...)`
class _$MessageModelCWProxyImpl implements _$MessageModelCWProxy {
  const _$MessageModelCWProxyImpl(this._value);

  final MessageModel _value;

  @override
  MessageModel id(String? id) => this(id: id);

  @override
  MessageModel message(String? message) => this(message: message);

  @override
  MessageModel parent(MessageModel? parent) => this(parent: parent);

  @override
  MessageModel sentBy(ChatUserModel? sentBy) => this(sentBy: sentBy);

  @override
  MessageModel sentTo(ChatUserModel? sentTo) => this(sentTo: sentTo);

  @override
  MessageModel createdAt(DateTime? createdAt) => this(createdAt: createdAt);

  @override
  MessageModel attachments(List<String>? attachments) =>
      this(attachments: attachments);

  @override
  MessageModel delivered(bool delivered) => this(delivered: delivered);

  @override
  MessageModel seen(bool seen) => this(seen: seen);

  @override
  MessageModel deleted(bool deleted) => this(deleted: deleted);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MessageModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MessageModel(...).copyWith(id: 12, name: "My name")
  /// ````
  MessageModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? parent = const $CopyWithPlaceholder(),
    Object? sentBy = const $CopyWithPlaceholder(),
    Object? sentTo = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? attachments = const $CopyWithPlaceholder(),
    Object? delivered = const $CopyWithPlaceholder(),
    Object? seen = const $CopyWithPlaceholder(),
    Object? deleted = const $CopyWithPlaceholder(),
  }) {
    return MessageModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      parent: parent == const $CopyWithPlaceholder()
          ? _value.parent
          // ignore: cast_nullable_to_non_nullable
          : parent as MessageModel?,
      sentBy: sentBy == const $CopyWithPlaceholder()
          ? _value.sentBy
          // ignore: cast_nullable_to_non_nullable
          : sentBy as ChatUserModel?,
      sentTo: sentTo == const $CopyWithPlaceholder()
          ? _value.sentTo
          // ignore: cast_nullable_to_non_nullable
          : sentTo as ChatUserModel?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      attachments: attachments == const $CopyWithPlaceholder()
          ? _value.attachments
          // ignore: cast_nullable_to_non_nullable
          : attachments as List<String>?,
      delivered: delivered == const $CopyWithPlaceholder() || delivered == null
          ? _value.delivered
          // ignore: cast_nullable_to_non_nullable
          : delivered as bool,
      seen: seen == const $CopyWithPlaceholder() || seen == null
          ? _value.seen
          // ignore: cast_nullable_to_non_nullable
          : seen as bool,
      deleted: deleted == const $CopyWithPlaceholder() || deleted == null
          ? _value.deleted
          // ignore: cast_nullable_to_non_nullable
          : deleted as bool,
    );
  }
}

extension $MessageModelCopyWith on MessageModel {
  /// Returns a callable class that can be used as follows: `instanceOfMessageModel.copyWith(...)` or like so:`instanceOfMessageModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MessageModelCWProxy get copyWith => _$MessageModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as String?,
      message: json['message'] as String?,
      parent: json['parent'] == null
          ? null
          : MessageModel.fromJson(json['parent'] as Map<String, dynamic>),
      sentBy: json['sentBy'] == null
          ? null
          : ChatUserModel.fromJson(json['sentBy'] as Map<String, dynamic>),
      sentTo: json['sentTo'] == null
          ? null
          : ChatUserModel.fromJson(json['sentTo'] as Map<String, dynamic>),
      createdAt: const ServerTimestampConverter().fromJson(json['createdAt']),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      delivered: json['delivered'] as bool? ?? true,
      seen: json['seen'] as bool? ?? false,
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'parent': instance.parent?.toJson(),
      'createdAt': const ServerTimestampConverter().toJson(instance.createdAt),
      'attachments': instance.attachments,
      'sentBy': instance.sentBy?.toJson(),
      'sentTo': instance.sentTo?.toJson(),
      'delivered': instance.delivered,
      'seen': instance.seen,
      'deleted': instance.deleted,
    };
