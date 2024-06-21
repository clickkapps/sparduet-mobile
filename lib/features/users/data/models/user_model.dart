import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/users/data/models/user_info_model.dart';

import '../../../../core/app_constants.dart';

part 'user_model.g.dart';

@HiveType(typeId: AppConstants.userModelHiveId)
@JsonSerializable(explicitToJson: true)
@CopyWith()
class UserModel extends Equatable {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? email;
  @HiveField(2)
  final String? name;
  @HiveField(3)
  final String? username;
  @HiveField(4)
  final UserInfoModel? info;
  @HiveField(5)
  @JsonKey(name: "display_age")
  final num? displayAge;
  @JsonKey(name: "introductory_post")
  final FeedModel? introductoryPost;

  const UserModel({this.id, this.displayAge, this.name, this.email, this.username,
     this.info, this.introductoryPost,
  });

  @override
  List<Object?> get props => [id, email, displayAge, name];

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

}