// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_notice_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthUserNoticeModelCWProxy {
  AuthUserNoticeModel id(int? id);

  AuthUserNoticeModel notice(String? notice);

  AuthUserNoticeModel link(String? link);

  AuthUserNoticeModel noticeReadAt(DateTime? noticeReadAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthUserNoticeModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthUserNoticeModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthUserNoticeModel call({
    int? id,
    String? notice,
    String? link,
    DateTime? noticeReadAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthUserNoticeModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthUserNoticeModel.copyWith.fieldName(...)`
class _$AuthUserNoticeModelCWProxyImpl implements _$AuthUserNoticeModelCWProxy {
  const _$AuthUserNoticeModelCWProxyImpl(this._value);

  final AuthUserNoticeModel _value;

  @override
  AuthUserNoticeModel id(int? id) => this(id: id);

  @override
  AuthUserNoticeModel notice(String? notice) => this(notice: notice);

  @override
  AuthUserNoticeModel link(String? link) => this(link: link);

  @override
  AuthUserNoticeModel noticeReadAt(DateTime? noticeReadAt) =>
      this(noticeReadAt: noticeReadAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthUserNoticeModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthUserNoticeModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthUserNoticeModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? notice = const $CopyWithPlaceholder(),
    Object? link = const $CopyWithPlaceholder(),
    Object? noticeReadAt = const $CopyWithPlaceholder(),
  }) {
    return AuthUserNoticeModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      notice: notice == const $CopyWithPlaceholder()
          ? _value.notice
          // ignore: cast_nullable_to_non_nullable
          : notice as String?,
      link: link == const $CopyWithPlaceholder()
          ? _value.link
          // ignore: cast_nullable_to_non_nullable
          : link as String?,
      noticeReadAt: noticeReadAt == const $CopyWithPlaceholder()
          ? _value.noticeReadAt
          // ignore: cast_nullable_to_non_nullable
          : noticeReadAt as DateTime?,
    );
  }
}

extension $AuthUserNoticeModelCopyWith on AuthUserNoticeModel {
  /// Returns a callable class that can be used as follows: `instanceOfAuthUserNoticeModel.copyWith(...)` or like so:`instanceOfAuthUserNoticeModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthUserNoticeModelCWProxy get copyWith =>
      _$AuthUserNoticeModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserNoticeModel _$AuthUserNoticeModelFromJson(Map<String, dynamic> json) =>
    AuthUserNoticeModel(
      id: json['id'] as int?,
      notice: json['notice'] as String?,
      link: json['link'] as String?,
      noticeReadAt: json['notice_read_at'] == null
          ? null
          : DateTime.parse(json['notice_read_at'] as String),
    );

Map<String, dynamic> _$AuthUserNoticeModelToJson(
        AuthUserNoticeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notice': instance.notice,
      'link': instance.link,
      'notice_read_at': instance.noticeReadAt?.toIso8601String(),
    };
