import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_broadcast_repository.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_repository.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_state.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

class ChatConnectionsCubit extends Cubit<ChatConnectionState> {

  final ChatRepository chatRepository;
  final ChatBroadcastRepository chatBroadcastRepository;
  AuthUserModel? authenticatedUser;

  ChatConnectionsCubit({required this.chatRepository, required this.chatBroadcastRepository}): super(const ChatConnectionState());

  @override
  Future<void> close() {
    chatRepository.closeConnectionBox();
    return super.close();
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


}