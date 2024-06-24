import 'dart:async';
import 'dart:collection';
import 'package:ably_flutter/ably_flutter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_broadcast_event.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_broadcast_repository.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_repository.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_state.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';
import 'package:sparkduet/features/home/data/events/home_broadcast_event.dart';
import 'package:sparkduet/features/home/data/repositories/home_broadcast_repository.dart';
import 'package:sparkduet/features/home/data/repositories/socket_connection_repository.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

class ChatPreviewCubit extends Cubit<ChatPreviewState> {

  final ChatRepository chatRepository;
  final ChatBroadcastRepository chatBroadcastRepository;
  StreamSubscription<ChatBroadcastEvent>? chatClientBroadcastRepositoryStreamListener;
  StreamSubscription? messageCreatedSubscription;
  StreamSubscription? unreadMessagesUpdatedSubscription;
  StreamSubscription? deletedMessagesSubscription;
  final SocketConnectionRepository socketConnectionRepository;

  AuthUserModel? authenticatedUser;
  String? messageCreatedFromServerChannelId;
  String? unreadMessagesUpdatedFromServerChannelId;
  String? deletedMessagesFromServerChannelId;
  ChatPreviewCubit({required this.chatRepository, required this.chatBroadcastRepository,  required this.socketConnectionRepository}): super(const ChatPreviewState());

  void setAuthenticatedUser(AuthUserModel? authUser) => authenticatedUser = authUser;
  void setServerPushChannels({required int? connectionId, required int? opponentId}) {
    messageCreatedFromServerChannelId = "connections.$connectionId.messages.${authenticatedUser?.id}.created";
    unreadMessagesUpdatedFromServerChannelId = 'connections.$connectionId.user.${authenticatedUser?.id}.messages.read';
    deletedMessagesFromServerChannelId = 'connections.$connectionId.messages.${authenticatedUser?.id}.deleted';
  }

  void listenToClientChatBroadCastStreams() async {
    await chatClientBroadcastRepositoryStreamListener?.cancel();
    chatClientBroadcastRepositoryStreamListener = chatBroadcastRepository.stream.listen((chatBroadcastEvent) {
    });


  }

  void listenToServerChatUpdates({required int? opponentId}) async {
    if(messageCreatedFromServerChannelId != null) {
      final channel = socketConnectionRepository.realtimeInstance?.channels.get("public:$messageCreatedFromServerChannelId");
      messageCreatedSubscription = channel?.subscribe(name: "message.created").listen((event) {
        debugPrint('Ably event received:');
        final data = event.data as Map<Object?, Object?>;
        final messageObj = data['message'] as Map<Object?, Object?>;
        final messageJson = convertMap(messageObj);
        final chatMessage = ChatMessageModel.fromJson(messageJson);
        _addMessage(chatMessage);
        // chatBroadcastRepository.updateLastMessage(message: chatMessage, connection: state.selectedConnection);
        // We mark message as read if we're currently in the chat
        markMessagesAsRead(connectionId: state.selectedConnection?.id, opponentId: opponentId);
      });
    }

    // now, update all the unread chats as read with the channel below
    // 'connections.'.$this->chatConnectionId.'.user.'.$this->opponentId.'.messages.read'
    // server code already implemented and pushed
    // , the data returned is $messageIds, $seenAt
    if(unreadMessagesUpdatedFromServerChannelId != null) {
      final channel = socketConnectionRepository.realtimeInstance?.channels.get("public:$unreadMessagesUpdatedFromServerChannelId");
      unreadMessagesUpdatedSubscription = channel?.subscribe().listen((event) {
        debugPrint('Ably event received:');
        final data = event.data as Map<Object?, Object?>;
        final messagesIdsObjs = data["messageIds"] as List<Object?>;
        final seenAtObjs = data["seenAt"];
        final messagesIds = convertToIntList(messagesIdsObjs);
        final seenAt = convertObjectToString(seenAtObjs);

        if(messagesIds.isNotEmpty && seenAt != null){
          final msgList = state.linearMessagesList.where((msg) => messagesIds.contains(msg.id)).toList();
          for (final msg in msgList) {
            _updateMessage(msg.copyWith(seenAt: DateTime.parse(seenAt)));
          }
        }

      });
    }

    if(deletedMessagesFromServerChannelId != null) {
      final channel = socketConnectionRepository.realtimeInstance?.channels.get("public:$deletedMessagesFromServerChannelId");
      deletedMessagesSubscription = channel?.subscribe().listen((event) {
        final data = event.data as Map<Object?, Object?>;
        final messageObj = data['message'] as Map<Object?, Object?>;
        final messageJson = convertMap(messageObj);
        final chatMessage = ChatMessageModel.fromJson(messageJson);
        _deleteMessage(chatMessage);
      });
    }



  }


  void setSelectedChatConnection(ChatConnectionModel? connection) {
    emit(state.copyWith(status: ChatPreviewStatus.setSelectedChatConnectionInProgress));
    emit(state.copyWith(status: ChatPreviewStatus.setSelectedChatConnectionCompleted, selectedConnection: connection));
  }

  //! This methods adds message to the lists
  //! Private methods accessed only by this cubit
  void _addMessage(ChatMessageModel? message) {
    if(message == null){return;}
    final messagesList = [...state.linearMessagesList];
    messagesList.add(message);
    emit(state.copyWith(status: ChatPreviewStatus.addNewMessageInProgress));
    emit(state.copyWith(status: ChatPreviewStatus.addNewMessageCompleted, linearMessagesList: messagesList));
    ///! Refresh chat messages list
    _refreshChatMessages();
  }

  //! This methods updates an existing message in the lists
  //! Private methods accessed only by this cubit
  void _updateMessage(ChatMessageModel? message) {
    if(message == null){return;}
    final messagesList = [...state.linearMessagesList];
    final messageIndex = messagesList.indexWhere((element) => element.id == message.id);
    if(messageIndex < 0){
      return;
    }
    messagesList[messageIndex] = message;
    emit(state.copyWith(status: ChatPreviewStatus.updateMessageInProgress));
    emit(state.copyWith(status: ChatPreviewStatus.updateMessageCompleted, linearMessagesList: messagesList));
    ///! Refresh chat messages list
    _refreshChatMessages();
  }

  //! This methods updates an existing message in the lists
  //! Private methods accessed only by this cubit
  void _updateClientMessage(ChatMessageModel? message) {
    if(message == null){return;}
    final messagesList = [...state.linearMessagesList];
    final messageIndex = messagesList.indexWhere((element) => element.clientId == message.clientId);
    if(messageIndex < 0){
      return;
    }
    messagesList[messageIndex] = message;
    emit(state.copyWith(status: ChatPreviewStatus.updateMessageInProgress));
    emit(state.copyWith(status: ChatPreviewStatus.updateMessageCompleted, linearMessagesList: messagesList));
    ///! Refresh chat messages list
    _refreshChatMessages();
  }

  //! For public access
  void updateMessage(ChatMessageModel? message) {
    if(message == null) {
      return;
    }
    // update locally
    _updateMessage(message);
    // update on the server
  }

  //! This methods removes an existing message from the lists
  //! Private methods accessed only by this cubit
  void _deleteMessage(ChatMessageModel? message) {
    if(message == null){return;}
    final messagesList = [...state.linearMessagesList];
    final messageIndex = messagesList.indexWhere((element) => element.id == message.id);
    if(messageIndex < 0){
      return;
    }
    messagesList.removeAt(messageIndex);
    emit(state.copyWith(status: ChatPreviewStatus.deleteMessageInProgress));
    emit(state.copyWith(status: ChatPreviewStatus.deleteMessageCompleted, linearMessagesList: messagesList));
    ///! Refresh chat messages list
    _refreshChatMessages();
  }

  //! For public access
  void deleteMessage({ChatMessageModel? message, int? opponentId}) {
    if(message == null) {
      return;
    }
    // you cannot delete a message which is not yours
    if(message.sentById != authenticatedUser?.id) {
      return;
    }
    final deletedMessage = message.copyWith(
        deletedAt: DateTime.now()
    );
    // remove locally
    _deleteMessage(deletedMessage);
    chatBroadcastRepository.updateLastMessage(message: deletedMessage);
    // remove from the server
    chatRepository.deleteMessage(messageId: deletedMessage.id, opponentId: opponentId);
  }

  @override
  Future<void> close() {
    chatRepository.closeMessagesBox();
    dispose();
    return super.close();
  }

  void dispose() async {
    // chatRepository.clearChatMessages();
    chatClientBroadcastRepositoryStreamListener?.cancel();

    // if(ch != null) {
    //   final pusher = await socketConnectionRepository.getWebSocketConnection();
    //   await pusher?.unsubscribe(channelName:  ch);
    // }
    //

    messageCreatedSubscription?.cancel();
    unreadMessagesUpdatedSubscription?.cancel();
    deletedMessagesSubscription?.cancel();

  }

  void clearPreviewState() {
    emit(const ChatPreviewState());
  }

  // void cancelMessagesListener() {
  //   chatMessageListener?.cancel();
  // }

  void markMessagesAsRead({required int? connectionId, required int? opponentId}) async {

    // mark client side connection as read

    emit(state.copyWith(status: ChatPreviewStatus.markMessagesAsReadInProgress));

    final either = await chatRepository.markMessagesRead(connectionId: connectionId, opponentId: opponentId);

    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: ChatPreviewStatus.markMessagesAsReadFailed, message: l));
      return;
    }

    chatBroadcastRepository.updateUnreadMessagesCount({
      "connectionId": connectionId,
      "count": 0
    });
    emit(state.copyWith(status: ChatPreviewStatus.markMessagesAsReadSuccessful));


  }




  Future<String?> sendMessage({required ChatConnectionModel? connection, required String message, required UserModel sentTo, ChatMessageModel? parent}) async {

    // once the user sends first message, it means first impression read.
    if(connection?.readFirstImpressionNoteAt == null) {
      connection = connection?.copyWith(
        readFirstImpressionNoteAt: DateTime.now()
      );
      setSelectedChatConnection(connection);
      emit(state.copyWith(status: ChatPreviewStatus.updateFirstImpressionMessageReadCompleted));
    }

    final clientId = const Uuid().v4();

    final clientMessage = ChatMessageModel(
      clientId: clientId,
      text: message,
      createdAt: DateTime.now(),
      sentById: authenticatedUser?.id,
      sentToId: sentTo.id,
      parent: parent,
      deliveredAt: DateTime.now()
    );

    ///! Optimistic add message to messages --
    _addMessage(clientMessage);

    emit(state.copyWith(status: ChatPreviewStatus.sendMessageLoading));
    final either = await chatRepository.sendMessage(chatConnectionId: connection?.id, message: clientMessage);

    if(either?.isLeft() ?? true){
      final l = either!.asLeft();
      //! Update that chat wasn't sent
      _updateClientMessage(clientMessage.copyWith(deliveredAt: null));
      emit(state.copyWith(status: ChatPreviewStatus.sendMessageFailed, message: l));
      return l;
    }

    final r = either!.asRight();
    _updateClientMessage(r);
    chatBroadcastRepository.updateLastMessage(message: r);
    emit(state.copyWith(status: ChatPreviewStatus.sendMessageSuccessful));
    return null;

  }

  Future<void> fetchChatMessages({required ChatConnectionModel chatConnection, int? pageKey}) async {

    /// From Cache First
    // ! if its first fetch retrieve from cache first
    if(pageKey == 1){
      emit(state.copyWith(status: ChatPreviewStatus.fetchChatMessagesInProgress));
      final cachedMessages = await chatRepository.fetchChatMessagesFromCache(connectionId: chatConnection.id);
      emit(state.copyWith(status: ChatPreviewStatus.fetchChatMessagesSuccessful, linearMessagesList: cachedMessages));
      _refreshChatMessages();
    }

    emit(state.copyWith(status: ChatPreviewStatus.fetchChatMessagesInProgress));
    final either = await chatRepository.fetchMessages(chatConnectionId: chatConnection.id, pageKey: pageKey);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: ChatPreviewStatus.fetchChatMessagesError, message: l));
      return;
    }

    final messagesList = either.asRight();

    emit(state.copyWith(status: ChatPreviewStatus.fetchChatMessagesSuccessful, linearMessagesList: messagesList));
    _refreshChatMessages();

  }

  /// This method modifies the chatList and updates the UI
  /// Its NOT called directly from the UI
  void _refreshChatMessages() {

    emit(state.copyWith(status: ChatPreviewStatus.refreshChatMessagesInProgress,));
    // group the chats by date, time and userId
    final groupedModelsByDate = groupMessagesByDateAndTimeWindow(state.linearMessagesList);
    groupedModelsByDate.forEach((key, value) {
      debugPrint("customLog:chat: groupedModelsByDate date: $key : values: $value");
    });
    emit(state.copyWith(
      status: ChatPreviewStatus.refreshChatMessagesSuccessful,
      reOrderedChatMessages: groupedModelsByDate,
      // chatConnections: connectedRecipients
    ));

    // update messages in local cache
    // if(savInCache){
    // updateChatMessagesCache(connectionId: chatConnections.id!, chatMessages: chatMessages);
    // }

  }

  Map<DateTime, List<ChatMessageModel>> groupMessagesByDateAndTimeWindow(List<ChatMessageModel> messages) {

    // Sort messages by createdAt in descending order
    messages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!)); // Sort in descending order

    // Group messages by createdAt
    Map<DateTime, List<ChatMessageModel>> groupedMessages = groupBy(messages, (ChatMessageModel message) =>
        DateTime(message.createdAt!.year, message.createdAt!.month, message.createdAt!.day));

    // Sort keys (dates) of the grouped map in ascending order (latest date at the bottom)
    List<DateTime> sortedKeys = groupedMessages.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Sort dates in ascending order

    // Create a new map with sorted keys and corresponding values
    Map<DateTime, List<ChatMessageModel>> sortedGroupedMessages = LinkedHashMap.fromIterable(
      sortedKeys,
      key: (key) => key,
      value: (key) => groupedMessages[key]!,
    );

    // Sort messages under each date by createdAt in descending order
    sortedGroupedMessages.forEach((createdAt, messages) {
      messages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!)); // Sort in descending order
    });

    return sortedGroupedMessages;

  }


}