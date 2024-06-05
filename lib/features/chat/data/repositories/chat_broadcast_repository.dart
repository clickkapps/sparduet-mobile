import 'dart:async';
import 'package:sparkduet/features/chat/data/models/chat_broadcast_event.dart';
import 'package:sparkduet/features/chat/data/models/message_model.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';


class ChatBroadcastRepository {

  final _controller = StreamController<ChatBroadcastEvent>.broadcast();
  Stream<ChatBroadcastEvent> get stream => _controller.stream;

  void updateMessage({required MessageModel message}) {
    _controller.sink.add(ChatBroadcastEvent(action: ChatBroadcastAction.updateMessage, message: message));
  }

  void addMessage({required MessageModel message}) {
    _controller.sink.add(ChatBroadcastEvent(action: ChatBroadcastAction.addMessage, message: message));
  }

  void removeMessage({required MessageModel message}) {
    _controller.sink.add(ChatBroadcastEvent(action: ChatBroadcastAction.deleteMessage, message: message));
  }

}