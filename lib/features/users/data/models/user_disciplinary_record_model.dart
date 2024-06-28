import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_disciplinary_record_model.g.dart';

@JsonSerializable()
@CopyWith()
class UserDisciplinaryRecordModel {

  final int? id;

  @JsonKey(name: "disciplinary_action")
  final String? disciplinaryAction; // warned / banned

  final String? reason;

  final String? status; // opened / closed

  @JsonKey(name: "user_read_at")
  final DateTime? userReadAt;

  const UserDisciplinaryRecordModel({
    this.id,
    this.disciplinaryAction,
    this.reason,
    this.status,
    this.userReadAt
  });

  factory UserDisciplinaryRecordModel.fromJson(Map<String, dynamic> json) => _$UserDisciplinaryRecordModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserDisciplinaryRecordModelToJson(this);

}