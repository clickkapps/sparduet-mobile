// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatStateCWProxy {
  ChatState message(String message);

  ChatState status(ChatStatus status);

  ChatState chatConnections(List<ChatModel> chatConnections);

  ChatState unreadMessages(int unreadMessages);

  ChatState suggestedChatUsers(List<UserModel> suggestedChatUsers);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatState call({
    String? message,
    ChatStatus? status,
    List<ChatModel>? chatConnections,
    int? unreadMessages,
    List<UserModel>? suggestedChatUsers,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatState.copyWith.fieldName(...)`
class _$ChatStateCWProxyImpl implements _$ChatStateCWProxy {
  const _$ChatStateCWProxyImpl(this._value);

  final ChatState _value;

  @override
  ChatState message(String message) => this(message: message);

  @override
  ChatState status(ChatStatus status) => this(status: status);

  @override
  ChatState chatConnections(List<ChatModel> chatConnections) =>
      this(chatConnections: chatConnections);

  @override
  ChatState unreadMessages(int unreadMessages) =>
      this(unreadMessages: unreadMessages);

  @override
  ChatState suggestedChatUsers(List<UserModel> suggestedChatUsers) =>
      this(suggestedChatUsers: suggestedChatUsers);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? chatConnections = const $CopyWithPlaceholder(),
    Object? unreadMessages = const $CopyWithPlaceholder(),
    Object? suggestedChatUsers = const $CopyWithPlaceholder(),
  }) {
    return ChatState(
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ChatStatus,
      chatConnections: chatConnections == const $CopyWithPlaceholder() ||
              chatConnections == null
          ? _value.chatConnections
          // ignore: cast_nullable_to_non_nullable
          : chatConnections as List<ChatModel>,
      unreadMessages: unreadMessages == const $CopyWithPlaceholder() ||
              unreadMessages == null
          ? _value.unreadMessages
          // ignore: cast_nullable_to_non_nullable
          : unreadMessages as int,
      suggestedChatUsers: suggestedChatUsers == const $CopyWithPlaceholder() ||
              suggestedChatUsers == null
          ? _value.suggestedChatUsers
          // ignore: cast_nullable_to_non_nullable
          : suggestedChatUsers as List<UserModel>,
    );
  }
}

extension $ChatStateCopyWith on ChatState {
  /// Returns a callable class that can be used as follows: `instanceOfChatState.copyWith(...)` or like so:`instanceOfChatState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatStateCWProxy get copyWith => _$ChatStateCWProxyImpl(this);
}
