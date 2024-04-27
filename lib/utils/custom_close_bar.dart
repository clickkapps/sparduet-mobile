import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_extensions.dart';

class CustomCloseBar extends StatelessWidget {
  const CustomCloseBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.topRight,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: GestureDetector(
            onTap: () {
              context.popScreen();
            },
            child: ColoredBox(
                color: theme.colorScheme.outline,
                child:  SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(
                        child: Icon(Icons.close, size: 20, color: theme.colorScheme.background,)))),
          )
      ),
    );
  }
}
