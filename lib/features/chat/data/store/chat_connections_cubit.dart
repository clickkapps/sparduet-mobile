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
  String? deletedConnectionFromServerChannelId;
  String? matchedConnectionFromServerChannelId;

  ChatConnectionsCubit({required this.chatRepository, required this.chatBroadcastRepository, required this.socketConnectionRepository}): super(const ChatConnectionState()) {
    _listenToChatBroadCastStreams();
  }

  void setServerPushChannels() {
    unreadMessagesUpdatedFromServerChannelId = 'user.${authenticatedUser?.id}.unread-chat-messages-count-updated';
    lastMessageUpdatedFromServerChannelId = 'user.${authenticatedUser?.id}.last-chat-message-updated';
    totalUnreadMessageUpdatedFromServerChannelId = 'user.${authenticatedUser?.id}.total-unread-chat-messages-count-updated';
    deletedConnectionFromServerChannelId = 'connection.user.${authenticatedUser?.id}.deleted';
    matchedConnectionFromServerChannelId = 'connection.user.${authenticatedUser?.id}.matched';
  }

  void clearState() {
    emit(const ChatConnectionState());
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
    chatClientBroadcastRepositoryStreamListener = chatBroadcastRepository.stream.listen((chatBroadcastEvent) async {


      /// update last message event
      if (chatBroadcastEvent.action == ChatBroadcastAction.updateLastMessage) {
         await _createConnectionIfNotExist(connectionId: chatBroadcastEvent.message?.chatConnectionId);
        _updateLastMessage(chatBroadcastEvent.message);
      }

      if (chatBroadcastEvent.action == ChatBroadcastAction.messageDeleted) {
        final message = chatBroadcastEvent.message;
        final chatConnection = state.chatConnections.where((element) => element.id == message?.chatConnectionId).firstOrNull;
        if(chatConnection == null) {
          return;
        }
        if(chatConnection.lastMessage?.id == message?.id) {
          _updateLastMessage(message);
        }

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
        final connectionId = json['chatConnectionId'] as int;
        final count = json['count'] as int;

        _updateChatConnectionUnreadMessagesCount(connectionId: connectionId, count: count);

      });
    }

    if(lastMessageUpdatedFromServerChannelId != null) {
      final channel = serverSnapshots?.channels.get("public:$lastMessageUpdatedFromServerChannelId");
      channel?.subscribe().listen((event) async {
        final data = event.data as Map<Object?, Object?>;
        final msgJson = data['message'] as Map<Object?, Object?>;
        final json = convertMap(msgJson);
        final message = ChatMessageModel.fromJson(json);
        await _createConnectionIfNotExist(connectionId: message.chatConnectionId);
        chatRepository.addMessageToCache(message);
        _updateLastMessage(message);
      });
    }

    if(deletedConnectionFromServerChannelId != null) {
      final channel = serverSnapshots?.channels.get("public:$deletedConnectionFromServerChannelId");
      channel?.subscribe().listen((event) {
        final data = event.data as Map<Object?, Object?>;
        final json = convertMap(data);
        final chatConnectionId = json['chatConnectionId'] as int?;
        _deleteConnection(connectionId: chatConnectionId);
      });
    }

    if(matchedConnectionFromServerChannelId != null) {
      final channel = serverSnapshots?.channels.get("public:$matchedConnectionFromServerChannelId");
      channel?.subscribe().listen((event) {
        final data = event.data as Map<Object?, Object?>;
        final json = convertMap(data);
        final chatConnectionId = json['connectionId'] as int?;
        final matchedAtObjs = data["matchedAt"];
        final matchedAt = convertObjectToString(matchedAtObjs);
        if(matchedAt != null) {
          _updateMatchedAt(connectionId: chatConnectionId, matchedAt: DateTime.parse(matchedAt));
        }

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

  _createConnectionIfNotExist({int? connectionId}) async {

    if(connectionId == null) { return;}
    final connectionList = [...state.chatConnections];
    final connectionIndexFound = connectionList.indexWhere((element) => element.id == connectionId);
    if(connectionIndexFound > -1) {
      return;
    }
    final connection = await getChatConnectionById(chatConnectionId: connectionId);
    if(connection == null) { return; }
    connectionList.insert(0, connection);
    emit(state.copyWith(status: ChatConnectionStatus.createConnectionInProgress));
    emit(state.copyWith(status: ChatConnectionStatus.refreshChatConnectionsCompleted, chatConnections: connectionList));
  }

  void _updateMatchedAt({required int? connectionId, DateTime? matchedAt}) {
    final connectionList = [...state.chatConnections];
    final connectionIndex = connectionList.indexWhere((element) => element.id == connectionId);
    if(connectionIndex < 0){
      return;
    }
    final updatedConnection = connectionList[connectionIndex].copyWith(
        matchedAt: matchedAt
    );
    connectionList[connectionIndex] = updatedConnection;
    emit(state.copyWith(status: ChatConnectionStatus.matchedAtUpdatedInProgress));
    emit(state.copyWith(status: ChatConnectionStatus.refreshChatConnectionsCompleted, chatConnections: connectionList));
    emit(state.copyWith(status: ChatConnectionStatus.matchedAtUpdated, data: updatedConnection));
    ///! Refresh chat connectios list

  }

  void _updateLastMessage(ChatMessageModel? message) {
    if(message == null){return;}
    final connectionList = [...state.chatConnections];
    final connectionIndex = connectionList.indexWhere((element) => element.id == message.chatConnectionId);
    if(connectionIndex < 0){
      return;
    }
    final updatedConnectionItem = connectionList[connectionIndex].copyWith(
      lastMessage: message
    );
    // put this connection item at the top
    connectionList.removeAt(connectionIndex);
    connectionList.insert(0, updatedConnectionItem);

    emit(state.copyWith(status: ChatConnectionStatus.lastMessageUpdatedInProgress));
    emit(state.copyWith(status: ChatConnectionStatus.refreshChatConnectionsCompleted, chatConnections: connectionList));
    ///! Refresh chat connectios list

  }

  void _deleteConnection({required int? connectionId}) {
    final connections = <ChatConnectionModel>[...state.chatConnections];
    final foundConnectionIndex = connections.indexWhere((element) => element.id == connectionId);
    if(foundConnectionIndex < 0) {
      return;
    }

    // remove locally
    final foundChatConnection = connections[foundConnectionIndex];
    final updatedTotalUnreadMessages = state.totalUnreadMessages - (foundChatConnection.unreadMessages ?? 0);
    connections.removeAt(foundConnectionIndex);
    emit(state.copyWith(status: ChatConnectionStatus.refreshChatConnectionsInProgress));
    emit(state.copyWith(status: ChatConnectionStatus.refreshChatConnectionsCompleted,
        chatConnections: connections,
        totalUnreadMessages: updatedTotalUnreadMessages.toInt()
    ));

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

    //! check if there is an existing connection locally
    final existingCon = state.chatConnections.where((conn) => (conn.participants?.where((p) => p.id == opponent.id).firstOrNull != null)).firstOrNull;
    if(existingCon != null) {
      emit(state.copyWith(status: ChatConnectionStatus.createChatConnectionSuccessful));
      return (null, existingCon);
    }

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

  // Future<void>
  Future<(String?, List<ChatConnectionModel>?)>  fetchChatConnections({int pageKey = 1}) async {


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
      return (l, null);
    }

    final r = either.asRight().where((element) => element.lastMessage != null).toList();

    final List<ChatConnectionModel> connections = <ChatConnectionModel>[...state.chatConnections];
    if(pageKey == 1){
      // if its first page request remove all existing threads
      connections.clear();
    }
    connections.addAll(r);

    emit(state.copyWith(status: ChatConnectionStatus.refreshChatConnectionsCompleted, chatConnections: connections));
    return (null, r);

  }

  Future<ChatConnectionModel?> getChatConnectionById({required int? chatConnectionId}) async {
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

  void deleteConnection({ChatConnectionModel? connection}) {

    if(connection == null) {
      return;
    }
    // you cannot delete a message which is not yours
    final opponent = connection.participants?.where((element) => element.id != authenticatedUser?.id).firstOrNull;
    if(opponent == null) {
      return;
    }
    // delete from local
    _deleteConnection(connectionId: connection.id);
    // remove from the server
    chatRepository.deleteConnection(chatConnectionId: connection.id, opponentId: opponent.id);
  }


}