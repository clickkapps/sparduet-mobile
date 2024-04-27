import 'package:json_annotation/json_annotation.dart';

part 'user_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserInfoModel {
  final String? bio;
  final DateTime? dob;
  final String? age;
  final String? gender;
  @JsonKey(name: "profile_pic_path")
  final String? profilePicPath;
  @JsonKey(name: "introductory_video_path")
  final String? introVideoPath;
  
  const UserInfoModel({this.bio, this.dob, this.age, this.gender, this.profilePicPath, this.introVideoPath});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
  
}