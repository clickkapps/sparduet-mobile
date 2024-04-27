// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      bio: json['bio'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      age: json['age'] as String?,
      gender: json['gender'] as String?,
      profilePicPath: json['profile_pic_path'] as String?,
      introVideoPath: json['introductory_video_path'] as String?,
    );

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'bio': instance.bio,
      'dob': instance.dob?.toIso8601String(),
      'age': instance.age,
      'gender': instance.gender,
      'profile_pic_path': instance.profilePicPath,
      'introductory_video_path': instance.introVideoPath,
    };
