import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_cubit.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/subscriptions/presentation/ui_mixin/subsription_page_mixin.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

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
  ChatConnectionModel? chatConnection;
  late SubscriptionCubit subscriptionCubit;


  @override
  void initState() {
    chatConnection = widget.connection; // may still be null
    focusNode.requestFocus();
    chatConnectionsCubit = context.read<ChatConnectionsCubit>();
    chatPreviewCubit = context.read<ChatPreviewCubit>();
    subscriptionCubit = context.read<SubscriptionCubit>();

    ///! check if user has subscribed to premium
    if(chatConnection != null) {
      initiateMessages(chatConnection!);
    }else {
      initialConnection();
    }

    super.initState();
  }

  void initialConnection() async {
    final response = await chatConnectionsCubit.createChatConnection(widget.opponent, subscriptionCubit.state.subscribed);
    if(!mounted) {
      return;
    }
    if(response.$1 != null) {
      context.showConfirmDialog(onConfirmTapped: () {
          initialConnection();
      }, showCancelButton: false, title: 'Restore connection', subtitle: response.$1);
    }
    final conn = response.$2;
    if(conn == null) {
      // this user is the initiator of the chat
      // the connection was not created because user has not subscribed to premium so ask the user to subscribe
      showSubscriptionPaywall(context, openAsModal: true);
      return;
    }

    setState(() {chatConnection = conn;});
  }

  void initiateMessages(ChatConnectionModel chat) {
    // chatPreviewCubit.fetchChatMessages(chatConnection: chat, pageKey: 1).then((value) {
    //   // listen to message after message have been fetched
    //   chatPreviewCubit.listenToMessages(chatConnection: chat);
    //   chatPreviewCubit.markChatConnectionAsRead(chat);
    //   chatPreviewCubit.markOtherParticipantMessageAsRead(chat); // mark messages as read when app initializes
    //   // and its also marked as read when new message is received and user is in the app
    // });

  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }



}
