// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_feed_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PostFeedRequestCWProxy {
  PostFeedRequest id(String id);

  PostFeedRequest media(MediaModel media);

  PostFeedRequest purpose(PostFeedPurpose? purpose);

  PostFeedRequest status(PostItemStatus status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PostFeedRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PostFeedRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  PostFeedRequest call({
    String? id,
    MediaModel? media,
    PostFeedPurpose? purpose,
    PostItemStatus? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPostFeedRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPostFeedRequest.copyWith.fieldName(...)`
class _$PostFeedRequestCWProxyImpl implements _$PostFeedRequestCWProxy {
  const _$PostFeedRequestCWProxyImpl(this._value);

  final PostFeedRequest _value;

  @override
  PostFeedRequest id(String id) => this(id: id);

  @override
  PostFeedRequest media(MediaModel media) => this(media: media);

  @override
  PostFeedRequest purpose(PostFeedPurpose? purpose) => this(purpose: purpose);

  @override
  PostFeedRequest status(PostItemStatus status) => this(status: status);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PostFeedRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PostFeedRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  PostFeedRequest call({
    Object? id = const $CopyWithPlaceholder(),
    Object? media = const $CopyWithPlaceholder(),
    Object? purpose = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return PostFeedRequest(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      media: media == const $CopyWithPlaceholder() || media == null
          ? _value.media
          // ignore: cast_nullable_to_non_nullable
          : media as MediaModel,
      purpose: purpose == const $CopyWithPlaceholder()
          ? _value.purpose
          // ignore: cast_nullable_to_non_nullable
          : purpose as PostFeedPurpose?,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as PostItemStatus,
    );
  }
}

extension $PostFeedRequestCopyWith on PostFeedRequest {
  /// Returns a callable class that can be used as follows: `instanceOfPostFeedRequest.copyWith(...)` or like so:`instanceOfPostFeedRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PostFeedRequestCWProxy get copyWith => _$PostFeedRequestCWProxyImpl(this);
}
