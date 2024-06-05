import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/chat/data/models/chat_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_user_model.dart';
import 'package:sparkduet/features/chat/data/models/message_model.dart';
import 'package:sparkduet/features/chat/data/store/chat_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_state.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';
import 'package:sparkduet/features/chat/presentation/widgets/empty_chat_widget.dart';
import 'package:sparkduet/features/chat/presentation/widgets/message_item_widget.dart';
import 'package:sparkduet/features/chat/presentation/widgets/send_chat_message_button_widget.dart';
import 'package:sparkduet/mixin/launch_external_app_mixin.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:swipe_to/swipe_to.dart';


// chat preview layout -> https://medium.com/@ximya/tips-and-tricks-for-implementing-a-successful-chat-ui-in-flutter-190cd81bdc64
class ChatPreviewPage extends StatefulWidget {

  final ChatUserModel otherParticipant;
  final ChatModel? chatConnection;
  const ChatPreviewPage({super.key, required this.otherParticipant, this.chatConnection});

  @override
  State<ChatPreviewPage> createState() => _ChatPreviewPageState();
}

class _ChatPreviewPageState extends State<ChatPreviewPage> with LaunchExternalAppMixin {

  final focusNode = FocusNode();
  final chatEditorController = TextEditingController();
  final ValueNotifier<bool> showSubmitButton = ValueNotifier(false);
  final scrollController = ScrollController();
  late ChatPreviewCubit chatPreviewCubit;
  late ChatCubit chatCubit;
  final ValueNotifier<MessageModel?> messageToReply = ValueNotifier(null);
  ChatModel? chatConnection;


  @override
  void initState() {
    chatConnection = widget.chatConnection; // may still be null
    focusNode.requestFocus();
    chatCubit = context.read<ChatCubit>();
    chatPreviewCubit = context.read<ChatPreviewCubit>();

    if(chatConnection  == null) {
      chatCubit.createChatConnection(widget.otherParticipant).then((value) {
        if(value.$1 != null) {
          // there was an error creating chat connection/ Not supposed to happen in production
          if(mounted) {
            context.showSnackBar("Oops!Kindly check your network connection", appearance: NotificationAppearance.error);
            // context.pop();
          }
          return;
        }
        chatConnection = value.$2;
        initiateMessages(chatConnection!);

      });
    }else {
      initiateMessages(chatConnection!);
    }

    super.initState();
  }

  void initiateMessages(ChatModel chat) {
    chatPreviewCubit.fetchChatMessages(chatConnection: chat, pageKey: 1).then((value) {
      // listen to message after message have been fetched
      chatPreviewCubit.listenToMessages(chatConnection: chat);
      chatPreviewCubit.markChatConnectionAsRead(chat);
      chatPreviewCubit.markOtherParticipantMessageAsRead(chat); // mark messages as read when app initializes
      // and its also marked as read when new message is received and user is in the app
    });

  }

  @override
  void dispose() {

    focusNode.dispose();
    chatEditorController.dispose();
    scrollController.dispose();
    chatPreviewCubit.cancelMessagesListener();
    
    super.dispose();

  }

  void chatEditorTextChangeHandler(String value) {
    if(value.trim().isNotEmpty && !showSubmitButton.value) {
      showSubmitButton.value = true;
    }

    if(value.trim().isEmpty && showSubmitButton.value) {
      showSubmitButton.value = false;
    }
  }

  void submitMessageHandler() {

    final message = chatEditorController.text.trim();
    final otherParticipant = widget.otherParticipant;

    chatPreviewCubit.sendMessage(message: message, otherParticipant: otherParticipant, parent: messageToReply.value, chatConnection: chatConnection);
    chatEditorController.clear();
    showSubmitButton.value = false;
    messageToReply.value = null;

    // Move the scroll position to the bottom
    if (scrollController.hasClients) {
      scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

  }

  void chatPreviewCubitListener(BuildContext ctx, ChatPreviewState chatPreviewState) async {
    if (chatPreviewState.status == ChatPreviewStatus.sendMessageSuccessful) {
      // await messageSentAssetsAudioPlayer.open(Audio(kMessageSentMp3),);
      // messageSentAssetsAudioPlayer.play();
    }
  }

  void openMessageOptionsModal(BuildContext context, MessageModel message) {

    final theme = Theme.of(context);

    final ch = ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        color: theme.brightness == Brightness.light ? const Color(0xffF2F3F4) : const Color(0xff202021),
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: GestureDetector(
                      onTap: () {
                        context.popScreen();
                      },
                      child: ColoredBox(
                          color: theme.brightness == Brightness.light ? const Color(0xffc2c2c2) : theme.colorScheme.outline,
                          child:  SizedBox(
                              width: 30,
                              height: 30,
                              child: Center(
                                  child: Icon(Icons.close, size: 20, color: theme.colorScheme.background,)))),
                    )
                ),
              ),

              const SizedBox(height: 20,),

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: theme.colorScheme.surface
                ),
                child: SeparatedColumn(
                  mainAxisSize: MainAxisSize.min,
                  separatorBuilder: (BuildContext context, int index) {
                    return CustomBorderWidget(color: theme.colorScheme.outline.withOpacity(theme.brightness == Brightness.light ? 0.1 : 0.2),);
                  },
                  children: [

                    ListTile(title: Text("Delete message", style: theme.textTheme.bodyMedium), onTap: () {
                      context.popScreen();
                      if(chatConnection != null) {
                        chatPreviewCubit.deleteMessage(chatConnection: chatConnection!, message: message);
                      }

                    }, trailing: Icon(FeatherIcons.delete, size: 20, color: theme.colorScheme.onSurface,),),
                    ListTile(title: Text("Reply message", style: theme.textTheme.bodyMedium), onTap: () {
                      context.popScreen();
                      // chatPreviewCubit.deleteMessage(message);
                      messageToReply.value = message;
                      if(!focusNode.hasFocus){
                        focusNode.requestFocus();
                      }
                    }, trailing: Icon(FeatherIcons.messageSquare, size: 20, color: theme.colorScheme.onSurface,),)
                    // ListTile(title: Text("Asian", style: theme.textTheme.bodyMedium), onTap: () {
                    //   pop(context);
                    //   raceController.text = "Asian";
                    //
                    // },),
                    // ListTile(title: Text("Black or African American", style: theme.textTheme.bodyMedium), onTap: () {
                    //   pop(context);
                    //   raceController.text = "Black or African American";
                    //
                    // },),
                    // ListTile(title: Text("Middle Eastern or North African", style: theme.textTheme.bodyMedium), onTap: () {
                    //   pop(context);
                    //   raceController.text = "Middle Eastern or North African";
                    //
                    // },),
                    // ListTile(title: Text("Native Hawaiian or other Pacific Islander", style: theme.textTheme.bodyMedium), onTap: () {
                    //   pop(context);
                    //   raceController.text = "Native Hawaiian or other Pacific Islander";
                    // },),
                    // ListTile(title: Text("Hispanic, Latino, or Spanish origin", style: theme.textTheme.bodyMedium), onTap: () {
                    //   pop(context);
                    //   raceController.text = "Hispanic, Latino, or Spanish origin";
                    // },),
                    // ListTile(title: Text("White", style: theme.textTheme.bodyMedium,), onTap: () {
                    //   pop(context);
                    //   raceController.text = "White";
                    // },),
                    // ListTile(title: Text("Other", style: theme.textTheme.bodyMedium), onTap: () {
                    //   pop(context);
                    //   raceController.text = "Other";
                    // },),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );

    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)));

  }


  /// Build UI
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final currentUser = context.read<AuthCubit>().state.authUser;

    return  Scaffold(
     resizeToAvoidBottomInset: true, // assign true
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
        title:  Text("${widget.otherParticipant.name} ", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
        centerTitle: true,
        backgroundColor: theme.colorScheme.background,
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: CustomBorderWidget(),),
      ),
       body: BlocBuilder<ChatPreviewCubit, ChatPreviewState>(
         buildWhen: (ctx, chatPreviewState) {
            return chatPreviewState.status == ChatPreviewStatus.refreshChatMessagesSuccessful;
         },
         builder: (context, chatPreviewState) {
           return  SafeArea(child: Column(
             children: [

               if(chatPreviewState.status == ChatPreviewStatus.fetchChatMessagesInProgress) ... {
                 const Expanded(
                   child: Center(child: CustomAdaptiveCircularIndicator(),),
                 )
               } else  ... {
                 Expanded(child: GestureDetector(
                   onTap: () {
                     FocusScope.of(context).unfocus(); // <-- Hide virtual keyboard
                   },
                   child: Align(
                     alignment: Alignment.topCenter,
                     child: chatPreviewState.reOrderedChatMessages.isEmpty ?
                     const SingleChildScrollView(
                       reverse:true, child: Padding(
                         padding: EdgeInsets.only(bottom: 20),
                         child: EmptyChatWidget()),) : ListView.separated(
                       reverse: true,
                       shrinkWrap: true,
                       controller: scrollController,
                       keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                       itemBuilder: (ctx, index) {

                         DateTime date = chatPreviewState.reOrderedChatMessages.keys.elementAt(index);
                         List<MessageModel> messages = chatPreviewState.reOrderedChatMessages[date]!;
                         return Column(
                           key: ValueKey(date),
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             /// Days here  --------
                             Align(
                               alignment: Alignment.topCenter,
                               child: Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                                   margin: const EdgeInsets.only(top: 15, bottom: 15),
                                   decoration: BoxDecoration(
                                       borderRadius:
                                       const BorderRadius.all(Radius.circular(20)),
                                       color: theme.colorScheme.surface),
                                   child: Text(
                                     getFormattedDateWithIntl(date, format: 'MMMM dd, yyyy'),
                                     style: TextStyle( color: theme.colorScheme.onBackground, fontSize: 9),
                                   )),
                             ),

                             SeparatedColumn(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               separatorBuilder: (BuildContext context, int index) {
                                 // final message = messages[index];
                                 // if(message.parent != null) {
                                 //   return const SizedBox(height: 10,);
                                 // }
                                 return const SizedBox(height: 5,);
                               },
                               children: [

                                 ...messages.map((message) {
                                   return  SwipeTo(
                                     key: ValueKey(message.id),
                                     iconOnLeftSwipe: Icons.arrow_forward,
                                     iconOnRightSwipe: Icons.arrow_back,
                                     onRightSwipe: (details) {
                                       messageToReply.value = message;
                                       if(!focusNode.hasFocus){
                                         focusNode.requestFocus();
                                       }
                                     },
                                     swipeSensitivity: 20,
                                     child: MessageItemWidget(message: message, onLongPress: (message) {
                                       openMessageOptionsModal(context, message);
                                     },),
                                   );
                                 })
                                 // ...dateGroupedModels.map((group) {
                                 //   final index = dateGroupedModels.indexOf(group);
                                 //   MessageModel firstModel = group.first;
                                 //
                                 //   debugPrint("group: ${group.to}");
                                 //   return SeparatedColumn(
                                 //     key: ValueKey("Chat-GroupKey-$index"),
                                 //     crossAxisAlignment: CrossAxisAlignment.start,
                                 //     separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10,),
                                 //     children: [
                                 //
                                 //       /// each ChatMessageModel under each user here ----
                                 //       ...group.map((MessageModel model) {
                                 //         if(model == chatPreviewState.linearMessagesList.last) {
                                 //           debugPrint("last chat: $model");
                                 //         }
                                 //
                                 //         // return BlocSelector<ChatPreviewCubit, ChatPreviewState, MessageModel>(
                                 //         //   selector: (state) {
                                 //         //     return state.linearMessagesList.where((element) => element.id == model.id).first;
                                 //         //   },
                                 //         //   builder: (context, messageModel) {
                                 //         //     return MessageItemWidget(message: messageModel);
                                 //         //   },
                                 //         // );
                                 //
                                 //         return;
                                 //
                                 //
                                 //         // return SeparatedColumn(
                                 //         //   crossAxisAlignment: CrossAxisAlignment.start,
                                 //         //   mainAxisSize: MainAxisSize.min,
                                 //         //   key: ValueKey("${model.createdAt!}${model.id}"),
                                 //         //   // mainAxisSize: MainAxisSize.min,
                                 //         //   //  crossAxisAlignment: CrossAxisAlignment.start,
                                 //         //   separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10,),
                                 //         //   children: [
                                 //         //
                                 //         //
                                 //         //     // if (model.attachments != null && model.attachments!.isNotEmpty && checksEqual(model.attachments![0].type!, 'image')) ...{
                                 //         //     //   ClipRRect(
                                 //         //     //     borderRadius: BorderRadius.circular(5),
                                 //         //     //     child: CustomImagesWidget(
                                 //         //     //       images: [model.attachments![0].value!],
                                 //         //     //       heroTag: model.attachments![0].value!,
                                 //         //     //       onTap: (index, images) {
                                 //         //     //         // context.push(context.generateRoutePath(subLocation: chatImagesPreviewPage), extra: {
                                 //         //     //         //   'chat': model,
                                 //         //     //         //   'galleryItems': images,
                                 //         //     //         //   'initialPageIndex': index
                                 //         //     //         // });
                                 //         //     //       },
                                 //         //     //     ),
                                 //         //     //   )
                                 //         //     // }
                                 //         //
                                 //         //   ],
                                 //         // );
                                 //       }).toList(),
                                 //     ],
                                 //   );
                                 //
                                 // }).toList(),

                               ],
                             ),
                           ],
                         );
                         // final message = MessageModel.fromJson(exampleMessages[i]);
                         // final message = chatPreviewState.linearMessagesList[index];
                         // return MessageItemWidget(message: message);
                       }, separatorBuilder: (c, i) {
                       return const SizedBox(height: 20,);
                     }, itemCount: chatPreviewState.reOrderedChatMessages.length, padding:  const EdgeInsets.only( top: 0, bottom: 20),
                     ),
                   ),
                 ))
               },

               ValueListenableBuilder<MessageModel?>(valueListenable: messageToReply, builder: (_, msg, __) {
                 if(msg == null) {
                   return const SizedBox.shrink();
                 }
                 return FadeInUp(
                     preferences: const AnimationPreferences(
                         duration: Duration(milliseconds: 100)
                     ),
                     child: Container(
                       color: theme.brightness == Brightness.light ? const Color(0xffDDDEDF) : const Color(0xff202021),
                       child: IntrinsicHeight(
                         child: Row(
                           children: [
                             Container(
                               width: 5,
                               color: theme.colorScheme.primary,
                             ),
                             const SizedBox(width: 5,),
                             Expanded(child: Padding(
                               padding: const EdgeInsets.only(top: 8.0, bottom: 0, left: 14),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(msg.sentBy?.id == currentUser?.id ? "You" : (msg.sentBy?.name ?? ""), style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),),
                                   const SizedBox(height: 3,),
                                   Text(msg.message ?? "", style:  theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                 ],
                               ),
                             )),
                             const SizedBox(width: 5,),
                             ClipRRect(
                                 borderRadius: BorderRadius.circular(50),
                                 child: GestureDetector(
                                   onTap: () {
                                     messageToReply.value = null;
                                   },
                                   child: ColoredBox(
                                       color: theme.brightness == Brightness.light ? const Color(0xffc2c2c2) : theme.colorScheme.outline,
                                       child:  SizedBox(
                                           width: 25,
                                           height: 25,
                                           child: Center(
                                               child: Icon(Icons.close, size: 20, color: theme.colorScheme.background,)))),
                                 )
                             ),
                             const SizedBox(width: 5,),
                           ],
                         ),
                       ),
                     )
                 );
               }),
               ValueListenableBuilder<MessageModel?>(valueListenable: messageToReply, builder: (_, msg, __) {
                 return Container(
                   // color: theme.colorScheme.background,
                   color: msg == null ? theme.colorScheme.background : theme.brightness == Brightness.light ? const Color(0xffDDDEDF) : const Color(0xff202021),
                   padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20, bottom: 10.0),
                   child: CupertinoTextField(
                     focusNode: focusNode,
                     cursorColor: theme.colorScheme.onSurface,
                     controller: chatEditorController,
                     textCapitalization: TextCapitalization.sentences,
                     onChanged: chatEditorTextChangeHandler,
                     style: TextStyle(color: theme.colorScheme.onBackground),
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(20),
                         // border: Border.all(color: theme.colorScheme.outline)
                         color: theme.colorScheme.surface
                     ),
                     cursorWidth: 1,
                     maxLines: null,
                     // cursorHeight: 14,
                     placeholder: 'Type your message ...',
                     placeholderStyle:  theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                     keyboardAppearance: theme.brightness,
                     padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
                     textAlign: TextAlign.start,
                     suffix: ValueListenableBuilder<bool>(valueListenable: showSubmitButton, builder: (_, show, ch) {
                       if(show) return ch!;
                       return const SizedBox.shrink();
                     },child:  Padding(
                       padding: const EdgeInsets.only(right: 5),
                       child: SendChatMessageButtonWidget(onTap: submitMessageHandler,),
                     ),),

                   ),
                 );
               }),

             ],
           ));
         },
       )



    );

  }
}
