import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/subscriptions/data/repositories/subscription_repository.dart';
import 'package:sparkduet/features/subscriptions/data/store/enum.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository subscriptionRepository;
  SubscriptionCubit({required this.subscriptionRepository}) : super( const SubscriptionState());

  Future<void> initializeSubscription(String authUserId) async {
    await subscriptionRepository.initSubscription(authUserId);
  }

  Future<Offering?> getOffering() async {
    emit(state.copyWith(status: SubscriptionStatus.getOfferingInProgress));
    final either = await subscriptionRepository.getOffering();
    if(either.isLeft()) {
      emit(state.copyWith(status: SubscriptionStatus.getOfferingFailed));
      return null;
    }
    final r = either.asRight();
    emit(state.copyWith(status: SubscriptionStatus.getOfferingSuccessful, offering: r));
    return r;
  }

  void setSubscriptionStatus(bool status) {
    emit(state.copyWith(status: SubscriptionStatus.setSubscriptionStatusInProgress));
    emit(state.copyWith(status: SubscriptionStatus.setSubscriptionStatusCompleted, subscribed: status));
  }

  Future<(String?, bool?)> makePurchase(Package package) async {


    emit(state.copyWith(status: SubscriptionStatus.makePurchaseInProgress));

    final either = await subscriptionRepository.makePurchase(package);

    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: SubscriptionStatus.makePurchaseFailed, message: l));
      return (l, null);
    }

    final r = either.asRight();
    setSubscriptionStatus(r);
    emit(state.copyWith(status: SubscriptionStatus.makePurchaseSuccessful));

    return (null, r);

  }

  Future<void> getSubscriptionStatus() async {

    emit(state.copyWith(status: SubscriptionStatus.getSubscriptionStatusInProgress));
    final either = await subscriptionRepository.checkSubscriptionStatus();

    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: SubscriptionStatus.getSubscriptionStatusFailed, message: l));
      return;
    }

    final r = either.asRight();
    setSubscriptionStatus(r);
    emit(state.copyWith(status: SubscriptionStatus.getSubscriptionStatusSuccessful));
  }

}