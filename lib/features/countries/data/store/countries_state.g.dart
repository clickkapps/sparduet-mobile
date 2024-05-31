// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countries_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CountriesStateCWProxy {
  CountriesState status(CountryStatus status);

  CountriesState message(String? message);

  CountriesState countries(List<CountryModel> countries);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CountriesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CountriesState(...).copyWith(id: 12, name: "My name")
  /// ````
  CountriesState call({
    CountryStatus? status,
    String? message,
    List<CountryModel>? countries,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCountriesState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCountriesState.copyWith.fieldName(...)`
class _$CountriesStateCWProxyImpl implements _$CountriesStateCWProxy {
  const _$CountriesStateCWProxyImpl(this._value);

  final CountriesState _value;

  @override
  CountriesState status(CountryStatus status) => this(status: status);

  @override
  CountriesState message(String? message) => this(message: message);

  @override
  CountriesState countries(List<CountryModel> countries) =>
      this(countries: countries);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CountriesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CountriesState(...).copyWith(id: 12, name: "My name")
  /// ````
  CountriesState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? countries = const $CopyWithPlaceholder(),
  }) {
    return CountriesState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as CountryStatus,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      countries: countries == const $CopyWithPlaceholder() || countries == null
          ? _value.countries
          // ignore: cast_nullable_to_non_nullable
          : countries as List<CountryModel>,
    );
  }
}

extension $CountriesStateCopyWith on CountriesState {
  /// Returns a callable class that can be used as follows: `instanceOfCountriesState.copyWith(...)` or like so:`instanceOfCountriesState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CountriesStateCWProxy get copyWith => _$CountriesStateCWProxyImpl(this);
}
