import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';

part 'chat_state.g.dart';

@CopyWith()
class ChatState extends Equatable{
  final ChatStatus status;
  final String? message;

  const ChatState({this.status = ChatStatus.initial, this.message});

  @override
  List<Object?> get props => [status, message];
}