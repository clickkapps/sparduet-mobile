import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

part 'feed_model.g.dart';

@JsonSerializable()
@CopyWith()
class FeedModel extends Equatable{
  final int? id;
  final UserModel? user;
  final String? description;
  final String? purpose;
  @JsonKey(name: "comments_disabled_at")
  final DateTime? commentsDisabledAt;
  @JsonKey(name: "blocked_by_admin_at")
  final bool? blockedByAdminAt;
  @JsonKey(name: "media_path")
  final String? mediaPath;
  @JsonKey(name: "media_type")
  final String? mediaType;
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

  const FeedModel({
    this.id,
    this.user, this.description,
    this.purpose,
    this.commentsDisabledAt,
    this.blockedByAdminAt,
    this.mediaPath,
    this.mediaType,
    this.totalLikes,
    this.hasLiked,
    this.totalBookmarks,
    this.hasBookmarked,
    this.totalComments,
    this.totalViews,
    this.hasViewed,
    this.deleteAt,
  });

  @override
  List<Object?> get props => [id, totalLikes, hasLiked, totalBookmarks, hasBookmarked, totalComments, totalViews, hasViewed];

  factory FeedModel.fromJson(Map<String, dynamic> json) => _$FeedModelFromJson(json);
  Map<String, dynamic> toJson() => _$FeedModelToJson(this);

}