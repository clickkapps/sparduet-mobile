import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_colors.dart';

class CustomChipWidget extends StatelessWidget {

  final String? label;
  final Widget? labelWidget;
  final bool active;
  final bool border;
  final Function()? onTap;
  const CustomChipWidget({super.key,
    this.label, this.active = true, this.onTap,
    this.border = false,
    this.labelWidget
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          color: active ? (theme.brightness == Brightness.dark ? AppColors.buttonBlue : AppColors.darkColorScheme.background) : null,
          border: active ? null : (border ? Border.all(color: theme.colorScheme.outline) : null),
          borderRadius: BorderRadius.circular(40)
        ),
        child: labelWidget ?? Text(label ?? '', style: TextStyle(color: active ? AppColors.darkColorScheme.onBackground : theme.colorScheme.onBackground,),)
      ),
    );
  }
}
