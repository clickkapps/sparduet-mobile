// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_connection_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatConnectionModelCWProxy {
  ChatConnectionModel id(int? id);

  ChatConnectionModel participants(List<UserModel>? participants);

  ChatConnectionModel lastMessage(ChatMessageModel? lastMessage);

  ChatConnectionModel createdAt(DateTime? createdAt);

  ChatConnectionModel matchedAt(DateTime? matchedAt);

  ChatConnectionModel readFirstImpressionNoteAt(
      DateTime? readFirstImpressionNoteAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatConnectionModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatConnectionModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatConnectionModel call({
    int? id,
    List<UserModel>? participants,
    ChatMessageModel? lastMessage,
    DateTime? createdAt,
    DateTime? matchedAt,
    DateTime? readFirstImpressionNoteAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatConnectionModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatConnectionModel.copyWith.fieldName(...)`
class _$ChatConnectionModelCWProxyImpl implements _$ChatConnectionModelCWProxy {
  const _$ChatConnectionModelCWProxyImpl(this._value);

  final ChatConnectionModel _value;

  @override
  ChatConnectionModel id(int? id) => this(id: id);

  @override
  ChatConnectionModel participants(List<UserModel>? participants) =>
      this(participants: participants);

  @override
  ChatConnectionModel lastMessage(ChatMessageModel? lastMessage) =>
      this(lastMessage: lastMessage);

  @override
  ChatConnectionModel createdAt(DateTime? createdAt) =>
      this(createdAt: createdAt);

  @override
  ChatConnectionModel matchedAt(DateTime? matchedAt) =>
      this(matchedAt: matchedAt);

  @override
  ChatConnectionModel readFirstImpressionNoteAt(
          DateTime? readFirstImpressionNoteAt) =>
      this(readFirstImpressionNoteAt: readFirstImpressionNoteAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatConnectionModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatConnectionModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatConnectionModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? participants = const $CopyWithPlaceholder(),
    Object? lastMessage = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? matchedAt = const $CopyWithPlaceholder(),
    Object? readFirstImpressionNoteAt = const $CopyWithPlaceholder(),
  }) {
    return ChatConnectionModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      participants: participants == const $CopyWithPlaceholder()
          ? _value.participants
          // ignore: cast_nullable_to_non_nullable
          : participants as List<UserModel>?,
      lastMessage: lastMessage == const $CopyWithPlaceholder()
          ? _value.lastMessage
          // ignore: cast_nullable_to_non_nullable
          : lastMessage as ChatMessageModel?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      matchedAt: matchedAt == const $CopyWithPlaceholder()
          ? _value.matchedAt
          // ignore: cast_nullable_to_non_nullable
          : matchedAt as DateTime?,
      readFirstImpressionNoteAt:
          readFirstImpressionNoteAt == const $CopyWithPlaceholder()
              ? _value.readFirstImpressionNoteAt
              // ignore: cast_nullable_to_non_nullable
              : readFirstImpressionNoteAt as DateTime?,
    );
  }
}

extension $ChatConnectionModelCopyWith on ChatConnectionModel {
  /// Returns a callable class that can be used as follows: `instanceOfChatConnectionModel.copyWith(...)` or like so:`instanceOfChatConnectionModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatConnectionModelCWProxy get copyWith =>
      _$ChatConnectionModelCWProxyImpl(this);
}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatConnectionModelAdapter extends TypeAdapter<ChatConnectionModel> {
  @override
  final int typeId = 1;

  @override
  ChatConnectionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatConnectionModel(
      id: fields[0] as int?,
      participants: (fields[6] as List?)?.cast<UserModel>(),
      lastMessage: fields[2] as ChatMessageModel?,
      createdAt: fields[5] as DateTime?,
      matchedAt: fields[3] as DateTime?,
      readFirstImpressionNoteAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatConnectionModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.lastMessage)
      ..writeByte(3)
      ..write(obj.matchedAt)
      ..writeByte(4)
      ..write(obj.readFirstImpressionNoteAt)
      ..writeByte(6)
      ..write(obj.participants)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConnectionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatConnectionModel _$ChatConnectionModelFromJson(Map<String, dynamic> json) =>
    ChatConnectionModel(
      id: json['id'] as int?,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessageModel.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      matchedAt: json['matched_at'] == null
          ? null
          : DateTime.parse(json['matched_at'] as String),
      readFirstImpressionNoteAt: json['read_first_impression_note_at'] == null
          ? null
          : DateTime.parse(json['read_first_impression_note_at'] as String),
    );

Map<String, dynamic> _$ChatConnectionModelToJson(
        ChatConnectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lastMessage': instance.lastMessage?.toJson(),
      'matched_at': instance.matchedAt?.toIso8601String(),
      'read_first_impression_note_at':
          instance.readFirstImpressionNoteAt?.toIso8601String(),
      'participants': instance.participants?.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
