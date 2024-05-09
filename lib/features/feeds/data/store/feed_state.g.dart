// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FeedStateCWProxy {
  FeedState status(FeedStatus status);

  FeedState message(String? message);

  FeedState feeds(List<FeedModel> feeds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeedState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeedState(...).copyWith(id: 12, name: "My name")
  /// ````
  FeedState call({
    FeedStatus? status,
    String? message,
    List<FeedModel>? feeds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFeedState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFeedState.copyWith.fieldName(...)`
class _$FeedStateCWProxyImpl implements _$FeedStateCWProxy {
  const _$FeedStateCWProxyImpl(this._value);

  final FeedState _value;

  @override
  FeedState status(FeedStatus status) => this(status: status);

  @override
  FeedState message(String? message) => this(message: message);

  @override
  FeedState feeds(List<FeedModel> feeds) => this(feeds: feeds);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeedState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeedState(...).copyWith(id: 12, name: "My name")
  /// ````
  FeedState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? feeds = const $CopyWithPlaceholder(),
  }) {
    return FeedState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as FeedStatus,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      feeds: feeds == const $CopyWithPlaceholder() || feeds == null
          ? _value.feeds
          // ignore: cast_nullable_to_non_nullable
          : feeds as List<FeedModel>,
    );
  }
}

extension $FeedStateCopyWith on FeedState {
  /// Returns a callable class that can be used as follows: `instanceOfFeedState.copyWith(...)` or like so:`instanceOfFeedState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FeedStateCWProxy get copyWith => _$FeedStateCWProxyImpl(this);
}
