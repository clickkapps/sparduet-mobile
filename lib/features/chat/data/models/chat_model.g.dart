// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatModelCWProxy {
  ChatModel id(String? id);

  ChatModel participants(List<ChatUserModel>? participants);

  ChatModel lastMessage(MessageModel? lastMessage);

  ChatModel createdAt(DateTime? createdAt);

  ChatModel participantIds(List<int?>? participantIds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatModel call({
    String? id,
    List<ChatUserModel>? participants,
    MessageModel? lastMessage,
    DateTime? createdAt,
    List<int?>? participantIds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatModel.copyWith.fieldName(...)`
class _$ChatModelCWProxyImpl implements _$ChatModelCWProxy {
  const _$ChatModelCWProxyImpl(this._value);

  final ChatModel _value;

  @override
  ChatModel id(String? id) => this(id: id);

  @override
  ChatModel participants(List<ChatUserModel>? participants) =>
      this(participants: participants);

  @override
  ChatModel lastMessage(MessageModel? lastMessage) =>
      this(lastMessage: lastMessage);

  @override
  ChatModel createdAt(DateTime? createdAt) => this(createdAt: createdAt);

  @override
  ChatModel participantIds(List<int?>? participantIds) =>
      this(participantIds: participantIds);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? participants = const $CopyWithPlaceholder(),
    Object? lastMessage = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? participantIds = const $CopyWithPlaceholder(),
  }) {
    return ChatModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      participants: participants == const $CopyWithPlaceholder()
          ? _value.participants
          // ignore: cast_nullable_to_non_nullable
          : participants as List<ChatUserModel>?,
      lastMessage: lastMessage == const $CopyWithPlaceholder()
          ? _value.lastMessage
          // ignore: cast_nullable_to_non_nullable
          : lastMessage as MessageModel?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      participantIds: participantIds == const $CopyWithPlaceholder()
          ? _value.participantIds
          // ignore: cast_nullable_to_non_nullable
          : participantIds as List<int?>?,
    );
  }
}

extension $ChatModelCopyWith on ChatModel {
  /// Returns a callable class that can be used as follows: `instanceOfChatModel.copyWith(...)` or like so:`instanceOfChatModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatModelCWProxy get copyWith => _$ChatModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      id: json['id'] as String?,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => ChatUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>),
      createdAt: const ServerTimestampConverter().fromJson(json['createdAt']),
      participantIds: (json['participantIds'] as List<dynamic>?)
          ?.map((e) => e as int?)
          .toList(),
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'id': instance.id,
      'participants': instance.participants?.map((e) => e.toJson()).toList(),
      'lastMessage': instance.lastMessage?.toJson(),
      'createdAt': const ServerTimestampConverter().toJson(instance.createdAt),
      'participantIds': instance.participantIds,
    };
