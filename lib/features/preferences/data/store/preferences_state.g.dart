// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PreferencesStateCWProxy {
  PreferencesState status(PreferencesStatus status);

  PreferencesState enableChatNotifications(bool enableChatNotifications);

  PreferencesState enableProfileViewsNotifications(
      bool enableProfileViewsNotifications);

  PreferencesState enableStoryViewsNotifications(
      bool enableStoryViewsNotifications);

  PreferencesState preferredFontFamily(String? preferredFontFamily);

  PreferencesState preferredThemeAppearance(String preferredThemeAppearance);

  PreferencesState message(String? message);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PreferencesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PreferencesState(...).copyWith(id: 12, name: "My name")
  /// ````
  PreferencesState call({
    PreferencesStatus? status,
    bool? enableChatNotifications,
    bool? enableProfileViewsNotifications,
    bool? enableStoryViewsNotifications,
    String? preferredFontFamily,
    String? preferredThemeAppearance,
    String? message,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPreferencesState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPreferencesState.copyWith.fieldName(...)`
class _$PreferencesStateCWProxyImpl implements _$PreferencesStateCWProxy {
  const _$PreferencesStateCWProxyImpl(this._value);

  final PreferencesState _value;

  @override
  PreferencesState status(PreferencesStatus status) => this(status: status);

  @override
  PreferencesState enableChatNotifications(bool enableChatNotifications) =>
      this(enableChatNotifications: enableChatNotifications);

  @override
  PreferencesState enableProfileViewsNotifications(
          bool enableProfileViewsNotifications) =>
      this(enableProfileViewsNotifications: enableProfileViewsNotifications);

  @override
  PreferencesState enableStoryViewsNotifications(
          bool enableStoryViewsNotifications) =>
      this(enableStoryViewsNotifications: enableStoryViewsNotifications);

  @override
  PreferencesState preferredFontFamily(String? preferredFontFamily) =>
      this(preferredFontFamily: preferredFontFamily);

  @override
  PreferencesState preferredThemeAppearance(String preferredThemeAppearance) =>
      this(preferredThemeAppearance: preferredThemeAppearance);

  @override
  PreferencesState message(String? message) => this(message: message);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PreferencesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PreferencesState(...).copyWith(id: 12, name: "My name")
  /// ````
  PreferencesState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? enableChatNotifications = const $CopyWithPlaceholder(),
    Object? enableProfileViewsNotifications = const $CopyWithPlaceholder(),
    Object? enableStoryViewsNotifications = const $CopyWithPlaceholder(),
    Object? preferredFontFamily = const $CopyWithPlaceholder(),
    Object? preferredThemeAppearance = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return PreferencesState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as PreferencesStatus,
      enableChatNotifications:
          enableChatNotifications == const $CopyWithPlaceholder() ||
                  enableChatNotifications == null
              ? _value.enableChatNotifications
              // ignore: cast_nullable_to_non_nullable
              : enableChatNotifications as bool,
      enableProfileViewsNotifications:
          enableProfileViewsNotifications == const $CopyWithPlaceholder() ||
                  enableProfileViewsNotifications == null
              ? _value.enableProfileViewsNotifications
              // ignore: cast_nullable_to_non_nullable
              : enableProfileViewsNotifications as bool,
      enableStoryViewsNotifications:
          enableStoryViewsNotifications == const $CopyWithPlaceholder() ||
                  enableStoryViewsNotifications == null
              ? _value.enableStoryViewsNotifications
              // ignore: cast_nullable_to_non_nullable
              : enableStoryViewsNotifications as bool,
      preferredFontFamily: preferredFontFamily == const $CopyWithPlaceholder()
          ? _value.preferredFontFamily
          // ignore: cast_nullable_to_non_nullable
          : preferredFontFamily as String?,
      preferredThemeAppearance:
          preferredThemeAppearance == const $CopyWithPlaceholder() ||
                  preferredThemeAppearance == null
              ? _value.preferredThemeAppearance
              // ignore: cast_nullable_to_non_nullable
              : preferredThemeAppearance as String,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
    );
  }
}

extension $PreferencesStateCopyWith on PreferencesState {
  /// Returns a callable class that can be used as follows: `instanceOfPreferencesState.copyWith(...)` or like so:`instanceOfPreferencesState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PreferencesStateCWProxy get copyWith => _$PreferencesStateCWProxyImpl(this);
}
