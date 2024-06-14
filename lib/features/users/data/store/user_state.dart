import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/data/store/enums.dart';

part 'user_state.g.dart';

@CopyWith()
class UserState extends Equatable {
  final String? message;
  final UserModel? user;
  final UserStatus status;
  final num unreadViewersCount;
  final List<UserModel> unreadViewers;

  const UserState({this.message,
    this.user,
    this.status = UserStatus.initial,
    this.unreadViewersCount = 0,
    this.unreadViewers = const []
  });

  @override
  List<Object?> get props => [status, message, user, unreadViewersCount];
}