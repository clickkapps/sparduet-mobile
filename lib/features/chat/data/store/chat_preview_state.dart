import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';

part 'chat_preview_state.g.dart';

@CopyWith()
class ChatPreviewState extends Equatable {
  final String message;
  final ChatPreviewStatus status;
  final Map<DateTime, List<ChatMessageModel>> reOrderedChatMessages;
  final List<ChatMessageModel> linearMessagesList;
  final dynamic data; // temporal data
  final ChatConnectionModel? selectedConnection;

  const ChatPreviewState({
    this.message = '',
    this.status = ChatPreviewStatus.initial,
    this.reOrderedChatMessages = const {},
    this.linearMessagesList = const [],
    this.data,
    this.selectedConnection,
  });

  @override
  List<Object?> get props => [status, message];

}