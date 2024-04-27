// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThemeStateCWProxy {
  ThemeState status(ThemeStatus status);

  ThemeState message(String message);

  ThemeState themeData(ThemeData? themeData);

  ThemeState appFont(AppFont appFont);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThemeState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThemeState(...).copyWith(id: 12, name: "My name")
  /// ````
  ThemeState call({
    ThemeStatus? status,
    String? message,
    ThemeData? themeData,
    AppFont? appFont,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfThemeState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfThemeState.copyWith.fieldName(...)`
class _$ThemeStateCWProxyImpl implements _$ThemeStateCWProxy {
  const _$ThemeStateCWProxyImpl(this._value);

  final ThemeState _value;

  @override
  ThemeState status(ThemeStatus status) => this(status: status);

  @override
  ThemeState message(String message) => this(message: message);

  @override
  ThemeState themeData(ThemeData? themeData) => this(themeData: themeData);

  @override
  ThemeState appFont(AppFont appFont) => this(appFont: appFont);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThemeState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThemeState(...).copyWith(id: 12, name: "My name")
  /// ````
  ThemeState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? themeData = const $CopyWithPlaceholder(),
    Object? appFont = const $CopyWithPlaceholder(),
  }) {
    return ThemeState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ThemeStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      themeData: themeData == const $CopyWithPlaceholder()
          ? _value.themeData
          // ignore: cast_nullable_to_non_nullable
          : themeData as ThemeData?,
      appFont: appFont == const $CopyWithPlaceholder() || appFont == null
          ? _value.appFont
          // ignore: cast_nullable_to_non_nullable
          : appFont as AppFont,
    );
  }
}

extension $ThemeStateCopyWith on ThemeState {
  /// Returns a callable class that can be used as follows: `instanceOfThemeState.copyWith(...)` or like so:`instanceOfThemeState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThemeStateCWProxy get copyWith => _$ThemeStateCWProxyImpl(this);
}
