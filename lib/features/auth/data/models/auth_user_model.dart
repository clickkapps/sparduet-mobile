import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/users/data/models/user_info_model.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

part 'auth_user_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class AuthUserModel extends UserModel {

  const AuthUserModel({
    super.id,
    super.email,
    super.displayAge,
    super.name,
    super.username,
    super.blocked,
    super.info,
    super.introductoryPost
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => _$AuthUserModelFromJson(json);
}