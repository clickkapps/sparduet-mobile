import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_user_notice_model.g.dart';

@CopyWith()
@JsonSerializable()
class AuthUserNoticeModel extends Equatable {

    final int? id;
    final String? notice;
    final String? link;
    @JsonKey(name: 'notice_read_at')
    final DateTime? noticeReadAt;

    const AuthUserNoticeModel({
      this.id,
      this.notice,
      this.link,
      this.noticeReadAt
    });

  @override
  List<Object?> get props => [id, notice, noticeReadAt];

  factory AuthUserNoticeModel.fromJson(Map<String, dynamic> json) => _$AuthUserNoticeModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthUserNoticeModelToJson(this);

}