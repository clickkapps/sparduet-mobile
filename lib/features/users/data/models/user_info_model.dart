import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/core/app_constants.dart';

part 'user_info_model.g.dart';

@HiveType(typeId: AppConstants.userInfoModelHiveId)
@JsonSerializable(explicitToJson: true)
@CopyWith()
class UserInfoModel extends Equatable {
  @HiveField(0)
  final String? bio;
  final DateTime? dob;
  @HiveField(1)
  final num? age;
  @HiveField(2)
  final String? gender;
  @HiveField(3)
  final String? race;
  @HiveField(4)
  @JsonKey(name: "profile_pic_path")
  final String? profilePicPath;
  @JsonKey(name: "requested_basic_info_update")
  final DateTime? requestedBasicInfoUpdate;
  @JsonKey(name: "requested_preference_info_update")
  final DateTime? requestedPreferenceInfoUpdate;
  @JsonKey(name: "preferred_gender")
  final String? preferredGender;
  @JsonKey(name: "preferred_min_age")
  final num? preferredMinAge;
  @JsonKey(name: "preferred_max_age")
  final num? preferredMaxAge;
  @JsonKey(name: "preferred_races")
  final String? preferredRaces;
  @JsonKey(name: "preferred_nationalities")
  final String? preferredNationalities;
  @HiveField(5)
  final String? loc;
  @HiveField(6)
  final String? country;

  const UserInfoModel({
    this.bio,
    this.race,
    this.dob, this.age, this.gender, this.profilePicPath,
    this.requestedBasicInfoUpdate,
    this.requestedPreferenceInfoUpdate,
    this.preferredGender,
    this.preferredMinAge,
    this.preferredMaxAge,
    this.preferredRaces,
    this.preferredNationalities,
    this.loc,
    this.country
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);

  @override
  List<Object?> get props => [gender, bio, age];
  
}