import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:sparkduet/features/subscriptions/data/store/enum.dart';

part 'subscription_state.g.dart';

@CopyWith()
class SubscriptionState extends Equatable {
  final String? message;
  final SubscriptionStatus status;
  final Offering? offering;
  final bool subscribed; // This checks if user has subscribe or not

  const SubscriptionState({
    this.message,
    this.status = SubscriptionStatus.initial,
    this.offering,
    this.subscribed = false
  });

  @override
  List<Object?> get props => [status, message];
}