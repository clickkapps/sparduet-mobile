import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/features/files/mixin/file_manager_mixin.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';

class IntroductionPage extends StatelessWidget with FileManagerMixin{

  final Function() onAccept;
  const IntroductionPage({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.background,
      padding: const EdgeInsets.all(15),
      child: CustomCard(
        child: SeparatedColumn(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 10,);
          },
          children: [

            Text("Hello dear", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 30),),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("Introduce yourself to suitors.", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w300, fontSize: 18),),
            ),

            Text("A good 30 seconds video will attract the best suitors.", style: theme.textTheme.titleSmall,),
            CustomButtonWidget(text: "Let's start", onPressed: onAccept,)

          ],
        ),
      ),
    );
  }
}
