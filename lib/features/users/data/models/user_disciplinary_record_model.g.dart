// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_disciplinary_record_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserDisciplinaryRecordModelCWProxy {
  UserDisciplinaryRecordModel id(int? id);

  UserDisciplinaryRecordModel disciplinaryAction(String? disciplinaryAction);

  UserDisciplinaryRecordModel reason(String? reason);

  UserDisciplinaryRecordModel status(String? status);

  UserDisciplinaryRecordModel userReadAt(DateTime? userReadAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserDisciplinaryRecordModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserDisciplinaryRecordModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserDisciplinaryRecordModel call({
    int? id,
    String? disciplinaryAction,
    String? reason,
    String? status,
    DateTime? userReadAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserDisciplinaryRecordModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserDisciplinaryRecordModel.copyWith.fieldName(...)`
class _$UserDisciplinaryRecordModelCWProxyImpl
    implements _$UserDisciplinaryRecordModelCWProxy {
  const _$UserDisciplinaryRecordModelCWProxyImpl(this._value);

  final UserDisciplinaryRecordModel _value;

  @override
  UserDisciplinaryRecordModel id(int? id) => this(id: id);

  @override
  UserDisciplinaryRecordModel disciplinaryAction(String? disciplinaryAction) =>
      this(disciplinaryAction: disciplinaryAction);

  @override
  UserDisciplinaryRecordModel reason(String? reason) => this(reason: reason);

  @override
  UserDisciplinaryRecordModel status(String? status) => this(status: status);

  @override
  UserDisciplinaryRecordModel userReadAt(DateTime? userReadAt) =>
      this(userReadAt: userReadAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserDisciplinaryRecordModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserDisciplinaryRecordModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserDisciplinaryRecordModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? disciplinaryAction = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? userReadAt = const $CopyWithPlaceholder(),
  }) {
    return UserDisciplinaryRecordModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      disciplinaryAction: disciplinaryAction == const $CopyWithPlaceholder()
          ? _value.disciplinaryAction
          // ignore: cast_nullable_to_non_nullable
          : disciplinaryAction as String?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String?,
      userReadAt: userReadAt == const $CopyWithPlaceholder()
          ? _value.userReadAt
          // ignore: cast_nullable_to_non_nullable
          : userReadAt as DateTime?,
    );
  }
}

extension $UserDisciplinaryRecordModelCopyWith on UserDisciplinaryRecordModel {
  /// Returns a callable class that can be used as follows: `instanceOfUserDisciplinaryRecordModel.copyWith(...)` or like so:`instanceOfUserDisciplinaryRecordModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserDisciplinaryRecordModelCWProxy get copyWith =>
      _$UserDisciplinaryRecordModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDisciplinaryRecordModel _$UserDisciplinaryRecordModelFromJson(
        Map<String, dynamic> json) =>
    UserDisciplinaryRecordModel(
      id: json['id'] as int?,
      disciplinaryAction: json['disciplinary_action'] as String?,
      reason: json['reason'] as String?,
      status: json['status'] as String?,
      userReadAt: json['user_read_at'] == null
          ? null
          : DateTime.parse(json['user_read_at'] as String),
    );

Map<String, dynamic> _$UserDisciplinaryRecordModelToJson(
        UserDisciplinaryRecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'disciplinary_action': instance.disciplinaryAction,
      'reason': instance.reason,
      'status': instance.status,
      'user_read_at': instance.userReadAt?.toIso8601String(),
    };
