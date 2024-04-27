// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthUserModelCWProxy {
  AuthUserModel id(int? id);

  AuthUserModel email(String? email);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthUserModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthUserModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthUserModel call({
    int? id,
    String? email,
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

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthUserModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthUserModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthUserModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
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
    );

Map<String, dynamic> _$AuthUserModelToJson(AuthUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
    };
