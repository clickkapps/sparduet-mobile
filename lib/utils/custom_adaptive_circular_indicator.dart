import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAdaptiveCircularIndicator extends StatelessWidget {
  final double? size;
  const CustomAdaptiveCircularIndicator({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Platform.isIOS
        ? CupertinoActivityIndicator(color: theme.colorScheme.primary,)
        :  SizedBox(
          width: size ?? 20, height: size ?? 20,
          child: CircularProgressIndicator(color: theme.colorScheme.primary, strokeWidth: 2),
        );
  }
}
