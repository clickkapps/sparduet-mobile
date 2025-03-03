// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_connections_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatConnectionStateCWProxy {
  ChatConnectionState message(String message);

  ChatConnectionState status(ChatConnectionStatus status);

  ChatConnectionState chatConnections(
      List<ChatConnectionModel> chatConnections);

  ChatConnectionState totalUnreadMessages(int totalUnreadMessages);

  ChatConnectionState suggestedChatUsers(List<UserModel> suggestedChatUsers);

  ChatConnectionState data(dynamic data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatConnectionState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatConnectionState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatConnectionState call({
    String? message,
    ChatConnectionStatus? status,
    List<ChatConnectionModel>? chatConnections,
    int? totalUnreadMessages,
    List<UserModel>? suggestedChatUsers,
    dynamic data,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatConnectionState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatConnectionState.copyWith.fieldName(...)`
class _$ChatConnectionStateCWProxyImpl implements _$ChatConnectionStateCWProxy {
  const _$ChatConnectionStateCWProxyImpl(this._value);

  final ChatConnectionState _value;

  @override
  ChatConnectionState message(String message) => this(message: message);

  @override
  ChatConnectionState status(ChatConnectionStatus status) =>
      this(status: status);

  @override
  ChatConnectionState chatConnections(
          List<ChatConnectionModel> chatConnections) =>
      this(chatConnections: chatConnections);

  @override
  ChatConnectionState totalUnreadMessages(int totalUnreadMessages) =>
      this(totalUnreadMessages: totalUnreadMessages);

  @override
  ChatConnectionState suggestedChatUsers(List<UserModel> suggestedChatUsers) =>
      this(suggestedChatUsers: suggestedChatUsers);

  @override
  ChatConnectionState data(dynamic data) => this(data: data);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatConnectionState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatConnectionState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatConnectionState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? chatConnections = const $CopyWithPlaceholder(),
    Object? totalUnreadMessages = const $CopyWithPlaceholder(),
    Object? suggestedChatUsers = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return ChatConnectionState(
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ChatConnectionStatus,
      chatConnections: chatConnections == const $CopyWithPlaceholder() ||
              chatConnections == null
          ? _value.chatConnections
          // ignore: cast_nullable_to_non_nullable
          : chatConnections as List<ChatConnectionModel>,
      totalUnreadMessages:
          totalUnreadMessages == const $CopyWithPlaceholder() ||
                  totalUnreadMessages == null
              ? _value.totalUnreadMessages
              // ignore: cast_nullable_to_non_nullable
              : totalUnreadMessages as int,
      suggestedChatUsers: suggestedChatUsers == const $CopyWithPlaceholder() ||
              suggestedChatUsers == null
          ? _value.suggestedChatUsers
          // ignore: cast_nullable_to_non_nullable
          : suggestedChatUsers as List<UserModel>,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as dynamic,
    );
  }
}

extension $ChatConnectionStateCopyWith on ChatConnectionState {
  /// Returns a callable class that can be used as follows: `instanceOfChatConnectionState.copyWith(...)` or like so:`instanceOfChatConnectionState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatConnectionStateCWProxy get copyWith =>
      _$ChatConnectionStateCWProxyImpl(this);
}
