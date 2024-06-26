import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_notice_model.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';

part 'auth_state.g.dart';

@CopyWith()
class AuthState extends Equatable {
  final AuthStatus status;
  final String message;
  final AuthUserModel? authUser;
  final dynamic data; // for keeping temporary data
  final AuthUserNoticeModel? userNotice;

  const AuthState({
    this.status = AuthStatus.initial,
    this.message = "",
    this.authUser,
    this.data,
    this.userNotice
  });

  @override
  List<Object?> get props =>[status, authUser, userNotice];

}