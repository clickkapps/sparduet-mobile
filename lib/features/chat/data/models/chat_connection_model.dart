import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';


part 'chat_connection_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class ChatConnectionModel extends Equatable {

  final int? id;

  final List<UserModel>? participants; // Users of the chat

  // The other participant is you
  final ChatMessageModel? lastMessage;

  @JsonKey(name: "matched_at")
  final DateTime? matchedAt;

  @JsonKey(name: "created_at")
  final DateTime? createdAt;

  const ChatConnectionModel({this.id, this.participants, this.lastMessage, this.createdAt, this.matchedAt});

  factory ChatConnectionModel.fromJson(Map<String, dynamic> json) => _$ChatConnectionModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatConnectionModelToJson(this);

  @override
  List<Object?> get props => [id, lastMessage, matchedAt];

}