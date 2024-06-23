// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nav_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NavStateCWProxy {
  NavState status(NavStatus status);

  NavState message(String? message);

  NavState data(dynamic data);

  NavState currentTabIndex(int currentTabIndex);

  NavState previousIndex(int previousIndex);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NavState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NavState(...).copyWith(id: 12, name: "My name")
  /// ````
  NavState call({
    NavStatus? status,
    String? message,
    dynamic data,
    int? currentTabIndex,
    int? previousIndex,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNavState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNavState.copyWith.fieldName(...)`
class _$NavStateCWProxyImpl implements _$NavStateCWProxy {
  const _$NavStateCWProxyImpl(this._value);

  final NavState _value;

  @override
  NavState status(NavStatus status) => this(status: status);

  @override
  NavState message(String? message) => this(message: message);

  @override
  NavState data(dynamic data) => this(data: data);

  @override
  NavState currentTabIndex(int currentTabIndex) =>
      this(currentTabIndex: currentTabIndex);

  @override
  NavState previousIndex(int previousIndex) =>
      this(previousIndex: previousIndex);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NavState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NavState(...).copyWith(id: 12, name: "My name")
  /// ````
  NavState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
    Object? currentTabIndex = const $CopyWithPlaceholder(),
    Object? previousIndex = const $CopyWithPlaceholder(),
  }) {
    return NavState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as NavStatus,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as dynamic,
      currentTabIndex: currentTabIndex == const $CopyWithPlaceholder() ||
              currentTabIndex == null
          ? _value.currentTabIndex
          // ignore: cast_nullable_to_non_nullable
          : currentTabIndex as int,
      previousIndex:
          previousIndex == const $CopyWithPlaceholder() || previousIndex == null
              ? _value.previousIndex
              // ignore: cast_nullable_to_non_nullable
              : previousIndex as int,
    );
  }
}

extension $NavStateCopyWith on NavState {
  /// Returns a callable class that can be used as follows: `instanceOfNavState.copyWith(...)` or like so:`instanceOfNavState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NavStateCWProxy get copyWith => _$NavStateCWProxyImpl(this);
}
