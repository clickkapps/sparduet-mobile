import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sparkduet/core/app_assets.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';

class MatchedConversationExplanationPage extends StatelessWidget {

  final ScrollController? controller;
  const MatchedConversationExplanationPage({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Lottie.asset(AppAssets.kFirstImpressJson ),
            const SizedBox(height: 15,),
            Text("Message Limit for Smooth Conversations", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),),
            const SizedBox(height: 10,),
            Text('To keep interactions flowing smoothly, you\'re limited to sending 2 messages before waiting for a reply from the other person. This helps maintain a balanced and respectful conversation', style: theme.textTheme.bodyMedium?.copyWith(height: 1.5), textAlign: TextAlign.center,),
            const SizedBox(height: 15,),
            CustomButtonWidget(text: "Got it!", onPressed: () {
              context.popScreen();
            }, expand: true,)
          ],
        ),
      ),
    );
  }
}
