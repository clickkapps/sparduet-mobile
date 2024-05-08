import 'package:flutter/material.dart';

class CustomBorderWidget extends StatelessWidget {
  final String? centerText;
  final Color? color;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  const CustomBorderWidget({
    this.color, this.centerText,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding:  EdgeInsets.only(left: paddingLeft, right: paddingRight, top: paddingTop, bottom: paddingBottom),
      child: Row(
        children: [
          Expanded(child: Container(
            color: color ?? (theme.brightness == Brightness.light ? theme.colorScheme.outlineVariant : theme.colorScheme.outline.withOpacity(0.5)),
            height: 1,
          )),
          if(centerText != null) ...{
            Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(centerText!, style: TextStyle(color: color ?? theme.colorScheme.outlineVariant),),
            )
          },
          Expanded(child: Container(
            color: color ?? (theme.brightness == Brightness.light ? theme.colorScheme.outlineVariant : theme.colorScheme.outline.withOpacity(0.5)),
            height: 1,
          ))
        ],
      ),
    );
  }
}
