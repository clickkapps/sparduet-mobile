// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserModelCWProxy {
  UserModel id(int? id);

  UserModel displayAge(num? displayAge);

  UserModel name(String? name);

  UserModel email(String? email);

  UserModel username(String? username);

  UserModel blocked(int? blocked);

  UserModel info(UserInfoModel? info);

  UserModel introductoryPost(FeedModel? introductoryPost);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserModel call({
    int? id,
    num? displayAge,
    String? name,
    String? email,
    String? username,
    int? blocked,
    UserInfoModel? info,
    FeedModel? introductoryPost,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserModel.copyWith.fieldName(...)`
class _$UserModelCWProxyImpl implements _$UserModelCWProxy {
  const _$UserModelCWProxyImpl(this._value);

  final UserModel _value;

  @override
  UserModel id(int? id) => this(id: id);

  @override
  UserModel displayAge(num? displayAge) => this(displayAge: displayAge);

  @override
  UserModel name(String? name) => this(name: name);

  @override
  UserModel email(String? email) => this(email: email);

  @override
  UserModel username(String? username) => this(username: username);

  @override
  UserModel blocked(int? blocked) => this(blocked: blocked);

  @override
  UserModel info(UserInfoModel? info) => this(info: info);

  @override
  UserModel introductoryPost(FeedModel? introductoryPost) =>
      this(introductoryPost: introductoryPost);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? displayAge = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? username = const $CopyWithPlaceholder(),
    Object? blocked = const $CopyWithPlaceholder(),
    Object? info = const $CopyWithPlaceholder(),
    Object? introductoryPost = const $CopyWithPlaceholder(),
  }) {
    return UserModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      displayAge: displayAge == const $CopyWithPlaceholder()
          ? _value.displayAge
          // ignore: cast_nullable_to_non_nullable
          : displayAge as num?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      username: username == const $CopyWithPlaceholder()
          ? _value.username
          // ignore: cast_nullable_to_non_nullable
          : username as String?,
      blocked: blocked == const $CopyWithPlaceholder()
          ? _value.blocked
          // ignore: cast_nullable_to_non_nullable
          : blocked as int?,
      info: info == const $CopyWithPlaceholder()
          ? _value.info
          // ignore: cast_nullable_to_non_nullable
          : info as UserInfoModel?,
      introductoryPost: introductoryPost == const $CopyWithPlaceholder()
          ? _value.introductoryPost
          // ignore: cast_nullable_to_non_nullable
          : introductoryPost as FeedModel?,
    );
  }
}

extension $UserModelCopyWith on UserModel {
  /// Returns a callable class that can be used as follows: `instanceOfUserModel.copyWith(...)` or like so:`instanceOfUserModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserModelCWProxy get copyWith => _$UserModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as int?,
      displayAge: json['display_age'] as num?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      blocked: json['blocked'] as int?,
      info: json['info'] == null
          ? null
          : UserInfoModel.fromJson(json['info'] as Map<String, dynamic>),
      introductoryPost: json['introductory_post'] == null
          ? null
          : FeedModel.fromJson(
              json['introductory_post'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'username': instance.username,
      'blocked': instance.blocked,
      'info': instance.info?.toJson(),
      'introductory_post': instance.introductoryPost?.toJson(),
      'display_age': instance.displayAge,
    };
