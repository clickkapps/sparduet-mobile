import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';

class ChatBroadcastEvent {
  final ChatBroadcastAction action;
  final ChatMessageModel? message;
  final ChatConnectionModel? chatConnection;
  final dynamic data;
  const ChatBroadcastEvent({required this.action, this.message,  this.chatConnection,  this.data});
}