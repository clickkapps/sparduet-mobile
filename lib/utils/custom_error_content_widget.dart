import 'package:flutter/material.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';

class CustomErrorContentWidget extends StatelessWidget {

  final String? title;
  final String? subTitle;
  final Color? titleColor;
  final Color? subTitleColor;
  final Function()? onTap;
  final bool loading;
  const CustomErrorContentWidget({
    this.title,
    this.subTitle,
    this.onTap,
    this.titleColor,
    this.subTitleColor,
    this.loading = false,
    super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(title ?? 'Unable to connect...',
            textAlign: TextAlign.center,
            style: TextStyle(color: titleColor ?? theme.colorScheme.onBackground, fontWeight: FontWeight.w800),),
        ),
        const SizedBox(height: 10,),
        Text(subTitle ?? "Kindly restore your connection and try again",
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall?.copyWith(color: subTitleColor),),
        if(onTap != null) ... {
          const SizedBox(height: 20,),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: CustomButtonWidget(text: "Retry", onPressed: onTap, expand: true, loading: loading,),)
        }
      ],
    );
  }
}
