import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sparkduet/core/app_assets.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';

class FirstImpressionExplanationPage extends StatelessWidget {

  final ScrollController? controller;
  const FirstImpressionExplanationPage({super.key, this.controller});

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
             Lottie.asset(AppAssets.kMatchedConversationsJson ),
             const SizedBox(height: 15,),
             Text("Making a Great First Impression", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),),
             const SizedBox(height: 10,),
             Text('Stand out with engaging and expressive greetings! Simple messages like "Hi" or "Hello" may not capture attention. Be creative and warm to make your initial contact memorable', style: theme.textTheme.bodyMedium?.copyWith(height: 1.5), textAlign: TextAlign.center,),
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
