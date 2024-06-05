import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/chat/data/models/chat_model.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

part 'chat_state.g.dart';

@CopyWith()
class ChatState extends Equatable {
  final String message;
  final ChatStatus status;
  final List<ChatModel> chatConnections;
  final int unreadMessages;
  final List<UserModel> suggestedChatUsers;

  const ChatState({
    this.message = '',
    this.status = ChatStatus.initial,
    this.chatConnections = const [],
    this.unreadMessages = 0,
    this.suggestedChatUsers = const []
  });

  @override
  List<Object?> get props => [status, unreadMessages];

}