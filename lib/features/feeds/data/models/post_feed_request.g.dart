// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_feed_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PostFeedRequestCWProxy {
  PostFeedRequest mediaParts(List<Map<String, dynamic>> mediaParts);

  PostFeedRequest payloadParts(List<Map<String, dynamic>> payloadParts);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PostFeedRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PostFeedRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  PostFeedRequest call({
    List<Map<String, dynamic>>? mediaParts,
    List<Map<String, dynamic>>? payloadParts,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPostFeedRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPostFeedRequest.copyWith.fieldName(...)`
class _$PostFeedRequestCWProxyImpl implements _$PostFeedRequestCWProxy {
  const _$PostFeedRequestCWProxyImpl(this._value);

  final PostFeedRequest _value;

  @override
  PostFeedRequest mediaParts(List<Map<String, dynamic>> mediaParts) =>
      this(mediaParts: mediaParts);

  @override
  PostFeedRequest payloadParts(List<Map<String, dynamic>> payloadParts) =>
      this(payloadParts: payloadParts);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PostFeedRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PostFeedRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  PostFeedRequest call({
    Object? mediaParts = const $CopyWithPlaceholder(),
    Object? payloadParts = const $CopyWithPlaceholder(),
  }) {
    return PostFeedRequest(
      mediaParts:
          mediaParts == const $CopyWithPlaceholder() || mediaParts == null
              ? _value.mediaParts
              // ignore: cast_nullable_to_non_nullable
              : mediaParts as List<Map<String, dynamic>>,
      payloadParts:
          payloadParts == const $CopyWithPlaceholder() || payloadParts == null
              ? _value.payloadParts
              // ignore: cast_nullable_to_non_nullable
              : payloadParts as List<Map<String, dynamic>>,
    );
  }
}

extension $PostFeedRequestCopyWith on PostFeedRequest {
  /// Returns a callable class that can be used as follows: `instanceOfPostFeedRequest.copyWith(...)` or like so:`instanceOfPostFeedRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PostFeedRequestCWProxy get copyWith => _$PostFeedRequestCWProxyImpl(this);
}
