import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_broadcast_repository.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_repository.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_state.dart';

class ChatPreviewCubit extends Cubit<ChatPreviewState> {

  final ChatRepository chatRepository;
  final ChatBroadcastRepository chatBroadcastRepository;
  AuthUserModel? authenticatedUser;
  ChatPreviewCubit({required this.chatRepository, required this.chatBroadcastRepository}): super(const ChatPreviewState());

  void setAuthenticatedUser(AuthUserModel? authUser) => authenticatedUser = authUser;

}