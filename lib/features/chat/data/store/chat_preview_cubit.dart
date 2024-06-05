import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_broadcast_event.dart';
import 'package:sparkduet/features/chat/data/models/chat_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_user_model.dart';
import 'package:sparkduet/features/chat/data/models/message_model.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_broadcast_repository.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_repository.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_state.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';

class ChatPreviewCubit extends Cubit<ChatPreviewState> {

  final ChatRepository chatRepository;
  final ChatBroadcastRepository chatBroadcastRepository;
  StreamSubscription<ChatBroadcastEvent>? chatBroadcastRepositoryStreamListener;
  StreamSubscription<QuerySnapshot<MessageModel>>? chatMessageListener;
  AuthUserModel? authenticatedUser;

  ChatPreviewCubit({required this.chatRepository, required this.chatBroadcastRepository}): super(const ChatPreviewState()) {
    _listenToChatBroadCastStreams();
  }

  void setAuthenticatedUser(AuthUserModel? authUser) => authenticatedUser = authUser;

  void _listenToChatBroadCastStreams() async {
    await chatBroadcastRepositoryStreamListener?.cancel();
    chatBroadcastRepositoryStreamListener = chatBroadcastRepository.stream.listen((chatBroadcastEvent) {

          /// add message event
          if (chatBroadcastEvent.action == ChatBroadcastAction.addMessage) {
             _addMessage(chatBroadcastEvent.message);
          }

          /// update message event
          if (chatBroadcastEvent.action == ChatBroadcastAction.updateMessage) {
            _updateMessage(chatBroadcastEvent.message);
          }

          /// delete message event
          if (chatBroadcastEvent.action == ChatBroadcastAction.deleteMessage) {
            _deleteMessage(chatBroadcastEvent.message);
          }


        });


  }

  void cancelMessagesListener() {
    chatMessageListener?.cancel();
  }

  // Next listen to changes from the server
  void listenToMessages({required ChatModel chatConnection}) async {

    emit(state.copyWith(status: ChatPreviewStatus.listenToMessagesInProgress));
    final either = await chatRepository.listenToMessages(chatConnection: chatConnection);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: ChatPreviewStatus.listenToMessagesError, message: l));
      return;
    }

    emit(state.copyWith(status: ChatPreviewStatus.listenToMessagesCompleted));
    final r = either.asRight();
    chatMessageListener = r.listen((event) {

      final changes = event.docChanges;
      for (var change in changes) {
        final data = change.doc.data();
        if(data == null){ return; }
        // Handle document changes here
        if(change.type == DocumentChangeType.added){
          // ! this listener only add chats that are from the other participant

          final otherParticipant = chatConnection.participants!.where((element) => element.id != authenticatedUser?.id).first;
          if(data.sentBy?.id != otherParticipant.id) {
            return;
          }
          final message = change.doc.data();
          // add message if only it does not exist
          if(state.linearMessagesList.indexWhere((element) => element.id == message?.id) < 0) {
            // if((data.createdAt?.year ?? 1970) < 2023) {
            //   return;
            // }
            // debugPrint("customLog:chat: DocumentChangeType.added: id=${change.doc.id} && data => ${change.doc.data()}");
            _addMessage(message);
            // mark received messages as read once you're in the app ....
            markOtherParticipantMessageAsRead(chatConnection);
            markChatConnectionAsRead(chatConnection);
          }

        }else if (change.type == DocumentChangeType.modified) {
            debugPrint("customLog:chat: DocumentChangeType.modified: id=${change.doc.id} && data => ${change.doc.data()}");
            final message = change.doc.data();
            _updateMessage(message);
        } else if (change.type == DocumentChangeType.removed) {
          // this listener only removes chat that are from the other participant
          final otherParticipant = chatConnection.participants!.where((element) => element.id != authenticatedUser?.id).first;
          if(data.sentBy?.id != otherParticipant.id) {
            return;
          }
          _deleteMessage(change.doc.data());
        }
      }

    });

  }

  //! This methods adds message to the lists
  //! Private methods accessed only by this cubit
  void _addMessage(MessageModel? message) {
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
  void _updateMessage(MessageModel? message) {
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

  //! For public access
  void updateMessage(MessageModel? message) {
    if(message == null) {
      return;
    }
    // update locally
    chatBroadcastRepository.updateMessage(message: message);
    // update on the server
  }

  //! This methods removes an existing message from the lists
  //! Private methods accessed only by this cubit
  void _deleteMessage(MessageModel? message) {
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
  void deleteMessage({required ChatModel chatConnection, MessageModel? message}) {
      if(message == null) {
        return;
      }
      final deletedMessage = message.copyWith(
        deleted: true
      );
      // remove locally
      chatBroadcastRepository.removeMessage(message: deletedMessage);
      // remove from the server
      chatRepository.deleteMessage(chatConnection: chatConnection, message: deletedMessage);
  }

  @override
  Future<void> close() {
    chatBroadcastRepositoryStreamListener?.cancel();
    return super.close();
  }

  Future<void> fetchChatMessages({required ChatModel chatConnection, int? pageKey}) async {

    /// From Cache First
    //! if its first fetch retrieve from cache first
    if(pageKey == 1){
      emit(state.copyWith(status: ChatPreviewStatus.fetchChatMessagesInProgress));
      final either = await chatRepository.fetchMessages(chatConnection: chatConnection, options: const GetOptions(source: Source.cache));
      if(either!.isRight()) {
        final messagesList = either.asRight();
        final List<MessageModel> mMessages = [];
        for (var snapShot in messagesList) {
          final msg = snapShot.data();
          mMessages.add(msg);
        }
        emit(state.copyWith(status: ChatPreviewStatus.fetchChatMessagesSuccessful, linearMessagesList: mMessages));
        _refreshChatMessages();
      }
    }

    emit(state.copyWith(status: ChatPreviewStatus.fetchChatMessagesInProgress));
    final either = await chatRepository.fetchMessages(chatConnection: chatConnection);
    if(either?.isLeft() ?? true){
      final l = either!.asLeft();
      emit(state.copyWith(status: ChatPreviewStatus.fetchChatMessagesError, message: l));
      return;
    }

    final messagesList = either!.asRight();
    final List<MessageModel> mMessages = [];
    for (var snapShot in messagesList) {
      final msg = snapShot.data();
      mMessages.add(msg);
    }

    emit(state.copyWith(status: ChatPreviewStatus.fetchChatMessagesSuccessful, linearMessagesList: mMessages));
    _refreshChatMessages();

    // messagesStream.listen((event) {
    //
    //   emit(state.copyWith(status: ChatStatus.getChatConnectionRefreshing));
    //
    //   final List<MessageModel> mMessages = [];
    //   for (var snapShot in event.docs) {
    //     // final chatConnectionId = snapShot.id;
    //     final msg = snapShot.data();
    //     mMessages.add(msg);
    //   }
    //
    //   emit(state.copyWith(status: ChatStatus.getChatConnectionSuccessful,
    //     // chatConnections: mChatConnections
    //   ));
    //
    // });


    // return Right(r);

  }

  Future<String?> sendMessage({required String message, required ChatUserModel otherParticipant, MessageModel? parent, ChatModel? chatConnection}) async {

    final thisParticipant = ChatUserModel.fromJson(authenticatedUser!.toJson());

    String? chatId = chatConnection?.id;
    if(chatConnection == null){
      final either = await chatRepository.createChatConnection(authenticatedUser!, otherParticipant);
      if(either.isLeft()){
        final l = either.asLeft();
        return l;
      }
      chatId = either.asRight().id;
    }

    final doc = messagesRef(chatId: chatId!).doc();

    final thisMessage = MessageModel(
        id: doc.id,
        message: message,
        createdAt: DateTime.now(),
        sentBy: thisParticipant,
        sentTo: otherParticipant,
        parent: parent,
    );

    ///! Optimistic add message to messages --
    chatBroadcastRepository.addMessage(message: thisMessage);

    final either = await chatRepository.sendMessage(doc: doc, thisMessage: thisMessage);

    emit(state.copyWith(status: ChatPreviewStatus.sendMessageLoading));
    if(either?.isLeft() ?? true){
      final l = either!.asLeft();
      //! Update that chat wasn't sent
      chatBroadcastRepository.updateMessage(message: thisMessage.copyWith(delivered: false));
      emit(state.copyWith(status: ChatPreviewStatus.sendMessageError, message: l));
      return l;
    }

    // final r = either!.asRight();
    chatBroadcastRepository.updateMessage(message: thisMessage.copyWith(delivered: true));
    emit(state.copyWith(status: ChatPreviewStatus.sendMessageSuccessful));
    return null;

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


  Map<DateTime, List<MessageModel>> groupMessagesByDateAndTimeWindow(List<MessageModel> messages) {

    // Sort messages by createdAt in descending order
    messages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!)); // Sort in descending order

    // Group messages by createdAt
    Map<DateTime, List<MessageModel>> groupedMessages = groupBy(messages, (MessageModel message) =>
        DateTime(message.createdAt!.year, message.createdAt!.month, message.createdAt!.day));

    // Sort keys (dates) of the grouped map in ascending order (latest date at the bottom)
    List<DateTime> sortedKeys = groupedMessages.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Sort dates in ascending order

    // Create a new map with sorted keys and corresponding values
    Map<DateTime, List<MessageModel>> sortedGroupedMessages = LinkedHashMap.fromIterable(
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


  void markChatConnectionAsRead(ChatModel chatConnection) async {

      emit(state.copyWith(status: ChatPreviewStatus.markChatConnectionAsReadInProgress));
      final either = await chatRepository.markChatConnectionAsRead(authenticatedUser!, chatConnection);

      if(either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(status: ChatPreviewStatus.markChatConnectionAsReadFailed, message: l));
        return;
      }

      emit(state.copyWith(status: ChatPreviewStatus.markChatConnectionAsReadSuccessful));

  }

  void markOtherParticipantMessageAsRead(ChatModel chatConnection) async {

      emit(state.copyWith(status: ChatPreviewStatus.markOtherParticipantMessageAsReadInProgress));
      final either = await chatRepository.markOtherParticipantMessageAsRead(chatConnection);

      if(either.isLeft()) {
        final l = either.asLeft();
        emit(state.copyWith(status: ChatPreviewStatus.markOtherParticipantMessageAsReadFailed, message: l));
        return;
      }

      emit(state.copyWith(status: ChatPreviewStatus.markOtherParticipantMessageAsReadSuccessful));

  }

}