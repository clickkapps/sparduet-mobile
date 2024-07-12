import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/subscriptions/presentation/pages/subscription_page.dart';

mixin SubscriptionPageMixin {
  void showSubscriptionPaywall(BuildContext context, {bool openAsModal = false}) async {

    if(!openAsModal) {
      context.pushScreen(const SubscriptionPage());
      return;
    }

    final ch = Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(color: Colors.transparent), // Transparent container to detect taps
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 0.9,
            minChildSize: 0.9,
            shouldCloseOnMinExtent: true,
            builder: (_ , controller) {
              return ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: SubscriptionPage(scrollController: controller,)
              );
            }
        )
      ],
    );

    context.showCustomBottomSheet(child: ch, isDismissible: false, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);

  }

}