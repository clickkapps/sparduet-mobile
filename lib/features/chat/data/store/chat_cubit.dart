import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_repository.dart';
import 'package:sparkduet/features/chat/data/store/chat_state.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  ChatCubit({required this.chatRepository}): super( const ChatState());

  Future<(String?, CubeDialog?)> createChatConnection(UserModel opponent) async {

    emit(state.copyWith(status: ChatStatus.createChatConnectionInProgress));
    final either = await chatRepository.createChatConnection(opponent);
    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: ChatStatus.createChatConnectionFailed, message: l));
      return (l, null);
    }

    final r = either.asRight();
    emit(state.copyWith(status: ChatStatus.createChatConnectionSuccessful));
    return (null, r);
  }

  void fetchChatConnections() async {
    emit(state.copyWith(status: ChatStatus.fetchChatConnectionsInProgress));
    final either = await chatRepository.fetchChatConnection();
    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: ChatStatus.fetchChatConnectionsFailed, message: l));
      return;
    }

    final r = either.asRight();
    emit(state.copyWith(status: ChatStatus.fetchChatConnectionsSucessful,
      chatConnections: r?.items
    ));
  }

}