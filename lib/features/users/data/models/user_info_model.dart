import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class UserInfoModel extends Equatable {
  final String? bio;
  final DateTime? dob;
  final num? age;
  final String? gender;
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

  const UserInfoModel({this.bio, this.dob, this.age, this.gender, this.profilePicPath,
    this.requestedBasicInfoUpdate,
    this.requestedPreferenceInfoUpdate,
    this.preferredGender,
    this.preferredMinAge,
    this.preferredMaxAge,
    this.preferredRaces,
    this.preferredNationalities
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);

  @override
  List<Object?> get props => [gender, bio, age];
  
}