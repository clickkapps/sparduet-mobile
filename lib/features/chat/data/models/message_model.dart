import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/core/app_server_timestamp_converter.dart';
import 'package:sparkduet/features/chat/data/models/chat_user_model.dart';

part 'message_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class MessageModel extends Equatable {

  final String? id;
  final String? message;
  final MessageModel? parent;
  @ServerTimestampConverter()
  final DateTime? createdAt;
  final List<String>? attachments;
  final ChatUserModel? sentBy;
  final ChatUserModel? sentTo;
  final bool delivered;
  final bool seen;
  final bool deleted;

  const MessageModel({this.id, this.message, this.parent, this.sentBy, this.sentTo, this.createdAt, this.attachments, this.delivered = true, this.seen = false, this.deleted = false});

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  @override
  List<Object?> get props => [id, message, delivered, seen, createdAt, deleted];

}

