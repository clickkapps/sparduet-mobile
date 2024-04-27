// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_preview_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FeedPreviewStateCWProxy {
  FeedPreviewState status(FeedStatus status);

  FeedPreviewState message(String? message);

  FeedPreviewState feed(FeedModel? feed);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeedPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeedPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  FeedPreviewState call({
    FeedStatus? status,
    String? message,
    FeedModel? feed,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFeedPreviewState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFeedPreviewState.copyWith.fieldName(...)`
class _$FeedPreviewStateCWProxyImpl implements _$FeedPreviewStateCWProxy {
  const _$FeedPreviewStateCWProxyImpl(this._value);

  final FeedPreviewState _value;

  @override
  FeedPreviewState status(FeedStatus status) => this(status: status);

  @override
  FeedPreviewState message(String? message) => this(message: message);

  @override
  FeedPreviewState feed(FeedModel? feed) => this(feed: feed);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeedPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeedPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  FeedPreviewState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? feed = const $CopyWithPlaceholder(),
  }) {
    return FeedPreviewState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as FeedStatus,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      feed: feed == const $CopyWithPlaceholder()
          ? _value.feed
          // ignore: cast_nullable_to_non_nullable
          : feed as FeedModel?,
    );
  }
}

extension $FeedPreviewStateCopyWith on FeedPreviewState {
  /// Returns a callable class that can be used as follows: `instanceOfFeedPreviewState.copyWith(...)` or like so:`instanceOfFeedPreviewState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FeedPreviewStateCWProxy get copyWith => _$FeedPreviewStateCWProxyImpl(this);
}
