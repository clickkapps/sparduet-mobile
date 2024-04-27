import 'package:flutter/material.dart';

class CustomFadeInPageRoute<T> extends PageRoute<T> {

  final Color color;
  CustomFadeInPageRoute(this.child, {required this.color});

  @override
  Color get barrierColor => color.withOpacity(0.0);

  @override
  String? get barrierLabel => null;

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;


  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
