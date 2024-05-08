import 'package:flutter/material.dart';

class CustomEmptyContentWidget extends StatelessWidget {

  final String? title;
  final String? subTitle;
  const CustomEmptyContentWidget({
    this.title,
    this.subTitle,
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
          child: Text(title ?? 'No information here yet...',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w800),),
        ),
        const SizedBox(height: 10,),
        Text(subTitle ?? "Information will be displayed here once it’s available.",
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall,),
        // if(subTitle != null) ... {
        //
        // }
      ],
    );
  }
}
