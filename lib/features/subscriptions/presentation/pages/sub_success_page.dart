import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sparkduet/core/app_assets.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';

class SubSuccessPage extends StatelessWidget {

  final Function()? onTap;
  const SubSuccessPage({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.green,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
                mainAxisSize: MainAxisSize.min,
                 children: [
                   Lottie.asset(AppAssets.ksubSuccessJson , height: 200, ),
                   Text("Congrats!. You have unlocked all features.", textAlign: TextAlign.center, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),),
                   const SizedBox(height: 10,),
                   Text("Thanks for your purchase", textAlign: TextAlign.center, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),),
                   const SizedBox(height: 30,),
                   CustomButtonWidget(text: "Continue", onPressed: () {
                     context.popScreen();
                     onTap?.call();
                   }, expand: true, backgroundColor: Colors.white, textColor: Colors.black,)
                 ],
              ),
      ),
    );
  }
}
