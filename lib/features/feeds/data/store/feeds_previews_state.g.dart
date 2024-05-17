// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_previews_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FeedsPreviewsStateCWProxy {
  FeedsPreviewsState status(FeedStatus status);

  FeedsPreviewsState message(String? message);

  FeedsPreviewsState feeds(List<FeedModel> feeds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeedsPreviewsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeedsPreviewsState(...).copyWith(id: 12, name: "My name")
  /// ````
  FeedsPreviewsState call({
    FeedStatus? status,
    String? message,
    List<FeedModel>? feeds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFeedsPreviewsState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFeedsPreviewsState.copyWith.fieldName(...)`
class _$FeedsPreviewsStateCWProxyImpl implements _$FeedsPreviewsStateCWProxy {
  const _$FeedsPreviewsStateCWProxyImpl(this._value);

  final FeedsPreviewsState _value;

  @override
  FeedsPreviewsState status(FeedStatus status) => this(status: status);

  @override
  FeedsPreviewsState message(String? message) => this(message: message);

  @override
  FeedsPreviewsState feeds(List<FeedModel> feeds) => this(feeds: feeds);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeedsPreviewsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeedsPreviewsState(...).copyWith(id: 12, name: "My name")
  /// ````
  FeedsPreviewsState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? feeds = const $CopyWithPlaceholder(),
  }) {
    return FeedsPreviewsState(
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

extension $FeedsPreviewsStateCopyWith on FeedsPreviewsState {
  /// Returns a callable class that can be used as follows: `instanceOfFeedsPreviewsState.copyWith(...)` or like so:`instanceOfFeedsPreviewsState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FeedsPreviewsStateCWProxy get copyWith =>
      _$FeedsPreviewsStateCWProxyImpl(this);
}
