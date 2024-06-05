import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_user_model.g.dart';



// This class has been created to reduce the use payload sent in chats
@JsonSerializable(explicitToJson: true)
@CopyWith()
class ChatUserModel extends Equatable {
  final int? id;
  final String? username;
  final String? name;
  final String? email;
  final String? image;
  final int unreadMessages;

  const ChatUserModel({this.id, this.name, this.email, this.username, this.image, this.unreadMessages = 0});

  factory ChatUserModel.fromJson(Map<String, dynamic> json) => _$ChatUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserModelToJson(this);

  @override
  List<Object?> get props => [id, unreadMessages];

}