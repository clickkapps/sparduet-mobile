import 'dart:io';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sparkduet/core/app_colors.dart';

class CustomAdaptiveCircularIndicator extends StatelessWidget {
  final double? size;
  const CustomAdaptiveCircularIndicator({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LoadingAnimationWidget.twistingDots(
      leftDotColor: AppColors.desire,
      rightDotColor: AppColors.buttonBlue,
      size: size ?? 40,
    );
    // return Platform.isIOS
    //     ? CupertinoActivityIndicator(color: theme.colorScheme.primary,)
    //     :  SizedBox(
    //       width: size ?? 20, height: size ?? 20,
    //       child: CircularProgressIndicator(color: theme.colorScheme.primary, strokeWidth: 2),
    //     );
  }
}
