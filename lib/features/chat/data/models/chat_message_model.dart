import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

part 'chat_message_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class ChatMessageModel extends Equatable {

  final int? id;
  @JsonKey(name: "chat_connection_id")
  final int? chatConnectionId;
  @JsonKey(name: "client_id")
  final String? clientId;
  final String? text;
  final ChatMessageModel? parent;
  final DateTime? createdAt;
  @JsonKey(name: "attachment_path")
  final String? attachmentPath;
  @JsonKey(name: "attachment_type")
  final String? attachmentType; // image/video
  @JsonKey(name: "sent_by_id")
  final int? sentById;
  @JsonKey(name: "sent_to_id")
  final int? sentToId;
  @JsonKey(name: "deleted_at")
  final DateTime? deletedAt;
  @JsonKey(name: "delivered_at")
  final DateTime? deliveredAt;
  @JsonKey(name: "seen_at")
  final DateTime? seenAt;

  const ChatMessageModel({
    this.id,
    this.chatConnectionId,
    this.clientId,
    this.text,
    this.parent,
    this.createdAt,
    this.attachmentPath,
    this.attachmentType,
    this.sentById,
    this.sentToId,
    this.deletedAt,
    this.deliveredAt,
    this.seenAt
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  @override
  List<Object?> get props => [id, clientId, text, deliveredAt, seenAt, deletedAt];

}

