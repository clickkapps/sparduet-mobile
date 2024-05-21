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
  @JsonKey(name: "total_likes")
  final num? totalLikes;
  @JsonKey(name: "has_liked")
  final bool? hasLiked;
  @JsonKey(name: "total_bookmarks")
  final num? totalBookmarks;
  @JsonKey(name: "has_bookmarked")
  final bool? hasBookmarked;
  @JsonKey(name: "total_comments")
  final num? totalComments;
  @JsonKey(name: "total_views")
  final num? totalViews;
  @JsonKey(name: "hasViewed")
  final bool? hasViewed;
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
    this.hasViewed,
    this.deleteAt,
    this.videoSource = VideoSource.network,
    this.status,
    this.tempId,
    this.flipFile,
  });

  @override
  List<Object?> get props => [id, tempId, mediaPath, mediaType, assetId, totalLikes, hasLiked, totalBookmarks, hasBookmarked, totalComments, totalViews, hasViewed, user];

  factory FeedModel.fromJson(Map<String, dynamic> json) => _$FeedModelFromJson(json);
  Map<String, dynamic> toJson() => _$FeedModelToJson(this);

}