// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthStateCWProxy {
  AuthState status(AuthStatus status);

  AuthState message(String message);

  AuthState authUser(AuthUserModel? authUser);

  AuthState data(dynamic data);

  AuthState userNotice(AuthUserNoticeModel? userNotice);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthState(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthState call({
    AuthStatus? status,
    String? message,
    AuthUserModel? authUser,
    dynamic data,
    AuthUserNoticeModel? userNotice,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthState.copyWith.fieldName(...)`
class _$AuthStateCWProxyImpl implements _$AuthStateCWProxy {
  const _$AuthStateCWProxyImpl(this._value);

  final AuthState _value;

  @override
  AuthState status(AuthStatus status) => this(status: status);

  @override
  AuthState message(String message) => this(message: message);

  @override
  AuthState authUser(AuthUserModel? authUser) => this(authUser: authUser);

  @override
  AuthState data(dynamic data) => this(data: data);

  @override
  AuthState userNotice(AuthUserNoticeModel? userNotice) =>
      this(userNotice: userNotice);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthState(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? authUser = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
    Object? userNotice = const $CopyWithPlaceholder(),
  }) {
    return AuthState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AuthStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      authUser: authUser == const $CopyWithPlaceholder()
          ? _value.authUser
          // ignore: cast_nullable_to_non_nullable
          : authUser as AuthUserModel?,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as dynamic,
      userNotice: userNotice == const $CopyWithPlaceholder()
          ? _value.userNotice
          // ignore: cast_nullable_to_non_nullable
          : userNotice as AuthUserNoticeModel?,
    );
  }
}

extension $AuthStateCopyWith on AuthState {
  /// Returns a callable class that can be used as follows: `instanceOfAuthState.copyWith(...)` or like so:`instanceOfAuthState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthStateCWProxy get copyWith => _$AuthStateCWProxyImpl(this);
}
