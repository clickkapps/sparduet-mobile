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
    );

Map<String, dynamic> _$ChatConnectionModelToJson(
        ChatConnectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participants': instance.participants?.map((e) => e.toJson()).toList(),
      'lastMessage': instance.lastMessage?.toJson(),
      'matched_at': instance.matchedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
