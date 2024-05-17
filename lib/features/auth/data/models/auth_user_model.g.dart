// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthUserModelCWProxy {
  AuthUserModel id(int? id);

  AuthUserModel email(String? email);

  AuthUserModel displayAge(num? displayAge);

  AuthUserModel name(String? name);

  AuthUserModel username(String? username);

  AuthUserModel blocked(int? blocked);

  AuthUserModel info(UserInfoModel? info);

  AuthUserModel introductoryPost(FeedModel? introductoryPost);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthUserModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthUserModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthUserModel call({
    int? id,
    String? email,
    num? displayAge,
    String? name,
    String? username,
    int? blocked,
    UserInfoModel? info,
    FeedModel? introductoryPost,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthUserModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthUserModel.copyWith.fieldName(...)`
class _$AuthUserModelCWProxyImpl implements _$AuthUserModelCWProxy {
  const _$AuthUserModelCWProxyImpl(this._value);

  final AuthUserModel _value;

  @override
  AuthUserModel id(int? id) => this(id: id);

  @override
  AuthUserModel email(String? email) => this(email: email);

  @override
  AuthUserModel displayAge(num? displayAge) => this(displayAge: displayAge);

  @override
  AuthUserModel name(String? name) => this(name: name);

  @override
  AuthUserModel username(String? username) => this(username: username);

  @override
  AuthUserModel blocked(int? blocked) => this(blocked: blocked);

  @override
  AuthUserModel info(UserInfoModel? info) => this(info: info);

  @override
  AuthUserModel introductoryPost(FeedModel? introductoryPost) =>
      this(introductoryPost: introductoryPost);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthUserModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthUserModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthUserModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? displayAge = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? username = const $CopyWithPlaceholder(),
    Object? blocked = const $CopyWithPlaceholder(),
    Object? info = const $CopyWithPlaceholder(),
    Object? introductoryPost = const $CopyWithPlaceholder(),
  }) {
    return AuthUserModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      displayAge: displayAge == const $CopyWithPlaceholder()
          ? _value.displayAge
          // ignore: cast_nullable_to_non_nullable
          : displayAge as num?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
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

extension $AuthUserModelCopyWith on AuthUserModel {
  /// Returns a callable class that can be used as follows: `instanceOfAuthUserModel.copyWith(...)` or like so:`instanceOfAuthUserModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthUserModelCWProxy get copyWith => _$AuthUserModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserModel _$AuthUserModelFromJson(Map<String, dynamic> json) =>
    AuthUserModel(
      id: json['id'] as int?,
      email: json['email'] as String?,
      displayAge: json['display_age'] as num?,
      name: json['name'] as String?,
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

Map<String, dynamic> _$AuthUserModelToJson(AuthUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'username': instance.username,
      'blocked': instance.blocked,
      'info': instance.info?.toJson(),
      'introductory_post': instance.introductoryPost?.toJson(),
      'display_age': instance.displayAge,
    };
