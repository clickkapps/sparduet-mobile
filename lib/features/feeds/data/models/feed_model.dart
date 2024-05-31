import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';

part 'feed_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class FeedModel extends Equatable{
  final int? id;
  final String? tempId;
  final UserModel? user;
  final String? description;
  final String? purpose;
  @JsonKey(name: "comments_disabled_at")
  final DateTime? commentsDisabledAt;
  @JsonKey(name: "blocked_by_admin_at")
  final bool? blockedByAdminAt;
  @JsonKey(name: "media_path")
  final String? mediaPath;
  @JsonKey(name: "asset_id")
  final String? assetId;
  @JsonKey(name: "media_type")
  final FileType? mediaType; //video / image
  final VideoSource videoSource;
  @JsonKey(name: "likes_count")
  final num? totalLikes;
  @JsonKey(name: "story_likes_by_user")
  final num? hasLiked;
  @JsonKey(name: "bookmarks_count")
  final num? totalBookmarks;
  @JsonKey(name: "user_has_bookmarked")
  final bool? hasBookmarked;
  @JsonKey(name: "comments_count")
  final num? totalComments;
  @JsonKey(name: "views_count")
  final num? totalViews;
  @JsonKey(name: "user_view_info")
  final FeedViewInfo? userViewInfo;

  @JsonKey(name: "deleted_at")
  final DateTime? deleteAt;
  final String? status;
  final bool? flipFile;

  const FeedModel({
    this.id,
    this.user,
    this.description,
    this.purpose,
    this.commentsDisabledAt,
    this.blockedByAdminAt,
    this.mediaPath,
    this.mediaType,
    this.assetId,
    this.totalLikes,
    this.hasLiked,
    this.totalBookmarks,
    this.hasBookmarked,
    this.totalComments,
    this.totalViews,
    this.userViewInfo,
    this.deleteAt,
    this.videoSource = VideoSource.network,
    this.status,
    this.tempId,
    this.flipFile,
  });

  @override
  List<Object?> get props => [id, tempId, mediaPath, mediaType, assetId, totalLikes, hasLiked, totalBookmarks, hasBookmarked, totalComments, totalViews, userViewInfo, user, totalLikes, hasLiked];

  factory FeedModel.fromJson(Map<String, dynamic> json) => _$FeedModelFromJson(json);
  Map<String, dynamic> toJson() => _$FeedModelToJson(this);

}


@JsonSerializable(explicitToJson: true)
@CopyWith()
class FeedViewInfo extends Equatable {

  @JsonKey(name: 'seen_at')
  final DateTime? seenAt;

  @JsonKey(name: 'watched_created_at')
  final DateTime? watchedAt;

  @JsonKey(name: 'watched_updated_at')
  final DateTime? lastWatchedAt;

  @JsonKey(name: 'watched_count')
  final num? watchedCount;

  const FeedViewInfo({
    this.seenAt,
    this.watchedAt,
    this.lastWatchedAt,
    this.watchedCount
  });

  @override
  List<Object?> get props => [watchedCount, seenAt, lastWatchedAt];

  factory FeedViewInfo.fromJson(Map<String, dynamic> json) => _$FeedViewInfoFromJson(json);
  Map<String, dynamic> toJson() => _$FeedViewInfoToJson(this);

}