// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FeedModelCWProxy {
  FeedModel id(int? id);

  FeedModel user(UserModel? user);

  FeedModel description(String? description);

  FeedModel purpose(String? purpose);

  FeedModel commentsDisabledAt(DateTime? commentsDisabledAt);

  FeedModel blockedByAdminAt(bool? blockedByAdminAt);

  FeedModel mediaPath(String? mediaPath);

  FeedModel mediaType(FileType? mediaType);

  FeedModel assetId(String? assetId);

  FeedModel totalLikes(num? totalLikes);

  FeedModel hasLiked(num? hasLiked);

  FeedModel totalBookmarks(num? totalBookmarks);

  FeedModel hasBookmarked(bool? hasBookmarked);

  FeedModel totalComments(num? totalComments);

  FeedModel totalViews(num? totalViews);

  FeedModel userViewInfo(FeedViewInfo? userViewInfo);

  FeedModel deleteAt(DateTime? deleteAt);

  FeedModel videoSource(VideoSource videoSource);

  FeedModel status(String? status);

  FeedModel tempId(String? tempId);

  FeedModel flipFile(bool? flipFile);

  FeedModel disciplinaryAction(String? disciplinaryAction);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeedModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeedModel(...).copyWith(id: 12, name: "My name")
  /// ````
  FeedModel call({
    int? id,
    UserModel? user,
    String? description,
    String? purpose,
    DateTime? commentsDisabledAt,
    bool? blockedByAdminAt,
    String? mediaPath,
    FileType? mediaType,
    String? assetId,
    num? totalLikes,
    num? hasLiked,
    num? totalBookmarks,
    bool? hasBookmarked,
    num? totalComments,
    num? totalViews,
    FeedViewInfo? userViewInfo,
    DateTime? deleteAt,
    VideoSource? videoSource,
    String? status,
    String? tempId,
    bool? flipFile,
    String? disciplinaryAction,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFeedModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFeedModel.copyWith.fieldName(...)`
class _$FeedModelCWProxyImpl implements _$FeedModelCWProxy {
  const _$FeedModelCWProxyImpl(this._value);

  final FeedModel _value;

  @override
  FeedModel id(int? id) => this(id: id);

  @override
  FeedModel user(UserModel? user) => this(user: user);

  @override
  FeedModel description(String? description) => this(description: description);

  @override
  FeedModel purpose(String? purpose) => this(purpose: purpose);

  @override
  FeedModel commentsDisabledAt(DateTime? commentsDisabledAt) =>
      this(commentsDisabledAt: commentsDisabledAt);

  @override
  FeedModel blockedByAdminAt(bool? blockedByAdminAt) =>
      this(blockedByAdminAt: blockedByAdminAt);

  @override
  FeedModel mediaPath(String? mediaPath) => this(mediaPath: mediaPath);

  @override
  FeedModel mediaType(FileType? mediaType) => this(mediaType: mediaType);

  @override
  FeedModel assetId(String? assetId) => this(assetId: assetId);

  @override
  FeedModel totalLikes(num? totalLikes) => this(totalLikes: totalLikes);

  @override
  FeedModel hasLiked(num? hasLiked) => this(hasLiked: hasLiked);

  @override
  FeedModel totalBookmarks(num? totalBookmarks) =>
      this(totalBookmarks: totalBookmarks);

  @override
  FeedModel hasBookmarked(bool? hasBookmarked) =>
      this(hasBookmarked: hasBookmarked);

  @override
  FeedModel totalComments(num? totalComments) =>
      this(totalComments: totalComments);

  @override
  FeedModel totalViews(num? totalViews) => this(totalViews: totalViews);

  @override
  FeedModel userViewInfo(FeedViewInfo? userViewInfo) =>
      this(userViewInfo: userViewInfo);

  @override
  FeedModel deleteAt(DateTime? deleteAt) => this(deleteAt: deleteAt);

  @override
  FeedModel videoSource(VideoSource videoSource) =>
      this(videoSource: videoSource);

  @override
  FeedModel status(String? status) => this(status: status);

  @override
  FeedModel tempId(String? tempId) => this(tempId: tempId);

  @override
  FeedModel flipFile(bool? flipFile) => this(flipFile: flipFile);

  @override
  FeedModel disciplinaryAction(String? disciplinaryAction) =>
      this(disciplinaryAction: disciplinaryAction);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeedModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeedModel(...).copyWith(id: 12, name: "My name")
  /// ````
  FeedModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? purpose = const $CopyWithPlaceholder(),
    Object? commentsDisabledAt = const $CopyWithPlaceholder(),
    Object? blockedByAdminAt = const $CopyWithPlaceholder(),
    Object? mediaPath = const $CopyWithPlaceholder(),
    Object? mediaType = const $CopyWithPlaceholder(),
    Object? assetId = const $CopyWithPlaceholder(),
    Object? totalLikes = const $CopyWithPlaceholder(),
    Object? hasLiked = const $CopyWithPlaceholder(),
    Object? totalBookmarks = const $CopyWithPlaceholder(),
    Object? hasBookmarked = const $CopyWithPlaceholder(),
    Object? totalComments = const $CopyWithPlaceholder(),
    Object? totalViews = const $CopyWithPlaceholder(),
    Object? userViewInfo = const $CopyWithPlaceholder(),
    Object? deleteAt = const $CopyWithPlaceholder(),
    Object? videoSource = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? tempId = const $CopyWithPlaceholder(),
    Object? flipFile = const $CopyWithPlaceholder(),
    Object? disciplinaryAction = const $CopyWithPlaceholder(),
  }) {
    return FeedModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as UserModel?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      purpose: purpose == const $CopyWithPlaceholder()
          ? _value.purpose
          // ignore: cast_nullable_to_non_nullable
          : purpose as String?,
      commentsDisabledAt: commentsDisabledAt == const $CopyWithPlaceholder()
          ? _value.commentsDisabledAt
          // ignore: cast_nullable_to_non_nullable
          : commentsDisabledAt as DateTime?,
      blockedByAdminAt: blockedByAdminAt == const $CopyWithPlaceholder()
          ? _value.blockedByAdminAt
          // ignore: cast_nullable_to_non_nullable
          : blockedByAdminAt as bool?,
      mediaPath: mediaPath == const $CopyWithPlaceholder()
          ? _value.mediaPath
          // ignore: cast_nullable_to_non_nullable
          : mediaPath as String?,
      mediaType: mediaType == const $CopyWithPlaceholder()
          ? _value.mediaType
          // ignore: cast_nullable_to_non_nullable
          : mediaType as FileType?,
      assetId: assetId == const $CopyWithPlaceholder()
          ? _value.assetId
          // ignore: cast_nullable_to_non_nullable
          : assetId as String?,
      totalLikes: totalLikes == const $CopyWithPlaceholder()
          ? _value.totalLikes
          // ignore: cast_nullable_to_non_nullable
          : totalLikes as num?,
      hasLiked: hasLiked == const $CopyWithPlaceholder()
          ? _value.hasLiked
          // ignore: cast_nullable_to_non_nullable
          : hasLiked as num?,
      totalBookmarks: totalBookmarks == const $CopyWithPlaceholder()
          ? _value.totalBookmarks
          // ignore: cast_nullable_to_non_nullable
          : totalBookmarks as num?,
      hasBookmarked: hasBookmarked == const $CopyWithPlaceholder()
          ? _value.hasBookmarked
          // ignore: cast_nullable_to_non_nullable
          : hasBookmarked as bool?,
      totalComments: totalComments == const $CopyWithPlaceholder()
          ? _value.totalComments
          // ignore: cast_nullable_to_non_nullable
          : totalComments as num?,
      totalViews: totalViews == const $CopyWithPlaceholder()
          ? _value.totalViews
          // ignore: cast_nullable_to_non_nullable
          : totalViews as num?,
      userViewInfo: userViewInfo == const $CopyWithPlaceholder()
          ? _value.userViewInfo
          // ignore: cast_nullable_to_non_nullable
          : userViewInfo as FeedViewInfo?,
      deleteAt: deleteAt == const $CopyWithPlaceholder()
          ? _value.deleteAt
          // ignore: cast_nullable_to_non_nullable
          : deleteAt as DateTime?,
      videoSource:
          videoSource == const $CopyWithPlaceholder() || videoSource == null
              ? _value.videoSource
              // ignore: cast_nullable_to_non_nullable
              : videoSource as VideoSource,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String?,
      tempId: tempId == const $CopyWithPlaceholder()
          ? _value.tempId
          // ignore: cast_nullable_to_non_nullable
          : tempId as String?,
      flipFile: flipFile == const $CopyWithPlaceholder()
          ? _value.flipFile
          // ignore: cast_nullable_to_non_nullable
          : flipFile as bool?,
      disciplinaryAction: disciplinaryAction == const $CopyWithPlaceholder()
          ? _value.disciplinaryAction
          // ignore: cast_nullable_to_non_nullable
          : disciplinaryAction as String?,
    );
  }
}

extension $FeedModelCopyWith on FeedModel {
  /// Returns a callable class that can be used as follows: `instanceOfFeedModel.copyWith(...)` or like so:`instanceOfFeedModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FeedModelCWProxy get copyWith => _$FeedModelCWProxyImpl(this);
}

abstract class _$FeedViewInfoCWProxy {
  FeedViewInfo seenAt(DateTime? seenAt);

  FeedViewInfo watchedAt(DateTime? watchedAt);

  FeedViewInfo lastWatchedAt(DateTime? lastWatchedAt);

  FeedViewInfo watchedCount(num? watchedCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeedViewInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeedViewInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  FeedViewInfo call({
    DateTime? seenAt,
    DateTime? watchedAt,
    DateTime? lastWatchedAt,
    num? watchedCount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFeedViewInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFeedViewInfo.copyWith.fieldName(...)`
class _$FeedViewInfoCWProxyImpl implements _$FeedViewInfoCWProxy {
  const _$FeedViewInfoCWProxyImpl(this._value);

  final FeedViewInfo _value;

  @override
  FeedViewInfo seenAt(DateTime? seenAt) => this(seenAt: seenAt);

  @override
  FeedViewInfo watchedAt(DateTime? watchedAt) => this(watchedAt: watchedAt);

  @override
  FeedViewInfo lastWatchedAt(DateTime? lastWatchedAt) =>
      this(lastWatchedAt: lastWatchedAt);

  @override
  FeedViewInfo watchedCount(num? watchedCount) =>
      this(watchedCount: watchedCount);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeedViewInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeedViewInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  FeedViewInfo call({
    Object? seenAt = const $CopyWithPlaceholder(),
    Object? watchedAt = const $CopyWithPlaceholder(),
    Object? lastWatchedAt = const $CopyWithPlaceholder(),
    Object? watchedCount = const $CopyWithPlaceholder(),
  }) {
    return FeedViewInfo(
      seenAt: seenAt == const $CopyWithPlaceholder()
          ? _value.seenAt
          // ignore: cast_nullable_to_non_nullable
          : seenAt as DateTime?,
      watchedAt: watchedAt == const $CopyWithPlaceholder()
          ? _value.watchedAt
          // ignore: cast_nullable_to_non_nullable
          : watchedAt as DateTime?,
      lastWatchedAt: lastWatchedAt == const $CopyWithPlaceholder()
          ? _value.lastWatchedAt
          // ignore: cast_nullable_to_non_nullable
          : lastWatchedAt as DateTime?,
      watchedCount: watchedCount == const $CopyWithPlaceholder()
          ? _value.watchedCount
          // ignore: cast_nullable_to_non_nullable
          : watchedCount as num?,
    );
  }
}

extension $FeedViewInfoCopyWith on FeedViewInfo {
  /// Returns a callable class that can be used as follows: `instanceOfFeedViewInfo.copyWith(...)` or like so:`instanceOfFeedViewInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FeedViewInfoCWProxy get copyWith => _$FeedViewInfoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) => FeedModel(
      id: json['id'] as int?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      description: json['description'] as String?,
      purpose: json['purpose'] as String?,
      commentsDisabledAt: json['comments_disabled_at'] == null
          ? null
          : DateTime.parse(json['comments_disabled_at'] as String),
      blockedByAdminAt: json['blocked_by_admin_at'] as bool?,
      mediaPath: json['media_path'] as String?,
      mediaType: $enumDecodeNullable(_$FileTypeEnumMap, json['media_type']),
      assetId: json['asset_id'] as String?,
      totalLikes: json['likes_count'] as num?,
      hasLiked: json['story_likes_by_user'] as num?,
      totalBookmarks: json['bookmarks_count'] as num?,
      hasBookmarked: json['user_has_bookmarked'] as bool?,
      totalComments: json['comments_count'] as num?,
      totalViews: json['views_count'] as num?,
      userViewInfo: json['user_view_info'] == null
          ? null
          : FeedViewInfo.fromJson(
              json['user_view_info'] as Map<String, dynamic>),
      deleteAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      videoSource:
          $enumDecodeNullable(_$VideoSourceEnumMap, json['videoSource']) ??
              VideoSource.network,
      status: json['status'] as String?,
      tempId: json['tempId'] as String?,
      flipFile: json['flipFile'] as bool?,
      disciplinaryAction: json['disciplinary_action'] as String?,
    );

Map<String, dynamic> _$FeedModelToJson(FeedModel instance) => <String, dynamic>{
      'id': instance.id,
      'tempId': instance.tempId,
      'user': instance.user?.toJson(),
      'description': instance.description,
      'purpose': instance.purpose,
      'comments_disabled_at': instance.commentsDisabledAt?.toIso8601String(),
      'blocked_by_admin_at': instance.blockedByAdminAt,
      'media_path': instance.mediaPath,
      'asset_id': instance.assetId,
      'media_type': _$FileTypeEnumMap[instance.mediaType],
      'videoSource': _$VideoSourceEnumMap[instance.videoSource]!,
      'likes_count': instance.totalLikes,
      'story_likes_by_user': instance.hasLiked,
      'bookmarks_count': instance.totalBookmarks,
      'user_has_bookmarked': instance.hasBookmarked,
      'comments_count': instance.totalComments,
      'views_count': instance.totalViews,
      'user_view_info': instance.userViewInfo?.toJson(),
      'deleted_at': instance.deleteAt?.toIso8601String(),
      'status': instance.status,
      'flipFile': instance.flipFile,
      'disciplinary_action': instance.disciplinaryAction,
    };

const _$FileTypeEnumMap = {
  FileType.any: 'any',
  FileType.media: 'media',
  FileType.image: 'image',
  FileType.video: 'video',
  FileType.audio: 'audio',
  FileType.custom: 'custom',
};

const _$VideoSourceEnumMap = {
  VideoSource.file: 'file',
  VideoSource.network: 'network',
  VideoSource.asset: 'asset',
};

FeedViewInfo _$FeedViewInfoFromJson(Map<String, dynamic> json) => FeedViewInfo(
      seenAt: json['seen_at'] == null
          ? null
          : DateTime.parse(json['seen_at'] as String),
      watchedAt: json['watched_created_at'] == null
          ? null
          : DateTime.parse(json['watched_created_at'] as String),
      lastWatchedAt: json['watched_updated_at'] == null
          ? null
          : DateTime.parse(json['watched_updated_at'] as String),
      watchedCount: json['watched_count'] as num?,
    );

Map<String, dynamic> _$FeedViewInfoToJson(FeedViewInfo instance) =>
    <String, dynamic>{
      'seen_at': instance.seenAt?.toIso8601String(),
      'watched_created_at': instance.watchedAt?.toIso8601String(),
      'watched_updated_at': instance.lastWatchedAt?.toIso8601String(),
      'watched_count': instance.watchedCount,
    };
