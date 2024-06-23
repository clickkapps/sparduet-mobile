import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

part 'chat_connection_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@HiveType(typeId: AppConstants.chatConnectionModelHiveId)
class ChatConnectionModel extends Equatable {

  @HiveField(0)
  final int? id;

  // The other participant is you
  @HiveField(1)
  @JsonKey(name: 'last_message')
  final ChatMessageModel? lastMessage;

  @HiveField(2)
  @JsonKey(name: "matched_at")
  final DateTime? matchedAt;

  @HiveField(3)
  @JsonKey(name: "read_first_impression_note_at")
  final DateTime? readFirstImpressionNoteAt;

  @HiveField(4)
  final List<UserModel>? participants; // Users of the chat

  @HiveField(5)
  @JsonKey(name: "created_at")
  final DateTime? createdAt;

  @HiveField(6)
  @JsonKey(fromJson: _unreadMessagesFromJson, name: "pivot")
  final num? unreadMessages;

  const ChatConnectionModel({this.id,
    this.participants, this.lastMessage, this.createdAt,
    this.matchedAt,
    this.readFirstImpressionNoteAt,
    this.unreadMessages,
  });

  static num? _unreadMessagesFromJson(dynamic value) {
    if(value == null) return null;
    final pivot = value as Map<String, dynamic>;
    final unreadMessages = pivot['unread_messages'] as num?;
    return unreadMessages ?? 0;
  }

  factory ChatConnectionModel.fromJson(Map<String, dynamic> json) => _$ChatConnectionModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatConnectionModelToJson(this);

  @override
  List<Object?> get props => [id, lastMessage, matchedAt, readFirstImpressionNoteAt];

}