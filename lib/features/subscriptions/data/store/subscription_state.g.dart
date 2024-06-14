// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SubscriptionStateCWProxy {
  SubscriptionState message(String? message);

  SubscriptionState status(SubscriptionStatus status);

  SubscriptionState offering(Offering? offering);

  SubscriptionState subscribed(bool subscribed);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SubscriptionState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SubscriptionState(...).copyWith(id: 12, name: "My name")
  /// ````
  SubscriptionState call({
    String? message,
    SubscriptionStatus? status,
    Offering? offering,
    bool? subscribed,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSubscriptionState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSubscriptionState.copyWith.fieldName(...)`
class _$SubscriptionStateCWProxyImpl implements _$SubscriptionStateCWProxy {
  const _$SubscriptionStateCWProxyImpl(this._value);

  final SubscriptionState _value;

  @override
  SubscriptionState message(String? message) => this(message: message);

  @override
  SubscriptionState status(SubscriptionStatus status) => this(status: status);

  @override
  SubscriptionState offering(Offering? offering) => this(offering: offering);

  @override
  SubscriptionState subscribed(bool subscribed) => this(subscribed: subscribed);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SubscriptionState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SubscriptionState(...).copyWith(id: 12, name: "My name")
  /// ````
  SubscriptionState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? offering = const $CopyWithPlaceholder(),
    Object? subscribed = const $CopyWithPlaceholder(),
  }) {
    return SubscriptionState(
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as SubscriptionStatus,
      offering: offering == const $CopyWithPlaceholder()
          ? _value.offering
          // ignore: cast_nullable_to_non_nullable
          : offering as Offering?,
      subscribed:
          subscribed == const $CopyWithPlaceholder() || subscribed == null
              ? _value.subscribed
              // ignore: cast_nullable_to_non_nullable
              : subscribed as bool,
    );
  }
}

extension $SubscriptionStateCopyWith on SubscriptionState {
  /// Returns a callable class that can be used as follows: `instanceOfSubscriptionState.copyWith(...)` or like so:`instanceOfSubscriptionState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SubscriptionStateCWProxy get copyWith =>
      _$SubscriptionStateCWProxyImpl(this);
}
