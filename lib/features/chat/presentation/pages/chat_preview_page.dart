import 'dart:async';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_state.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_state.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';
import 'package:sparkduet/features/chat/presentation/widgets/empty_chat_widget.dart';
import 'package:sparkduet/features/chat/presentation/widgets/message_item_widget.dart';
import 'package:sparkduet/features/chat/presentation/widgets/send_chat_message_button_widget.dart';
import 'package:sparkduet/features/subscriptions/data/store/enum.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/subscriptions/presentation/pages/first_impression_explanation_page.dart';
import 'package:sparkduet/features/subscriptions/presentation/pages/matched_conversation_explanation_page.dart';
import 'package:sparkduet/features/subscriptions/presentation/ui_mixin/subsription_page_mixin.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_page_loading_overlay.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatPreviewPage extends StatefulWidget {

  final ChatConnectionModel? connection;
  final UserModel opponent;
  const ChatPreviewPage({super.key, this.connection, required this.opponent});

  @override
  State<ChatPreviewPage> createState() => _ChatPreviewPageState();
}

class _ChatPreviewPageState extends State<ChatPreviewPage> with SubscriptionPageMixin {

  final focusNode = FocusNode();
  final chatEditorController = TextEditingController();
  final ValueNotifier<bool> showSubmitButton = ValueNotifier(false);
  final scrollController = ScrollController();
  late ChatPreviewCubit chatPreviewCubit;
  late ChatConnectionsCubit chatConnectionsCubit;
  final ValueNotifier<ChatMessageModel?> messageToReply = ValueNotifier(null);
  final ValueNotifier<bool> messageHeaderMode = ValueNotifier(false);

  bool checkingChatConnection = false;
  late SubscriptionCubit subscriptionCubit;
  late StreamSubscription streamSubscriptionCubit;
  late StreamSubscription chatConnectionSubscriptionCubit;
  bool showPageOverlayLoader = false;


  @override
  void initState() {
    chatConnectionsCubit = context.read<ChatConnectionsCubit>();
    chatPreviewCubit = context.read<ChatPreviewCubit>();
    subscriptionCubit = context.read<SubscriptionCubit>();

    chatPreviewCubit.setSelectedChatConnection(widget.connection); // may still be null

    streamSubscriptionCubit = subscriptionCubit.stream.listen((event) async {
      if(event.status == SubscriptionStatus.setSubscriptionStatusCompleted) {
         if(event.subscribed && chatPreviewCubit.state.selectedConnection == null) {
            setState(() { showPageOverlayLoader = true; });
            await initiateChatConnection();
            setState(() { showPageOverlayLoader = false; });
         }
      }
    });
    
    chatConnectionSubscriptionCubit = chatConnectionsCubit.stream.listen((event) async {
      if(event.status == ChatConnectionStatus.matchedAtUpdated) {
         final con = event.data as ChatConnectionModel;
         if(con.id == chatPreviewCubit.state.selectedConnection?.id){
           chatPreviewCubit.setSelectedChatConnection(con);
         }
      }
    });

    ///! check if user has subscribed to premium
    //! meaning if chat connection is already created, no need to subscribe to continue this conversation
    if(chatPreviewCubit.state.selectedConnection != null) {
      initiateMessages(chatPreviewCubit.state.selectedConnection!, pageKey: 1);
    }else {
      initiateChatConnection();
    }

    super.initState();
  }

  @override
  void dispose() {

    chatPreviewCubit.clearPreviewState();
    focusNode.dispose();
    chatEditorController.dispose();
    scrollController.dispose();
    streamSubscriptionCubit.cancel();
    chatPreviewCubit.dispose();

    super.dispose();

  }

  Future<void> initiateChatConnection() async {
    checkingChatConnection = true;
    final response = await chatConnectionsCubit.createChatConnection(widget.opponent, subscriptionCubit.state.subscribed);
    setState(() { checkingChatConnection = false;});
    if(!mounted) {
      return;
    }
    if(response.$1 != null) {
      messageHeaderMode.value = true;
      context.showConfirmDialog(onConfirmTapped: () {
          initiateChatConnection();
      }, showCancelButton: false, title: 'Restore connection', subtitle: response.$1);
      return;
    }
    final conn = response.$2;
    if(conn == null) {
      // this user is the initiator of the chat
      // the connection was not created because user has not subscribed to premium so ask the user to subscribe
      messageHeaderMode.value = true;
      showSubscriptionPaywall(context, openAsModal: true);
      return;
    }

    focusNode.requestFocus();
    if(conn.readFirstImpressionNoteAt == null) {
      messageHeaderMode.value = true;
    }else {
      messageHeaderMode.value = false;
    }

    chatPreviewCubit.setSelectedChatConnection(conn);
    initiateMessages(conn, pageKey: 1);
  }

  void initiateMessages(ChatConnectionModel chatConnection, {int? pageKey = 1}) {

    chatPreviewCubit.setServerPushChannels(connectionId: chatConnection.id, opponentId: widget.opponent.id);
    chatPreviewCubit.fetchChatMessages(chatConnection: chatConnection, pageKey: pageKey,).then((value) {

      // listen to client side changes
      chatPreviewCubit.listenToClientChatBroadCastStreams();

      // listen to server side changes
      chatPreviewCubit.listenToServerChatUpdates(opponentId: widget.opponent.id);

      // mark messages as read when app initializes
      // and its also marked as read when new message is received and user is in the app
      chatPreviewCubit.markMessagesAsRead(connectionId: chatConnection.id, opponentId: widget.opponent.id);


    });
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

    chatPreviewCubit.sendMessage(connection: chatPreviewCubit.state.selectedConnection, message: message, sentTo: widget.opponent, parent: messageToReply.value);
    chatEditorController.clear();
    showSubmitButton.value = false;
    messageToReply.value = null;
    //
    // // Move the scroll position to the bottom
    if (scrollController.hasClients) {
      scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

  }

  void chatPreviewCubitListener(BuildContext ctx, ChatPreviewState chatPreviewState) async {
    // if (chatPreviewState.status == ChatPreviewStatus.sendMessageSuccessful) {
    //   // await messageSentAssetsAudioPlayer.open(Audio(kMessageSentMp3),);
    //   // messageSentAssetsAudioPlayer.play();
    // }
  }

  void showFirstImpressionExplanationModal(BuildContext context) {
    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.9,
          shouldCloseOnMinExtent: true,
          builder: (_ , controller) {
            return ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: FirstImpressionExplanationPage(controller: controller,)
            );
          }
      ),
    );
    context.showCustomBottomSheet(
        child: ch,
        isDismissible: true,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  void showMatchedConversationExplanationModal(BuildContext context) {
    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.9,
          shouldCloseOnMinExtent: true,
          builder: (_ , controller) {
            return ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: MatchedConversationExplanationPage(controller: controller,)
            );
          }
      ),
    );
    context.showCustomBottomSheet(
        child: ch,
        isDismissible: true,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  void openMessageOptionsModal(BuildContext context, ChatMessageModel message, {bool showDeleteAction = true}) {

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
                    color: theme.brightness == Brightness.light ? theme.colorScheme.surface : theme.colorScheme.outline
                ),
                child: SeparatedColumn(
                  mainAxisSize: MainAxisSize.min,
                  separatorBuilder: (BuildContext context, int index) {
                    return CustomBorderWidget(color: theme.brightness == Brightness.light ? theme.colorScheme.outline.withOpacity(0.1) : theme.colorScheme.background.withOpacity(0.2),);
                  },
                  children: [

                    ListTile(title: Text("Reply message", style: theme.textTheme.bodyMedium), onTap: () {
                      context.popScreen();
                      // chatPreviewCubit.deleteMessage(message);
                      messageToReply.value = message;
                      if(!focusNode.hasFocus){
                        focusNode.requestFocus();
                      }
                    }, trailing: Icon(FeatherIcons.messageSquare, size: 20, color: theme.colorScheme.onSurface,),),

                    if(showDeleteAction) ... {
                      ListTile(title: Text("Delete message", style: theme.textTheme.bodyMedium), onTap: () {
                        context.popScreen();
                        if(chatPreviewCubit.state.selectedConnection != null) {
                          chatPreviewCubit.deleteMessage(message: message, opponentId: widget.opponent.id);
                        }

                      }, trailing: Icon(FeatherIcons.delete, size: 20, color:theme.colorScheme.onSurface,),),
                    },

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

    return  CustomPageLoadingOverlay(
      loading: showPageOverlayLoader,
      showIcon: false,
      child: Scaffold(
          resizeToAvoidBottomInset: true, // assign true
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
            title:  Text("${widget.opponent.name} ", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
            centerTitle: true,
            backgroundColor: theme.colorScheme.background,
            bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: CustomBorderWidget(),),
          ),
          body: BlocBuilder<ChatPreviewCubit, ChatPreviewState>(
            buildWhen: (ctx, chatPreviewState) {
              return chatPreviewState.status == ChatPreviewStatus.refreshChatMessagesSuccessful
                  || chatPreviewState.status == ChatPreviewStatus.setSelectedChatConnectionCompleted;
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
                          reverse:true,
                          child: Padding(padding: EdgeInsets.only(bottom: 20),
                              child: EmptyChatWidget( message: "🔐 All messages are encrypted. No one outside of this chat, not even Sparkduet can read them.",)),) :
                        ListView.separated(
                          reverse: true,
                          shrinkWrap: true,
                          controller: scrollController,
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          itemBuilder: (ctx, index) {

                            /// Chat list content here .......
                            DateTime date = chatPreviewState.reOrderedChatMessages.keys.elementAt(index);
                            List<ChatMessageModel> messages = chatPreviewState.reOrderedChatMessages[date]!;
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
                                        key: ValueKey(message.clientId),
                                        iconOnLeftSwipe: Icons.arrow_forward,
                                        iconOnRightSwipe: Icons.arrow_back,
                                        onRightSwipe: (details) {
                                          messageToReply.value = message;
                                          messageHeaderMode.value = true;
                                          if(!focusNode.hasFocus){
                                            focusNode.requestFocus();
                                          }
                                        },
                                        swipeSensitivity: 20,
                                        child: MessageItemWidget(message: message, onLongPress: (message) {
                                          openMessageOptionsModal(context, message, showDeleteAction: message.sentById == currentUser?.id);
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

                  ValueListenableBuilder<ChatMessageModel?>(valueListenable: messageToReply, builder: (_, msg, __) {
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
                                      Text(msg.sentById == currentUser?.id ? "You" : (widget.opponent.name ?? ""), style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),),
                                      const SizedBox(height: 3,),
                                      Text(msg.text ?? "", style:  theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                 if(checkingChatConnection == false && chatPreviewState.selectedConnection == null) ...{
                   FadeInUp(
                       preferences: const AnimationPreferences(
                           duration: Duration(milliseconds: 100)
                       ),
                       child: GestureDetector(
                         onTap: (){
                           showSubscriptionPaywall(context);
                         },
                         behavior: HitTestBehavior.opaque,
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
                                       Text("Kindly subscribe to unlock this feature", style:  theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                     ],
                                   ),
                                 )),
                                 const SizedBox(width: 5,),
                               ],
                             ),
                           ),
                         ),
                       )
                   )
                 },

                  BlocBuilder<ChatPreviewCubit, ChatPreviewState>(
                    buildWhen: (_, state) {
                      return state.status == ChatPreviewStatus.updateFirstImpressionMessageReadCompleted
                          || state.status == ChatPreviewStatus.setSelectedChatConnectionCompleted;
                    },
                    builder: (context, state) {
                      if(state.selectedConnection != null && state.selectedConnection?.readFirstImpressionNoteAt == null)  {
                        return FadeInUp(
                            preferences: const AnimationPreferences(
                                duration: Duration(milliseconds: 100)
                            ),
                            child: GestureDetector(
                              onTap: (){
                                showFirstImpressionExplanationModal(context);
                              },
                              behavior: HitTestBehavior.opaque,
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
                                            Text("Make a very good first impression 😉. Messages like `Hi`, `Hello` are usually not attractive. TIP: Be expressive 🫶", style:  theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal),),
                                          ],
                                        ),
                                      )),
                                      const SizedBox(width: 5,),
                                    ],
                                  ),
                                ),
                              ),
                            )
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  if(chatPreviewState.linearMessagesList.isNotEmpty && chatPreviewState.linearMessagesList.length < 3  && chatPreviewState.selectedConnection?.createdBy == currentUser?.id && chatPreviewState.selectedConnection?.matchedAt == null) ...  {
                    FadeInUp(
                        preferences: const AnimationPreferences(
                            duration: Duration(milliseconds: 100)
                        ),
                        child: GestureDetector(
                          onTap: (){
                            showMatchedConversationExplanationModal(context);
                          },
                          behavior: HitTestBehavior.opaque,
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
                                        Text("📝 To ensure smooth conversations, you're limited to 2 messages until ${widget.opponent.name} replies you.", style:  theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal),),
                                      ],
                                    ),
                                  )),
                                  const SizedBox(width: 5,),
                                ],
                              ),
                            ),
                          ),
                        )
                    )
                  },

                  ValueListenableBuilder<bool>(valueListenable: messageHeaderMode, builder: (_, headerMode, __) {
                    return Container(
                      // color: theme.colorScheme.background,
                      // color: headerMode ? theme.brightness == Brightness.light ? const Color(0xffDDDEDF) : const Color(0xff202021) : theme.colorScheme.background,
                      color: theme.brightness == Brightness.light ? const Color(0xffDDDEDF) : const Color(0xff202021),
                      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20, bottom: 10.0),
                      child: CupertinoTextField(
                        focusNode: focusNode,
                        cursorColor: theme.colorScheme.onSurface ,
                        controller: chatEditorController,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: chatEditorTextChangeHandler,
                        style: TextStyle(color: theme.colorScheme.onBackground),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // border: Border.all(color: theme.colorScheme.outline)
                            color: theme.brightness == Brightness.light ? theme.colorScheme.surface : const Color(0xff3d3f41)
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
                        },child: Builder(
                          builder: (context) {
                            if(chatPreviewState.selectedConnection?.createdBy == currentUser?.id && chatPreviewState.selectedConnection?.matchedAt == null && chatPreviewState.linearMessagesList.length == 2){
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: chatPreviewState.selectedConnection != null ? SendChatMessageButtonWidget(onTap: submitMessageHandler,) : const SizedBox.shrink(),
                            );
                          },
                        ),),

                      ),
                    );
                  }),

                ],
              ));
            },
          )



      ),
    );

  }



}
