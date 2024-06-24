import 'dart:async';
import 'package:sparkduet/features/chat/data/models/chat_broadcast_event.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';


class ChatBroadcastRepository {

  final _controller = StreamController<ChatBroadcastEvent>.broadcast();
  Stream<ChatBroadcastEvent> get stream => _controller.stream;

  // void updateMessage({required ChatMessageModel message}) {
  //   _controller.sink.add(ChatBroadcastEvent(action: ChatBroadcastAction.updateMessage, message: message));
  // }

  void updateLastMessage({required ChatMessageModel message,}) {
    _controller.sink.add(ChatBroadcastEvent(action: ChatBroadcastAction.updateLastMessage, message: message));
  }
  void deleteLastMessageIfApplicable({required ChatMessageModel message}) {
    _controller.sink.add(ChatBroadcastEvent(action: ChatBroadcastAction.messageDeleted, message: message));
  }

  // void addMessage({required ChatMessageModel message}) {
  //   _controller.sink.add(ChatBroadcastEvent(action: ChatBroadcastAction.addMessage, message: message));
  // }

  // void removeMessage({required ChatMessageModel message}) {
  //   _controller.sink.add(ChatBroadcastEvent(action: ChatBroadcastAction.deleteMessage, message: message));
  // }

  void updateUnreadMessagesCount(Map<String, dynamic> data) {
    _controller.sink.add(ChatBroadcastEvent(action: ChatBroadcastAction.updateUnreadMessagesCount, data: data));
  }

}