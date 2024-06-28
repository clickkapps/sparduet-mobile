import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_row/separated_row.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/data/store/enums.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_state.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';

class BlockUserPage extends StatefulWidget {

  final UserModel user;
  final ScrollController? controller;
  final String? reason;
  const BlockUserPage({super.key, this.controller, this.reason, required this.user});

  @override
  State<BlockUserPage> createState() => _BlockUserPageState();
}

class _BlockUserPageState extends State<BlockUserPage> {

  final messageController = TextEditingController();
  final ValueNotifier<String> selectedSuggestion = ValueNotifier("");
  final List<String> postReportSuggestions  = <String>["Fake account", "Scam", "Contain nudes", "Contain violence", "Investigate this user", "Inappropriate content"];


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
    final trimmedMessage = messageController.text.trim();
    final trimmedSuggestion = selectedSuggestion.value.trim();
    String reason = trimmedMessage.isNotEmpty ? trimmedMessage : trimmedSuggestion;

    context.read<UserCubit>().blockUser(offenderId: widget.user.id, reason: reason);

  }

  void userCubitListener(BuildContext context, UserState event) {
    if(event.status == UserStatus.blockUserSuccessful) {
      if(context.mounted) {
        context.showSnackBar("Your blocked user");
        context.popScreen();
      }
    }

    if(event.status == UserStatus.blockUserFailed) {
      if(context.mounted) {
        context.showSnackBar(event.message ?? "Oops!. Kindly check your connection and try again");
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
          title: Text("Block user", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),),
        ),
        body: BlocListener<UserCubit, UserState>(
          listener: userCubitListener,
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
                          placeHolder: "eg. This user is a scam",
                        ),
                        const SizedBox(height: 10,),
                        BlocBuilder<UserCubit, UserState>(
                          builder: (context, userState) {
                            return CustomButtonWidget(
                              loading: userState.status == UserStatus.reportUserInProgress,
                              text: "Block now", onPressed: () => submitReportHandler(context), expand: true,
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
