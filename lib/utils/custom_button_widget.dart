import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_colors.dart';

enum ButtonAppearance { primary, secondary, clean, error, success, dark, info }
class CustomButtonWidget extends StatelessWidget {

  final String text;
  final Function()? onPressed;
  final ButtonAppearance? appearance;
  final bool expand;
  final Widget? icon;
  final bool loading;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? outlineColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final bool disabled;
  final FontWeight? fontWeight;
  // final

  const CustomButtonWidget({
    required this.text,
    super.key, this.onPressed,
    this.appearance = ButtonAppearance.primary,
    this.expand = false,
    this.icon,
    this.loading = false,
    this.disabled = false,
    this.textColor,
    this.backgroundColor,
    this.outlineColor,
    this.borderRadius,
    this.padding,
    this.fontWeight
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
        width: expand ? mediaQuery.size.width : null,
        child: ElevatedButton.icon(
          icon: loading ? const SizedBox.shrink() : (icon ?? const SizedBox.shrink()),
          onPressed: loading ? null : (disabled ? null : (onPressed ?? (){})),
          label: Padding( padding: EdgeInsets.symmetric(horizontal: 0, vertical: expand ? 14 : 0),
          child: loading ?
              // Loading State
          // CupertinoActivityIndicator(color: appearance == Appearance.clean ? theme.colorScheme.onBackground : kAppWhite,)
           SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: theme.colorScheme.onPrimary, strokeWidth: 2,),)
              // Normal state
          : Text(text,
            textAlign: TextAlign.center,

            style: TextStyle(color:  textColor ?? ((onPressed == null || disabled) ? AppColors.white :
            appearance == ButtonAppearance.clean ? theme.colorScheme.onBackground :
            appearance == ButtonAppearance.secondary ? theme.colorScheme.onSecondary : theme.colorScheme.onPrimary
            ), fontWeight: fontWeight ?? FontWeight.w700),
          ),
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>((states) => 0),
          minimumSize:  MaterialStateProperty.resolveWith<Size?>((states) => padding != null ? Size.zero : null), // Set this
          padding: MaterialStateProperty.resolveWith<EdgeInsets?>((states) => padding), // and this
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular( borderRadius != null ? borderRadius! : expand? 5 : 3),
                  side: BorderSide(color: outlineColor ?? (appearance == ButtonAppearance.clean ? theme.colorScheme.outline : Colors.transparent), width: outlineColor != null ? 1 : 0)
              )
          ),
          // foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          //   if (states.contains(MaterialState.pressed)) {
          //     return theme.colorScheme.primary;
          //   }
          //   return kNiagaraGreen;
          // }),
          backgroundColor: backgroundColor != null ?
              MaterialStateProperty.resolveWith<Color>((states) => backgroundColor!)
              : MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                // appearance when button is pressed
                switch (appearance){
                  case ButtonAppearance.primary:
                    return theme.colorScheme.primary.withOpacity(0.5);
                  case ButtonAppearance.secondary:
                    return theme.colorScheme.secondary.withOpacity(0.5);
                  case ButtonAppearance.error:
                    return theme.colorScheme.error.withOpacity(0.5);
                  case ButtonAppearance.success:
                    return Colors.green.withOpacity(0.5);
                  case ButtonAppearance.dark:
                    return AppColors.black.withOpacity(0.5);
                  case ButtonAppearance.clean:
                    return Colors.transparent;
                  default:
                    return theme.colorScheme.primary.withOpacity(0.5);
                }

              }

              // background color

              if(onPressed == null || disabled){
                return theme.colorScheme.onSurface;
              }

              switch (appearance){
                case ButtonAppearance.primary:
                  return theme.colorScheme.primary;
                case ButtonAppearance.secondary:
                  return theme.colorScheme.secondary;
                case ButtonAppearance.error:
                  return theme.colorScheme.error;
                case ButtonAppearance.success:
                  return Colors.green;
                case ButtonAppearance.dark:
                  return AppColors.black;
                case ButtonAppearance.clean:
                  return Colors.transparent;
                default:
                  return theme.colorScheme.primary;
              }

            },
            ),
          ),
        ),
      );
  }
}
