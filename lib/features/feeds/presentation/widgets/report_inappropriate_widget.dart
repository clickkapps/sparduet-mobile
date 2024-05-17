import 'package:flutter/material.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';

class ReportInAppropriateWidget extends StatefulWidget {

  final ScrollController? scrollController;
  final FeedModel feedModel;
  const ReportInAppropriateWidget({super.key, this.scrollController, required this.feedModel});

  @override
  State<ReportInAppropriateWidget> createState() => _ReportInAppropriateWidgetState();
}

class _ReportInAppropriateWidgetState extends State<ReportInAppropriateWidget> {

  final TextEditingController messageTextEditingController = TextEditingController();

  @override
  void dispose() {
    messageTextEditingController.dispose();
    super.dispose();
  }

  void onSubmitHandler(BuildContext ctx) {

  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return ColoredBox(
        color: theme.colorScheme.background,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Report post", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),),
                const SizedBox(height: 30,),
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      CustomTextFieldWidget(
                        controller: messageTextEditingController,
                        label: "Tell us why this video is inappropriate.",
                        // labelFontWeight: FontWeight.bold,
                        maxLines: null,
                        minLines: 4,
                        placeHolder: "eg. Contains nudes",
                      ),
                      const SizedBox(height: 10,),
                      CustomButtonWidget(text: "Submit report", onPressed: () => onSubmitHandler(context), expand: true,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
