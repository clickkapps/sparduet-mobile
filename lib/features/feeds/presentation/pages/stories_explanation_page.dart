import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sparkduet/core/app_assets.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';

class StoriesExplanationPage extends StatefulWidget {

  final ScrollController? controller;
  const StoriesExplanationPage({super.key, this.controller});

  @override
  State<StoriesExplanationPage> createState() => _StoriesExplanationPageState();
}

class _StoriesExplanationPageState extends State<StoriesExplanationPage> with SingleTickerProviderStateMixin {


  late AnimationController _hintController;
  late Animation<Offset> _hintOffsetAnimation;
  bool _showHint = false;

  @override
  void initState() {
    initHint();
    onWidgetBindingComplete(onComplete: () {
      showHint();
    });
    super.initState();
  }

  @override
  void dispose() {
    _hintController.dispose();
    super.dispose();
  }

  void initHint() {
    _hintController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _hintOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -0.4),
    ).animate(CurvedAnimation(
      parent: _hintController,
      curve: Curves.easeInOut,
    ));
  }

  void showHint() {
    setState(() {
      _showHint = true;
      _hintController.repeat(reverse: true);
    });
  }

  void hideHint() {
    // upd
    setState(() {
      _showHint = false;
      _hintController.stop();
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: widget.controller,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Column(
          children: [
            // Lottie.asset(AppAssets.kFirstImpressJson ),
            SlideTransition(
              position: _hintOffsetAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.swipe_up, size: 70, color: theme.brightness == Brightness.light ? AppColors.navyBlue : AppColors.buttonBlue),
                ],
              ),
            ),
            const SizedBox(height: 15,),
            Text("Looking for love?", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),),
            const SizedBox(height: 10,),
            Text("Swipe to see singles' posts. Interested? Hit the chat button to send a message!", style: theme.textTheme.bodyMedium?.copyWith(height: 1.5), textAlign: TextAlign.center,),
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
