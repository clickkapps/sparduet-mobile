import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_purpose.dart';
import 'package:sparkduet/features/files/mixin/file_manager_mixin.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';

class IntroductionPage extends StatelessWidget with FileManagerMixin{

  final Function(PostFeedPurpose) onAccept;
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

            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(AppConstants.introductoryPostFeedPurpose.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w300, fontSize: 18),),
            ),

            Text(AppConstants.introductoryPostFeedPurpose.description, style: theme.textTheme.titleSmall,),
            CustomButtonWidget(text: "Let's start", onPressed: () => onAccept.call(AppConstants.introductoryPostFeedPurpose), expand: true,)

          ],
        ),
      ),
    );
  }
}
