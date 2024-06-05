import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/preferences/data/store/enums.dart';
import 'package:sparkduet/features/preferences/data/store/preferences_cubit.dart';
import 'package:sparkduet/features/preferences/data/store/preferences_state.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';

class FeedbackPage extends StatefulWidget {

  final ScrollController? controller;
  final String? reason;
  const FeedbackPage({super.key, this.controller, this.reason});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {

  final messageController = TextEditingController();

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

  void submitFeedbackHandler(BuildContext context) {
    bool validated = true;
    if(messageController.text.trim().isEmpty) {
      validated = false;
    }

    if(!validated) {
      context.showSnackBar("Kindly enter the message in the feedback box", appearance: NotificationAppearance.info);
      return;
    }

    final trimmedMessage = messageController.text.trim();

    context.read<PreferencesCubit>().createFeedback(message: trimmedMessage);

  }

  void prefCubitListener(BuildContext context, PreferencesState event) {
    if(event.status == PreferencesStatus.createFeedbackSuccessful) {
      if(context.mounted) {
        context.showSnackBar("Thanks for reporting this post");
        context.popScreen();
      }
    }

    if(event.status == PreferencesStatus.createFeedbackFailed) {
      if(context.mounted) {
        context.showSnackBar(event.message ?? "");
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
          title: Text("Feedback", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),),
        ),
        body: BlocListener<PreferencesCubit, PreferencesState>(
          listener: prefCubitListener,
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

                        CustomTextFieldWidget(
                          controller: messageController,
                          label: "Message",
                          // labelFontWeight: FontWeight.bold,
                          maxLines: null,
                          minLines: 4,
                          placeHolder: "eg. I'm unable to create a post",
                        ),
                        const SizedBox(height: 10,),
                        BlocBuilder<PreferencesCubit, PreferencesState>(
                          builder: (context, prefState) {
                            return CustomButtonWidget(
                              loading: prefState.status == PreferencesStatus.createFeedbackInProgress,
                              text: "Submit feedback", onPressed: () => submitFeedbackHandler(context), expand: true,
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
