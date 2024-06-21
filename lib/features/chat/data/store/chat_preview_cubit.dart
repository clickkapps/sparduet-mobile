import 'dart:async';
import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_broadcast_event.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_broadcast_repository.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_repository.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_state.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

class ChatPreviewCubit extends Cubit<ChatPreviewState> {

  final ChatRepository chatRepository;
  final ChatBroadcastRepository chatBroadcastRepository;
  StreamSubscription<ChatBroadcastEvent>? chatClientBroadcastRepositoryStreamListener;

  AuthUserModel? authenticatedUser;
  ChatPreviewCubit({required this.chatRepository, required this.chatBroadcastRepository}): super(const ChatPreviewState()) {
      _listenToChatBroadCastStreams();
  }

  void setAuthenticatedUser(AuthUserModel? authUser) => authenticatedUser = authUser;

  void _listenToChatBroadCastStreams() async {
    await chatClientBroadcastRepositoryStreamListener?.cancel();
    chatClientBroadcastRepositoryStreamListener = chatBroadcastRepository.stream.listen((chatBroadcastEvent) {

      /// add message event
      if (chatBroadcastEvent.action == ChatBroadcastAction.addMessage) {
        _addMessage(chatBroadcastEvent.message);
      }

      /// update message event
      if (chatBroadcastEvent.action == ChatBroadcastAction.updateMessage) {
        _updateMessage(chatBroadcastEvent.message);
      }

      /// update client message event
      if (chatBroadcastEvent.action == ChatBroadcastAction.updateMessage) {
        _updateClientMessage(chatBroadcastEvent.message);
      }

      /// delete message event
      if (chatBroadcastEvent.action == ChatBroadcastAction.deleteMessage) {
        _deleteMessage(chatBroadcastEvent.message);
      }


    });


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
    chatBroadcastRepository.updateMessage(message: message);
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
  void deleteMessage({required ChatConnectionModel chatConnection, ChatMessageModel? message}) {
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
    chatBroadcastRepository.removeMessage(message: deletedMessage);
    // remove from the server
    chatRepository.deleteMessage(messageId: deletedMessage.id, opponentId: deletedMessage.sentToId);
  }

  @override
  Future<void> close() {
    chatClientBroadcastRepositoryStreamListener?.cancel();
    chatRepository.closeMessagesBox();
    return super.close();
  }

  void clearPreviewState() {
    emit(const ChatPreviewState());
  }

  // void cancelMessagesListener() {
  //   chatMessageListener?.cancel();
  // }


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
    chatBroadcastRepository.addMessage(message: clientMessage);

    emit(state.copyWith(status: ChatPreviewStatus.sendMessageLoading));
    final either = await chatRepository.sendMessage(chatConnectionId: connection?.id, message: clientMessage);

    if(either?.isLeft() ?? true){
      final l = either!.asLeft();
      //! Update that chat wasn't sent
      chatBroadcastRepository.updateClientMessage(message: clientMessage.copyWith(deliveredAt: null));
      emit(state.copyWith(status: ChatPreviewStatus.sendMessageFailed, message: l));
      return l;
    }

    final r = either!.asRight();
    chatBroadcastRepository.updateClientMessage(message: r);
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