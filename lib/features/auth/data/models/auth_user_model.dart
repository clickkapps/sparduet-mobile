import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

part 'auth_user_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class AuthUserModel extends UserModel {

  const AuthUserModel({
    super.id,
    super.email
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => _$AuthUserModelFromJson(json);
}