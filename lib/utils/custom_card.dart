import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double padding;
  const CustomCard({super.key, required this.child, this.backgroundColor, this.padding = 20});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
        ),
        child: child,
      ),
    );
  }
}
