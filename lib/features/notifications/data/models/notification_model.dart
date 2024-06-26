import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@CopyWith()
@JsonSerializable()
class NotificationModel extends Equatable {
  final int? id;
  final String? message;
  final String? title;

  @JsonKey(name: "read_at")
  final DateTime? readAt;

  @JsonKey(name: "seen_at")
  final DateTime? seenAt;

  final String? type;

  @JsonKey(name: "created_at")
  final DateTime? createdAt;

  const NotificationModel({this.id,
    this.title, this.message, this.readAt,
    this.seenAt, this.type, this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  @override
  List<Object?> get props => [id, readAt];


}