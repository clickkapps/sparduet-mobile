// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatMessageModelCWProxy {
  ChatMessageModel id(int? id);

  ChatMessageModel chatConnectionId(int? chatConnectionId);

  ChatMessageModel clientId(String? clientId);

  ChatMessageModel text(String? text);

  ChatMessageModel parent(ChatMessageModel? parent);

  ChatMessageModel createdAt(DateTime? createdAt);

  ChatMessageModel attachmentPath(String? attachmentPath);

  ChatMessageModel attachmentType(String? attachmentType);

  ChatMessageModel sentById(int? sentById);

  ChatMessageModel sentToId(int? sentToId);

  ChatMessageModel deletedAt(DateTime? deletedAt);

  ChatMessageModel deliveredAt(DateTime? deliveredAt);

  ChatMessageModel seenAt(DateTime? seenAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatMessageModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatMessageModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatMessageModel call({
    int? id,
    int? chatConnectionId,
    String? clientId,
    String? text,
    ChatMessageModel? parent,
    DateTime? createdAt,
    String? attachmentPath,
    String? attachmentType,
    int? sentById,
    int? sentToId,
    DateTime? deletedAt,
    DateTime? deliveredAt,
    DateTime? seenAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatMessageModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatMessageModel.copyWith.fieldName(...)`
class _$ChatMessageModelCWProxyImpl implements _$ChatMessageModelCWProxy {
  const _$ChatMessageModelCWProxyImpl(this._value);

  final ChatMessageModel _value;

  @override
  ChatMessageModel id(int? id) => this(id: id);

  @override
  ChatMessageModel chatConnectionId(int? chatConnectionId) =>
      this(chatConnectionId: chatConnectionId);

  @override
  ChatMessageModel clientId(String? clientId) => this(clientId: clientId);

  @override
  ChatMessageModel text(String? text) => this(text: text);

  @override
  ChatMessageModel parent(ChatMessageModel? parent) => this(parent: parent);

  @override
  ChatMessageModel createdAt(DateTime? createdAt) => this(createdAt: createdAt);

  @override
  ChatMessageModel attachmentPath(String? attachmentPath) =>
      this(attachmentPath: attachmentPath);

  @override
  ChatMessageModel attachmentType(String? attachmentType) =>
      this(attachmentType: attachmentType);

  @override
  ChatMessageModel sentById(int? sentById) => this(sentById: sentById);

  @override
  ChatMessageModel sentToId(int? sentToId) => this(sentToId: sentToId);

  @override
  ChatMessageModel deletedAt(DateTime? deletedAt) => this(deletedAt: deletedAt);

  @override
  ChatMessageModel deliveredAt(DateTime? deliveredAt) =>
      this(deliveredAt: deliveredAt);

  @override
  ChatMessageModel seenAt(DateTime? seenAt) => this(seenAt: seenAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatMessageModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatMessageModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatMessageModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? chatConnectionId = const $CopyWithPlaceholder(),
    Object? clientId = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? parent = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? attachmentPath = const $CopyWithPlaceholder(),
    Object? attachmentType = const $CopyWithPlaceholder(),
    Object? sentById = const $CopyWithPlaceholder(),
    Object? sentToId = const $CopyWithPlaceholder(),
    Object? deletedAt = const $CopyWithPlaceholder(),
    Object? deliveredAt = const $CopyWithPlaceholder(),
    Object? seenAt = const $CopyWithPlaceholder(),
  }) {
    return ChatMessageModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      chatConnectionId: chatConnectionId == const $CopyWithPlaceholder()
          ? _value.chatConnectionId
          // ignore: cast_nullable_to_non_nullable
          : chatConnectionId as int?,
      clientId: clientId == const $CopyWithPlaceholder()
          ? _value.clientId
          // ignore: cast_nullable_to_non_nullable
          : clientId as String?,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String?,
      parent: parent == const $CopyWithPlaceholder()
          ? _value.parent
          // ignore: cast_nullable_to_non_nullable
          : parent as ChatMessageModel?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      attachmentPath: attachmentPath == const $CopyWithPlaceholder()
          ? _value.attachmentPath
          // ignore: cast_nullable_to_non_nullable
          : attachmentPath as String?,
      attachmentType: attachmentType == const $CopyWithPlaceholder()
          ? _value.attachmentType
          // ignore: cast_nullable_to_non_nullable
          : attachmentType as String?,
      sentById: sentById == const $CopyWithPlaceholder()
          ? _value.sentById
          // ignore: cast_nullable_to_non_nullable
          : sentById as int?,
      sentToId: sentToId == const $CopyWithPlaceholder()
          ? _value.sentToId
          // ignore: cast_nullable_to_non_nullable
          : sentToId as int?,
      deletedAt: deletedAt == const $CopyWithPlaceholder()
          ? _value.deletedAt
          // ignore: cast_nullable_to_non_nullable
          : deletedAt as DateTime?,
      deliveredAt: deliveredAt == const $CopyWithPlaceholder()
          ? _value.deliveredAt
          // ignore: cast_nullable_to_non_nullable
          : deliveredAt as DateTime?,
      seenAt: seenAt == const $CopyWithPlaceholder()
          ? _value.seenAt
          // ignore: cast_nullable_to_non_nullable
          : seenAt as DateTime?,
    );
  }
}

extension $ChatMessageModelCopyWith on ChatMessageModel {
  /// Returns a callable class that can be used as follows: `instanceOfChatMessageModel.copyWith(...)` or like so:`instanceOfChatMessageModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatMessageModelCWProxy get copyWith => _$ChatMessageModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: json['id'] as int?,
      chatConnectionId: json['chat_connection_id'] as int?,
      clientId: json['client_id'] as String?,
      text: json['text'] as String?,
      parent: json['parent'] == null
          ? null
          : ChatMessageModel.fromJson(json['parent'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      attachmentPath: json['attachment_path'] as String?,
      attachmentType: json['attachment_type'] as String?,
      sentById: json['sent_by_id'] as int?,
      sentToId: json['sent_to_id'] as int?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      deliveredAt: json['delivered_at'] == null
          ? null
          : DateTime.parse(json['delivered_at'] as String),
      seenAt: json['seen_at'] == null
          ? null
          : DateTime.parse(json['seen_at'] as String),
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat_connection_id': instance.chatConnectionId,
      'client_id': instance.clientId,
      'text': instance.text,
      'parent': instance.parent?.toJson(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'attachment_path': instance.attachmentPath,
      'attachment_type': instance.attachmentType,
      'sent_by_id': instance.sentById,
      'sent_to_id': instance.sentToId,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'delivered_at': instance.deliveredAt?.toIso8601String(),
      'seen_at': instance.seenAt?.toIso8601String(),
    };
