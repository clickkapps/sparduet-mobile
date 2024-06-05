import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/core/app_server_timestamp_converter.dart';
import 'package:sparkduet/features/chat/data/models/chat_user_model.dart';
import 'package:sparkduet/features/chat/data/models/message_model.dart';

part 'chat_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class ChatModel extends Equatable {

  final String? id;

  final List<ChatUserModel>? participants; // Users of the chat

  // The other participant is you
  final MessageModel? lastMessage;

  @ServerTimestampConverter()
  final DateTime? createdAt;

  final List<int?>? participantIds;

  const ChatModel({this.id, this.participants, this.lastMessage, this.createdAt, this.participantIds});

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  @override
  List<Object?> get props => [id, createdAt, lastMessage, participants];

}