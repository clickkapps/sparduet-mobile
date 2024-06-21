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
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageModelAdapter extends TypeAdapter<ChatMessageModel> {
  @override
  final int typeId = 2;

  @override
  ChatMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessageModel(
      id: fields[0] as int?,
      chatConnectionId: fields[1] as int?,
      clientId: fields[2] as String?,
      text: fields[3] as String?,
      parent: fields[4] as ChatMessageModel?,
      createdAt: fields[5] as DateTime?,
      attachmentPath: fields[7] as String?,
      attachmentType: fields[8] as String?,
      sentById: fields[9] as int?,
      sentToId: fields[10] as int?,
      deletedAt: fields[11] as DateTime?,
      deliveredAt: fields[12] as DateTime?,
      seenAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessageModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.chatConnectionId)
      ..writeByte(2)
      ..write(obj.clientId)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.parent)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.attachmentPath)
      ..writeByte(8)
      ..write(obj.attachmentType)
      ..writeByte(9)
      ..write(obj.sentById)
      ..writeByte(10)
      ..write(obj.sentToId)
      ..writeByte(11)
      ..write(obj.deletedAt)
      ..writeByte(12)
      ..write(obj.deliveredAt)
      ..writeByte(13)
      ..write(obj.seenAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
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
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
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
      'created_at': instance.createdAt?.toIso8601String(),
      'attachment_path': instance.attachmentPath,
      'attachment_type': instance.attachmentType,
      'sent_by_id': instance.sentById,
      'sent_to_id': instance.sentToId,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'delivered_at': instance.deliveredAt?.toIso8601String(),
      'seen_at': instance.seenAt?.toIso8601String(),
    };
