import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/users/data/models/user_info_model.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class UserModel extends Equatable {
  final int? id;
  final String? email;
  final String? name;
  final String? username;
  final int? blocked;
  final UserInfoModel? info;
  @JsonKey(name: "introductory_post")
  final FeedModel? introductoryPost;
  @JsonKey(name: "display_age")
  final num? displayAge;

  const UserModel({this.id, this.displayAge, this.name, this.email, this.username,
    this.blocked, this.info, this.introductoryPost,
  });

  @override
  List<Object?> get props => [id, email, displayAge, name];

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

}