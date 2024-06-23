import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

part 'chat_connections_state.g.dart';

@CopyWith()
class ChatConnectionState extends Equatable {
  final String message;
  final ChatConnectionStatus status;
  final List<ChatConnectionModel> chatConnections;
  final int totalUnreadMessages;
  final List<UserModel> suggestedChatUsers;

  const ChatConnectionState({
    this.message = '',
    this.status = ChatConnectionStatus.initial,
    this.chatConnections = const [],
    this.totalUnreadMessages = 0,
    this.suggestedChatUsers = const []
  });

  @override
  List<Object?> get props => [status, totalUnreadMessages];

}