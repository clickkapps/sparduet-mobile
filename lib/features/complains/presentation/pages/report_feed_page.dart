import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_row/separated_row.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';

class ReportFeedPage extends StatefulWidget {

  final FeedModel feed;
  final ScrollController? controller;
  final String? reason;
  const ReportFeedPage({super.key, this.controller, this.reason, required this.feed});

  @override
  State<ReportFeedPage> createState() => _ReportFeedPageState();
}

class _ReportFeedPageState extends State<ReportFeedPage> {

  final messageController = TextEditingController();
  final ValueNotifier<String> selectedSuggestion = ValueNotifier("");
  final List<String> postReportSuggestions  = <String>["Fake account", "Spam", "Contain nudes", "Contain violence", "Investigate this user", "Inappropriate content"];


  @override
  void initState() {
    if((widget.reason ?? "").isNotEmpty) {
      messageController.text = widget.reason ?? "";
    }
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void submitReportHandler(BuildContext context) {
    bool validated = true;
    if(messageController.text.trim().isEmpty) {
      validated = false;
    }
    if(!validated && selectedSuggestion.value.trim().isEmpty) {
      validated = false;
    }

    if(!validated) {
      context.showSnackBar("Kindly state the reason for reporting this post", appearance: NotificationAppearance.info);
      return;
    }
    
    final trimmedMessage = messageController.text.trim();
    final trimmedSuggestion = selectedSuggestion.value.trim();
    String reason = trimmedMessage.isNotEmpty ? trimmedMessage : trimmedSuggestion;
    
    context.read<FeedsCubit>().reportPost(postId: widget.feed.id, reason: reason);
    
  }
  
  void feedCubitListener(BuildContext context, FeedState event) {
    if(event.status == FeedStatus.reportPostSuccessful) {
      if(context.mounted) {
        context.showSnackBar("Thanks for reporting this post");
        context.popScreen();
      }
    }

    if(event.status == FeedStatus.reportPostFailed) {
      if(context.mounted) {
        context.showSnackBar(event.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          // automaticallyImplyLeading: false,
          leading: const CloseButton(),
          title: Text("Report post", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),),
        ),
        body: BlocListener<FeedsCubit, FeedState>(
          listener: feedCubitListener,
          child: SingleChildScrollView(
            controller: widget.controller,
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(
                        mainAxisSize: MainAxisSize.min,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text("Suggested reasons", style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),),
                           const SizedBox(height: 10,),
                           ValueListenableBuilder<String>(valueListenable: selectedSuggestion, builder: (_, selected, __) {
                             return Wrap(
                               runSpacing: 8,
                               spacing: 8,
                               children: [
                                 ...postReportSuggestions.map((suggestion) {
                                   return GestureDetector(
                                     onTap: () {
                                       selectedSuggestion.value = suggestion;
                                       messageController.text = suggestion;
                                     },
                                     child: Container(
                                       decoration: BoxDecoration(
                                           border: Border.all(color: theme.colorScheme.outline),
                                           borderRadius: BorderRadius.circular(4)
                                       ),
                                       padding: const EdgeInsets.all(8),
                                       child: SeparatedRow(
                                         mainAxisSize: MainAxisSize.min,
                                         separatorBuilder: (BuildContext context, int index) {
                                           return const SizedBox(width: 5,);
                                         },
                                         children: [
                                           Text(suggestion, style: const TextStyle(fontSize: 12),),
                                           if(selected.toLowerCase().contains(suggestion.toLowerCase())) ... {
                                             const Icon(Icons.check_circle, size: 16, color: Colors.green,)
                                           }

                                         ],
                                       )

                                       //
                                     ),
                                   );
                                 })
                               ],
                             );
                           },)


                         ],
                      ),

                      const SizedBox(height: 20,),

                      CustomTextFieldWidget(
                        controller: messageController,
                        label: "Reason",
                        // labelFontWeight: FontWeight.bold,
                        maxLines: null,
                        minLines: 4,
                        placeHolder: "eg. Post contains nudes",
                      ),
                      const SizedBox(height: 10,),
                      BlocBuilder<FeedsCubit, FeedState>(
                        builder: (context, feedState) {
                          return CustomButtonWidget(
                            loading: feedState.status == FeedStatus.reportPostInProgress,
                            text: "Submit report", onPressed: () => submitReportHandler(context), expand: true,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
)
    );
  }
}
