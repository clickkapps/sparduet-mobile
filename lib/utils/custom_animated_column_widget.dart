import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

enum AnimationType { slideLeft, slideUp, scale }

/// This widget adds animation to the default column widget.
/// It can be used and customized just like the default column widget
///
/// Relies on the flutter_staggered_animations library -> ref: https://pub.dev/packages/flutter_staggered_animations
class CustomAnimatedColumnWidget extends StatelessWidget {

  final List<Widget> children;
  final AnimationType animationType;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final VerticalDirection verticalDirection;
  final int duration;

  const CustomAnimatedColumnWidget({super.key,
    required this.children, this.animationType= AnimationType.slideUp,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.duration = 375,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.textBaseline,
    this.verticalDirection = VerticalDirection.down
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        textBaseline: textBaseline,
        verticalDirection: verticalDirection,
        children: AnimationConfiguration.toStaggeredList(
          duration: Duration(milliseconds: duration),
          childAnimationBuilder: _animationTypeWidget,
          children: children,
        ),
      ),
    );
  }

  // distinguishes the animation types
  Widget _animationTypeWidget (Widget widget) {
    switch(animationType){
      case AnimationType.slideLeft:
        return SlideAnimation(
          horizontalOffset: 50.0,
          child: widget,
        );
      case AnimationType.slideUp:
        return SlideAnimation(
          verticalOffset: 50.0,
          child: widget,
        );
      case AnimationType.scale:
        return ScaleAnimation(
          child: widget,
        );
      default:
        return ScaleAnimation(
          child: widget,
        );
    }
  }

}
