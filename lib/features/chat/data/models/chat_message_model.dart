import 'dart:io';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

part 'chat_message_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@HiveType(typeId: AppConstants.chatMessageModelHiveId)
class ChatMessageModel extends Equatable {

  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: "chat_connection_id")
  final int? chatConnectionId;

  @HiveField(2)
  @JsonKey(name: "client_id")
  final String? clientId;

  @HiveField(3)
  final String? text;

  @HiveField(4)
  final ChatMessageModel? parent;

  @HiveField(5)
  @JsonKey(name: "created_at")
  final DateTime? createdAt;

  @HiveField(7)
  @JsonKey(name: "attachment_path")
  final String? attachmentPath;

  @HiveField(8)
  @JsonKey(name: "attachment_type")
  final String? attachmentType; // image/video

  @HiveField(9)
  @JsonKey(name: "sent_by_id")
  final int? sentById;

  @HiveField(10)
  @JsonKey(name: "sent_to_id")
  final int? sentToId;

  @HiveField(11)
  @JsonKey(name: "deleted_at")
  final DateTime? deletedAt;

  @HiveField(12)
  @JsonKey(name: "delivered_at")
  final DateTime? deliveredAt;

  @HiveField(13)
  @JsonKey(name: "seen_at")
  final DateTime? seenAt;

  final File? attachedImageFile;

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
    this.seenAt,
    this.attachedImageFile
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  @override
  List<Object?> get props => [id, clientId, text, deliveredAt, seenAt, deletedAt];

}

