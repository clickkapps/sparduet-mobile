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

  UserState onlineUsers(List<UserModel> onlineUsers);

  UserState onlineUserIds(List<int> onlineUserIds);

  UserState postLikedUsers(List<UserModel> postLikedUsers);

  UserState youBlockedUser(bool youBlockedUser);

  UserState userBlockedYou(bool userBlockedYou);

  UserState disciplinaryRecord(UserDisciplinaryRecordModel? disciplinaryRecord);

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
    List<UserModel>? onlineUsers,
    List<int>? onlineUserIds,
    List<UserModel>? postLikedUsers,
    bool? youBlockedUser,
    bool? userBlockedYou,
    UserDisciplinaryRecordModel? disciplinaryRecord,
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
  UserState onlineUsers(List<UserModel> onlineUsers) =>
      this(onlineUsers: onlineUsers);

  @override
  UserState onlineUserIds(List<int> onlineUserIds) =>
      this(onlineUserIds: onlineUserIds);

  @override
  UserState postLikedUsers(List<UserModel> postLikedUsers) =>
      this(postLikedUsers: postLikedUsers);

  @override
  UserState youBlockedUser(bool youBlockedUser) =>
      this(youBlockedUser: youBlockedUser);

  @override
  UserState userBlockedYou(bool userBlockedYou) =>
      this(userBlockedYou: userBlockedYou);

  @override
  UserState disciplinaryRecord(
          UserDisciplinaryRecordModel? disciplinaryRecord) =>
      this(disciplinaryRecord: disciplinaryRecord);

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
    Object? onlineUsers = const $CopyWithPlaceholder(),
    Object? onlineUserIds = const $CopyWithPlaceholder(),
    Object? postLikedUsers = const $CopyWithPlaceholder(),
    Object? youBlockedUser = const $CopyWithPlaceholder(),
    Object? userBlockedYou = const $CopyWithPlaceholder(),
    Object? disciplinaryRecord = const $CopyWithPlaceholder(),
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
      onlineUsers:
          onlineUsers == const $CopyWithPlaceholder() || onlineUsers == null
              ? _value.onlineUsers
              // ignore: cast_nullable_to_non_nullable
              : onlineUsers as List<UserModel>,
      onlineUserIds:
          onlineUserIds == const $CopyWithPlaceholder() || onlineUserIds == null
              ? _value.onlineUserIds
              // ignore: cast_nullable_to_non_nullable
              : onlineUserIds as List<int>,
      postLikedUsers: postLikedUsers == const $CopyWithPlaceholder() ||
              postLikedUsers == null
          ? _value.postLikedUsers
          // ignore: cast_nullable_to_non_nullable
          : postLikedUsers as List<UserModel>,
      youBlockedUser: youBlockedUser == const $CopyWithPlaceholder() ||
              youBlockedUser == null
          ? _value.youBlockedUser
          // ignore: cast_nullable_to_non_nullable
          : youBlockedUser as bool,
      userBlockedYou: userBlockedYou == const $CopyWithPlaceholder() ||
              userBlockedYou == null
          ? _value.userBlockedYou
          // ignore: cast_nullable_to_non_nullable
          : userBlockedYou as bool,
      disciplinaryRecord: disciplinaryRecord == const $CopyWithPlaceholder()
          ? _value.disciplinaryRecord
          // ignore: cast_nullable_to_non_nullable
          : disciplinaryRecord as UserDisciplinaryRecordModel?,
    );
  }
}

extension $UserStateCopyWith on UserState {
  /// Returns a callable class that can be used as follows: `instanceOfUserState.copyWith(...)` or like so:`instanceOfUserState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserStateCWProxy get copyWith => _$UserStateCWProxyImpl(this);
}
