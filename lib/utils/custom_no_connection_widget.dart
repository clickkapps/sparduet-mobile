import 'package:flutter/material.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';

class CustomNoConnectionWidget extends StatelessWidget {

  final String? title;
  final String? subTitle;
  final Function()? onRetry;
  const CustomNoConnectionWidget({
    this.title,
    this.subTitle,
    super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Lottie.asset(kNoConnectionJson, errorBuilder: (ctx, r, s) {
        //   return const SizedBox.shrink();
        // },height:  size.height / 2),
        const SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(title ?? 'Check your connection ...',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w800),),
        ),
        const SizedBox(height: 15,),
        Text(subTitle ?? "Kindly reconnect and try again",
          textAlign: TextAlign.left,
          style: theme.textTheme.titleSmall,),
        if(onRetry != null) ... {
          const SizedBox(height: 15,),
          CustomButtonWidget(
            text: 'Retry',
            onPressed: onRetry,
          ),

        }
      ],
    );
  }
}
