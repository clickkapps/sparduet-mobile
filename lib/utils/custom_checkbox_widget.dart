import 'package:flutter/material.dart';

class CustomCheckboxWidget extends StatelessWidget {

  final bool checked;
  final Function(bool)? onChange;
  final double borderRadius;
  final Color? borderColor;
  final double size;
  final Color? fillColor;
  const CustomCheckboxWidget({super.key, this.checked = false, this.borderColor, this.onChange, this.borderRadius = 4, this.size = 25, this.fillColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius), // Adjust the value to control the corner radius
          color: fillColor ?? theme.colorScheme.surface,
          // color: Colors.red,
          border:  Border.all(color: borderColor ?? theme.colorScheme.onBackground)
      ),
      width: size,
      height: size,
      child: Theme(
        data: theme.copyWith(
        ),
        child: Checkbox(
          value: checked,
          onChanged: (v) { onChange?.call(v!);},
          side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 1.0, color: Colors.transparent),),
          // MaterialStateProperty.resolveWith<double>((states) => 0)
          // fillColor: MaterialStateProperty<Color>.,

          checkColor: theme.colorScheme.onSurface,
          // checkColor: Colors.red,
          fillColor: MaterialStateProperty.resolveWith<Color>((states) => fillColor ?? theme.colorScheme.surface),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // Adjust the value to match the parent container's corner radius
            side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 1.0, color: Colors.transparent),)
          ),
        ),
      ),
    );
  }
}
