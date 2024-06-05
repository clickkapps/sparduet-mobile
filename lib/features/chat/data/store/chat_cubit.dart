import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_broadcast_event.dart';
import 'package:sparkduet/features/chat/data/models/chat_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_user_model.dart';
import 'package:sparkduet/features/chat/data/models/message_model.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_broadcast_repository.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_repository.dart';
import 'package:sparkduet/features/chat/data/store/chat_state.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';

class ChatCubit extends Cubit<ChatState> {

  final ChatRepository chatRepository;
  final ChatBroadcastRepository chatBroadcastRepository;
  StreamSubscription<ChatBroadcastEvent>? chatBroadcastRepositoryStreamListener;
  StreamSubscription<QuerySnapshot<ChatModel>>? chatMessageListener;
  StreamSubscription<QuerySnapshot<ChatModel>>? unreadChatForNotificationDisplayListener;
  AuthUserModel? authenticatedUser;
  ChatCubit({required this.chatRepository, required this.chatBroadcastRepository}): super(const ChatState()) {
    _listenToChatBroadCastStreams();
  }

  void setAuthenticatedUser(AuthUserModel? authUser) => authenticatedUser = authUser;

  void _listenToChatBroadCastStreams() async {
    await chatBroadcastRepositoryStreamListener?.cancel();
    chatBroadcastRepositoryStreamListener = chatBroadcastRepository.stream.listen((chatBroadcastEvent) {

      /// add last message event
      if (chatBroadcastEvent.action == ChatBroadcastAction.addMessage) {
        _updateLastMessage(chatBroadcastEvent.message);
      }

      /// update last message event
      if (chatBroadcastEvent.action == ChatBroadcastAction.updateMessage) {
        _updateLastMessage(chatBroadcastEvent.message);
      }

      /// delete message event
      if (chatBroadcastEvent.action == ChatBroadcastAction.deleteMessage) {
        _deleteLastMessage(chatBroadcastEvent.message);
      }

    });
  }

  void _updateLastMessage(MessageModel? message) async {

    if(message == null){return;}
    // Add the message to the chat here

    final otherParticipant = message.sentBy?.id == authenticatedUser?.id ? message.sentTo : message.sentBy;

    final either = await chatRepository.createChatConnection(authenticatedUser!, otherParticipant!);
    if(either.isLeft()){
      return;
    }

    final chat = either.asRight();
    final chatId = chat.id;

    final mChatConnections = [...state.chatConnections];
    final chatConnectionIndex = mChatConnections.indexWhere((element) => element.id == chatId);


    if(chatConnectionIndex > -1) {
      final chatModelFound = mChatConnections[chatConnectionIndex];
      final mChatModel = chatModelFound.copyWith(
          lastMessage: message
      );
      mChatConnections[chatConnectionIndex] = mChatModel;

    }else {
      mChatConnections.insert(0, chat.copyWith(
        lastMessage: message
      ));
    }

    emit(state.copyWith(status: ChatStatus.refreshChatConnectionInProgress));
    emit(state.copyWith(status: ChatStatus.refreshChatConnectionCompleted,  chatConnections: mChatConnections));

  }

  void _deleteLastMessage(MessageModel? message) async {
    //! To do
    if(message == null){return;}
    // Add the message to the chat here

    final otherParticipant = message.sentBy?.id == authenticatedUser?.id ? message.sentTo : message.sentBy;

    final either = await chatRepository.createChatConnection(authenticatedUser!, otherParticipant!);
    if(either.isLeft()){
      return;
    }

    final chat = either.asRight();
    final chatId = chat.id;

    final mChatConnections = [...state.chatConnections];
    final chatConnectionIndex = mChatConnections.indexWhere((element) => element.id == chatId);
    if(chatConnectionIndex > -1){
      final chatModelFound = mChatConnections[chatConnectionIndex];
      if(chatModelFound.lastMessage?.id != message.id) {
        return;
      }
      // only delete if this message is the last message
      final mChatModel = chatModelFound.copyWith(lastMessage: null);
      mChatConnections[chatConnectionIndex] = mChatModel;
      emit(state.copyWith(status: ChatStatus.refreshChatConnectionInProgress));
      emit(state.copyWith(status: ChatStatus.refreshChatConnectionCompleted,  chatConnections: mChatConnections));
    }


  }


  void _addChatConnectionIfNotExist({MessageModel? message, ChatModel? chat}) {

    // Add the message to the chat here
    if(chat == null && message == null) {return;}

    final mChatConnections = [...state.chatConnections];
    final chatConnectionIndex = mChatConnections.indexWhere((element) => element.id == chat?.id);
    if(chatConnectionIndex < 0) {
      final mChatModel = chat ?? ChatModel(
          id: chat?.id,
          createdAt: DateTime.now(),
          participants: [
            message!.sentTo!,
            message.sentBy!
          ],
          participantIds: [
            message.sentTo!.id!,
            message.sentBy!.id!
          ]
      );
      mChatConnections.add(mChatModel);
      emit(state.copyWith(status: ChatStatus.refreshChatConnectionInProgress));
      emit(state.copyWith(status: ChatStatus.refreshChatConnectionCompleted,  chatConnections: mChatConnections));
    }


  }

  void _updateChatConnection({ChatModel? chat}) {

    // Add the message to the chat here
    if(chat == null) {return;}

    final chatId = chat.id;
    final mChatConnections = [...state.chatConnections];
    final chatConnectionIndex = mChatConnections.indexWhere((element) => element.id == chatId);
    if(chatConnectionIndex > -1) {
      mChatConnections[chatConnectionIndex] = chat;
      emit(state.copyWith(status: ChatStatus.refreshChatConnectionInProgress));
      emit(state.copyWith(status: ChatStatus.refreshChatConnectionCompleted,  chatConnections: mChatConnections));
    }

  }

  void _deleteChatConnection({ChatModel? chat}) {
    // Add the message to the chat here
    if(chat == null) {return;}

    final chatId = chat.id;
    final mChatConnections = [...state.chatConnections];
    final chatConnectionIndex = mChatConnections.indexWhere((element) => element.id == chatId);
    if(chatConnectionIndex > -1) {
      mChatConnections.removeAt(chatConnectionIndex);
      emit(state.copyWith(status: ChatStatus.refreshChatConnectionInProgress));
      emit(state.copyWith(status: ChatStatus.refreshChatConnectionCompleted,  chatConnections: mChatConnections));
    }

  }




  @override
  Future<void> close() {
    chatBroadcastRepositoryStreamListener?.cancel();
    return super.close();
  }


  Future<(String?, ChatModel?)> createChatConnection(ChatUserModel otherUser) async {

    emit(state.copyWith(status: ChatStatus.createChatConnectionLoading));

    final either = await chatRepository.createChatConnection(authenticatedUser!, otherUser);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: ChatStatus.createChatConnectionError, message: l));
      return (l, null);
    }

    final chat = either.asRight();
    emit(state.copyWith(status: ChatStatus.createChatConnectionSuccessful));
    return (null, chat);

  }

  void cancelChatConnectionsListener() {
    chatMessageListener?.cancel();
  }

  void fetchSuggestedChatUsers() async {

    emit(state.copyWith(status: ChatStatus.fetchSuggestedChatUsersLoading));

    final either = await chatRepository.fetchSuggestedChatUsers();
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: ChatStatus.fetchSuggestedChatUsersError, message: l));
      return;
    }

    final users = either.asRight();
    emit(state.copyWith(status: ChatStatus.fetchSuggestedChatUsersSuccessful,
      suggestedChatUsers: users
    ));

  }


  // Next listen to changes from the server
  void listenToChatConnections() async {

    emit(state.copyWith(status: ChatStatus.listenToChatConnectionInProgress));
    final either = await chatRepository.listenToChatConnections(authenticatedUser!);
    if(either?.isLeft() ?? true){
      final l = either!.asLeft();
      emit(state.copyWith(status: ChatStatus.listenToChatConnectionError, message: l));
      return;
    }

    emit(state.copyWith(status: ChatStatus.listenToChatConnectionCompleted));
    final r = either!.asRight();
    chatMessageListener = r.listen((event) {

      final changes = event.docChanges;
      for (var change in changes) {
        // Handle document changes here
        if(change.type == DocumentChangeType.added){
          // _addMessage(change.doc.data());
          _addChatConnectionIfNotExist(chat: change.doc.data());
        }else if (change.type == DocumentChangeType.modified) {
          _updateChatConnection(chat: change.doc.data());
        } else if (change.type == DocumentChangeType.removed) {
          _deleteChatConnection(chat: change.doc.data());
        }
      }
    });

  }


  Future<void> fetchChatConnections({int pageKey = 1}) async {


    /// From Cache First
    // ! if its first fetch retrieve from cache first
    if(pageKey == 1) {
      emit(state.copyWith(status: ChatStatus.getChatConnectionLoading));
      final either = await chatRepository.getChatChatConnections(authenticatedUser!, const GetOptions(source: Source.cache));
      if(either!.isRight()){
        final r = either.asRight();
        final List<ChatModel> mChatConnections = [];
        for (var snapShot in r) {
          // final chatConnectionId = snapShot.id;
          final chatConnectionData = snapShot.data();
          mChatConnections.add(chatConnectionData);
        }
        emit(state.copyWith(status: ChatStatus.refreshChatConnectionCompleted, chatConnections: mChatConnections));
      }
    }


    emit(state.copyWith(status: ChatStatus.getChatConnectionLoading));
    // Then get from the server ----------
    final either = await chatRepository.getChatChatConnections(authenticatedUser!);

    if(either?.isLeft() ?? true){
      final l = either!.asLeft();
      emit(state.copyWith(status: ChatStatus.getChatConnectionError, message: l));
      return;
    }

    final r = either!.asRight();

    final List<ChatModel> mChatConnections = [];
    for (var snapShot in r) {
      // final chatConnectionId = snapShot.id;
      final chatConnectionData = snapShot.data();
      mChatConnections.add(chatConnectionData);
    }

    emit(state.copyWith(status: ChatStatus.refreshChatConnectionCompleted, chatConnections: mChatConnections));

  }

  void cancelUnreadChatForNotificationDisplayListener() {
    unreadChatForNotificationDisplayListener?.cancel();
  }
  void listenToUnreadChatForNotificationDisplay() async {
    final either = await chatRepository.listenToChatConnections(authenticatedUser!);
    if(either?.isLeft() ?? true){
      final l = either!.asLeft();
      emit(state.copyWith(status: ChatStatus.listenToChatConnectionError, message: l));
      return;
    }
    final r = either!.asRight();
    unreadChatForNotificationDisplayListener = r.listen((event) {

      final docs = event.docs;

      // final unreadMessages = docs.where((document) => (document.data().participants?.where((participant) => participant.id == currentUser?.id).firstOrNull?.unreadMessages ?? 0) > 0).
      final messages = docs.map((document) => document.data().participants?.where((participant) => participant.id == authenticatedUser?.id).firstOrNull?.unreadMessages ?? 0);
      if(messages.isNotEmpty) {
        final unreadMessages = messages.reduce((previous, current) => previous + current);
        emit(state.copyWith(unreadMessages: unreadMessages));
      }


    });
  }

  Future<ChatModel?> getChatConnectionById({required String chatConnectionId}) async {
    return await chatRepository.getChatConnectionById(chatConnectionId: chatConnectionId);
  }

}

