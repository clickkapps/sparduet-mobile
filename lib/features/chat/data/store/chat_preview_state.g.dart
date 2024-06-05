// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_preview_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatPreviewStateCWProxy {
  ChatPreviewState message(String message);

  ChatPreviewState status(ChatPreviewStatus status);

  ChatPreviewState reOrderedChatMessages(
      Map<DateTime, List<MessageModel>> reOrderedChatMessages);

  ChatPreviewState linearMessagesList(List<MessageModel> linearMessagesList);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatPreviewState call({
    String? message,
    ChatPreviewStatus? status,
    Map<DateTime, List<MessageModel>>? reOrderedChatMessages,
    List<MessageModel>? linearMessagesList,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatPreviewState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatPreviewState.copyWith.fieldName(...)`
class _$ChatPreviewStateCWProxyImpl implements _$ChatPreviewStateCWProxy {
  const _$ChatPreviewStateCWProxyImpl(this._value);

  final ChatPreviewState _value;

  @override
  ChatPreviewState message(String message) => this(message: message);

  @override
  ChatPreviewState status(ChatPreviewStatus status) => this(status: status);

  @override
  ChatPreviewState reOrderedChatMessages(
          Map<DateTime, List<MessageModel>> reOrderedChatMessages) =>
      this(reOrderedChatMessages: reOrderedChatMessages);

  @override
  ChatPreviewState linearMessagesList(List<MessageModel> linearMessagesList) =>
      this(linearMessagesList: linearMessagesList);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatPreviewState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? reOrderedChatMessages = const $CopyWithPlaceholder(),
    Object? linearMessagesList = const $CopyWithPlaceholder(),
  }) {
    return ChatPreviewState(
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ChatPreviewStatus,
      reOrderedChatMessages:
          reOrderedChatMessages == const $CopyWithPlaceholder() ||
                  reOrderedChatMessages == null
              ? _value.reOrderedChatMessages
              // ignore: cast_nullable_to_non_nullable
              : reOrderedChatMessages as Map<DateTime, List<MessageModel>>,
      linearMessagesList: linearMessagesList == const $CopyWithPlaceholder() ||
              linearMessagesList == null
          ? _value.linearMessagesList
          // ignore: cast_nullable_to_non_nullable
          : linearMessagesList as List<MessageModel>,
    );
  }
}

extension $ChatPreviewStateCopyWith on ChatPreviewState {
  /// Returns a callable class that can be used as follows: `instanceOfChatPreviewState.copyWith(...)` or like so:`instanceOfChatPreviewState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatPreviewStateCWProxy get copyWith => _$ChatPreviewStateCWProxyImpl(this);
}
