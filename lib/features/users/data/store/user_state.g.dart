// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserStateCWProxy {
  UserState message(String? message);

  UserState user(UserModel? user);

  UserState status(UserStatus status);

  UserState unreadViewersCount(num unreadViewersCount);

  UserState unreadViewers(List<UserModel> unreadViewers);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserState(...).copyWith(id: 12, name: "My name")
  /// ````
  UserState call({
    String? message,
    UserModel? user,
    UserStatus? status,
    num? unreadViewersCount,
    List<UserModel>? unreadViewers,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserState.copyWith.fieldName(...)`
class _$UserStateCWProxyImpl implements _$UserStateCWProxy {
  const _$UserStateCWProxyImpl(this._value);

  final UserState _value;

  @override
  UserState message(String? message) => this(message: message);

  @override
  UserState user(UserModel? user) => this(user: user);

  @override
  UserState status(UserStatus status) => this(status: status);

  @override
  UserState unreadViewersCount(num unreadViewersCount) =>
      this(unreadViewersCount: unreadViewersCount);

  @override
  UserState unreadViewers(List<UserModel> unreadViewers) =>
      this(unreadViewers: unreadViewers);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserState(...).copyWith(id: 12, name: "My name")
  /// ````
  UserState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? unreadViewersCount = const $CopyWithPlaceholder(),
    Object? unreadViewers = const $CopyWithPlaceholder(),
  }) {
    return UserState(
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as UserModel?,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as UserStatus,
      unreadViewersCount: unreadViewersCount == const $CopyWithPlaceholder() ||
              unreadViewersCount == null
          ? _value.unreadViewersCount
          // ignore: cast_nullable_to_non_nullable
          : unreadViewersCount as num,
      unreadViewers:
          unreadViewers == const $CopyWithPlaceholder() || unreadViewers == null
              ? _value.unreadViewers
              // ignore: cast_nullable_to_non_nullable
              : unreadViewers as List<UserModel>,
    );
  }
}

extension $UserStateCopyWith on UserState {
  /// Returns a callable class that can be used as follows: `instanceOfUserState.copyWith(...)` or like so:`instanceOfUserState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserStateCWProxy get copyWith => _$UserStateCWProxyImpl(this);
}
