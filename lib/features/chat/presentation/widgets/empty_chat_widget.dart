import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sparkduet/core/app_assets.dart';

class EmptyChatWidget extends StatelessWidget {

  final String? message;
  const EmptyChatWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
         children: [
           Lottie.asset(AppAssets.kEmptyChatJson ),
           Text(message ?? "Your messages will appear here", textAlign: TextAlign.center, style: theme.textTheme.titleSmall,)
         ],
      ),
    );
  }
}
