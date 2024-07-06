import 'package:flutter/material.dart';

class CustomFastPageScrollPhysics extends ScrollPhysics {
  const CustomFastPageScrollPhysics({super.parent});

  @override
  CustomFastPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomFastPageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 150,
    stiffness: 100,
    damping: 1,
  );
}