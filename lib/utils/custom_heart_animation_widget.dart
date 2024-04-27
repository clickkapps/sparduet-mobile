import 'package:flutter/material.dart';

class CustomHeartAnimationWidget extends StatefulWidget {

  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final Duration delay;
  final VoidCallback? onEnd;
  final bool alwayAnimate;
  final double scaleTo;

  const CustomHeartAnimationWidget({
    super.key,
    required this.child,
    required this.isAnimating,
    this.alwayAnimate = false,
    this.scaleTo = 1.5,
    this.onEnd,
    this.duration = const Duration(milliseconds: 150),
    this.delay = const Duration(milliseconds: 400),
  });

  @override
  State<CustomHeartAnimationWidget> createState() => _CustomHeartAnimationWidgetState();
}

class _CustomHeartAnimationWidgetState extends State<CustomHeartAnimationWidget> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    final halfDuration = widget.duration.inMilliseconds ~/ 2;
    controller = AnimationController(
        vsync: this,
      duration: Duration(milliseconds: halfDuration)
    );
    scale = Tween<double>(begin: 1, end: widget.scaleTo).animate(controller);
  }

  @override
  void didUpdateWidget(covariant CustomHeartAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isAnimating != oldWidget.isAnimating) {
      doAnimation();
    }
  }

  Future doAnimation() async {
    if(widget.isAnimating || widget.alwayAnimate) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(widget.delay);
      widget.onEnd?.call();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
        child: widget.child);
  }
}
