import 'package:sparkduet/features/chat/data/models/chat_model.dart';
import 'package:sparkduet/features/chat/data/models/message_model.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';

class ChatBroadcastEvent {
  final ChatBroadcastAction action;
  final MessageModel? message;
  final ChatModel? chatConnection;
  const ChatBroadcastEvent({required this.action, this.message,  this.chatConnection});
}