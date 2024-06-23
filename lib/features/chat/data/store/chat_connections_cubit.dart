import 'dart:async';
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
import 'package:sparkduet/features/chat/data/store/chat_connections_state.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';
import 'package:sparkduet/features/home/data/repositories/socket_connection_repository.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

class ChatConnectionsCubit extends Cubit<ChatConnectionState> {

  final ChatRepository chatRepository;
  final ChatBroadcastRepository chatBroadcastRepository;
  StreamSubscription<ChatBroadcastEvent>? chatClientBroadcastRepositoryStreamListener;
  AuthUserModel? authenticatedUser;
  final SocketConnectionRepository socketConnectionRepository;
  String? unreadMessagesUpdatedFromServerChannelId;
  String? lastMessageUpdatedFromServerChannelId;
  String? totalUnreadMessageUpdatedFromServerChannelId;

  ChatConnectionsCubit({required this.chatRepository, required this.chatBroadcastRepository, required this.socketConnectionRepository}): super(const ChatConnectionState()) {
    _listenToChatBroadCastStreams();
  }

  void setServerPushChannels() {
    unreadMessagesUpdatedFromServerChannelId = 'user.${authenticatedUser?.id}.unread-chat-messages-count-updated';
    lastMessageUpdatedFromServerChannelId = 'user.${authenticatedUser?.id}.last-chat-message-updated';
    totalUnreadMessageUpdatedFromServerChannelId = 'user.${authenticatedUser?.id}.total-unread-chat-messages-count-updated';
  }


  @override
  Future<void> close() {
    chatRepository.closeConnectionBox();
    chatClientBroadcastRepositoryStreamListener?.cancel();
    return super.close();
  }

  void clearChatConnectionsCache() async {
    chatRepository.clearChatConnections();
  }


  void _listenToChatBroadCastStreams() async {
    await chatClientBroadcastRepositoryStreamListener?.cancel();
    chatClientBroadcastRepositoryStreamListener = chatBroadcastRepository.stream.listen((chatBroadcastEvent) {


      /// update last message event
      if (chatBroadcastEvent.action == ChatBroadcastAction.updateLastMessage) {
        _updateLastMessage(chatBroadcastEvent.message);
      }

      if (chatBroadcastEvent.action == ChatBroadcastAction.updateUnreadMessagesCount) {
        final map = chatBroadcastEvent.data as Map<String, dynamic>;
        final connectionId = map['connectionId'] as int?;
        final count = map['count'] as int?;
        _updateChatConnectionUnreadMessagesCount(connectionId: connectionId, count: count);
      }


    });

  }

  void listenToServerChatUpdates() async {
    final serverSnapshots = socketConnectionRepository.realtimeInstance;

    if(unreadMessagesUpdatedFromServerChannelId != null) {
      final channel = serverSnapshots?.channels.get("public:$unreadMessagesUpdatedFromServerChannelId");
      channel?.subscribe().listen((event) {
        final data = event.data as Map<Object?, Object?>;
        final json = convertMap(data);
        debugPrint('Ably event received:unreadMessagesUpdatedFromServerChannelId: $json');
        final connectionId = json['chatConnectionId'] as int;
        final count = json['count'] as int;

        _updateChatConnectionUnreadMessagesCount(connectionId: connectionId, count: count);

      });
    }

    if(lastMessageUpdatedFromServerChannelId != null) {
      final channel = serverSnapshots?.channels.get("public:$lastMessageUpdatedFromServerChannelId");
      channel?.subscribe().listen((event) {
        final data = event.data as Map<Object?, Object?>;
        final msgJson = data['message'] as Map<Object?, Object?>;
        final json = convertMap(msgJson);
        final message = ChatMessageModel.fromJson(json);
        _updateLastMessage(message);
      });
    }

  }



  void _updateChatConnectionUnreadMessagesCount({required int? connectionId, required int? count}) {
    final connectionList = [...state.chatConnections];
    final connectionIndex = connectionList.indexWhere((element) => element.id == connectionId);
    if(connectionIndex < 0){
      return;
    }
    final connectionItem = connectionList[connectionIndex];
    if((count ?? 0) < (connectionItem.unreadMessages ?? 0) ) {
      // then we are about to reduce the unread messages so reduce the total unread as well
      emit(state.copyWith(totalUnreadMessages: state.totalUnreadMessages - (connectionItem.unreadMessages ?? 0).toInt()));
    }
    connectionList[connectionIndex] = connectionItem.copyWith(
        unreadMessages: count
    );
    emit(state.copyWith(status: ChatConnectionStatus.updateChatConnectionUnreadMessagesCountInProgress));
    emit(state.copyWith(status: ChatConnectionStatus.refreshChatConnectionsCompleted, chatConnections: connectionList));
  }

  void _updateLastMessage(ChatMessageModel? message) {
    if(message == null){return;}
    final connectionList = [...state.chatConnections];
    final connectionIndex = connectionList.indexWhere((element) => element.id == message.chatConnectionId);
    if(connectionIndex < 0){
      return;
    }
    connectionList[connectionIndex] = connectionList[connectionIndex].copyWith(
      lastMessage: message
    );
    emit(state.copyWith(status: ChatConnectionStatus.lastMessageUpdatedInProgress));
    emit(state.copyWith(status: ChatConnectionStatus.refreshChatConnectionsCompleted, chatConnections: connectionList));
    ///! Refresh chat connectios list

  }

  void setAuthenticatedUser(AuthUserModel? authUser) => authenticatedUser = authUser;

  void fetchSuggestedChatUsers() async {

    emit(state.copyWith(status: ChatConnectionStatus.fetchSuggestedChatUsersLoading));

    final either = await chatRepository.fetchSuggestedChatUsers();
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: ChatConnectionStatus.fetchSuggestedChatUsersError, message: l));
      return;
    }

    final users = either.asRight();
    emit(state.copyWith(status: ChatConnectionStatus.fetchSuggestedChatUsersSuccessful,
        suggestedChatUsers: users
    ));

  }

  Future<(String?, ChatConnectionModel?)> createChatConnection(UserModel opponent, bool createConnectionIfNotExist) async {

    emit(state.copyWith(status: ChatConnectionStatus.createChatConnectionLoading));
    const displayErrorMessage = "Oops! kindly restore your connection and try again";

    if(!(await isNetworkConnected ())) {

      emit(state.copyWith(status: ChatConnectionStatus.createChatConnectionError, message: displayErrorMessage));
      return (displayErrorMessage, null);
    }

    final either = await chatRepository.createChatConnection(authenticatedUser, opponent, createConnectionIfNotExist);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: ChatConnectionStatus.createChatConnectionError, message: kDebugMode ? l : displayErrorMessage));
      return (kDebugMode ? l: displayErrorMessage, null);
    }

    final chat = either.asRight();
    emit(state.copyWith(status: ChatConnectionStatus.createChatConnectionSuccessful));
    return (null, chat);

  }

  Future<void> fetchChatConnections({int pageKey = 1}) async {


    /// From Cache First
    // ! if its first fetch retrieve from cache first
    if(pageKey == 1) {

      // check if there are chats connections in memory
      if(state.chatConnections.isNotEmpty) {
        emit(state.copyWith(status: ChatConnectionStatus.fetchingChatConnectionsFromMemory));
        emit(state.copyWith(status: ChatConnectionStatus.refreshChatConnectionsCompleted));
      }

      emit(state.copyWith(status: ChatConnectionStatus.fetchChatConnectionLoading));
      final cachedList = await chatRepository.fetchChatConnectionsFromCache();
      emit(state.copyWith(status: ChatConnectionStatus.refreshChatConnectionsCompleted, chatConnections: cachedList));

    }


    emit(state.copyWith(status: ChatConnectionStatus.fetchChatConnectionLoading));
    // Then get from the server ----------
    final either = await chatRepository.fetchChatConnections(pageKey: pageKey);

    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: ChatConnectionStatus.fetchChatConnectionError, message: l));
      return;
    }

    final r = either.asRight();
    emit(state.copyWith(status: ChatConnectionStatus.refreshChatConnectionsCompleted, chatConnections: r));

  }

  Future<ChatConnectionModel?> getChatConnectionById({required int chatConnectionId}) async {
    return await chatRepository.getChatConnectionById(chatConnectionId: chatConnectionId);
  }

  void getTotalUnreadChatMessages() async {

    emit(state.copyWith(status: ChatConnectionStatus.getTotalUnreadChatMessagesLoading));

    final count = await chatRepository.getTotalUnreadChatMessages();

    emit(state.copyWith(status: ChatConnectionStatus.getTotalUnreadChatMessagesSuccessful,
        totalUnreadMessages: count ?? state.totalUnreadMessages
    ));

    // listen for server updates on total unread chats
    if(totalUnreadMessageUpdatedFromServerChannelId != null) {
      final serverSnapshots = socketConnectionRepository.realtimeInstance;
      final channel = serverSnapshots?.channels.get("public:$totalUnreadMessageUpdatedFromServerChannelId");
      channel?.subscribe().listen((event) {
        final data = event.data as Map<Object?, Object?>;
        final json = convertMap(data);
        final count = json['count'] as int?;
        emit(state.copyWith(status: ChatConnectionStatus.getTotalUnreadChatMessagesSuccessful,
            totalUnreadMessages: count ?? state.totalUnreadMessages
        ));
      });
    }

  }


}