import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/data/repositories/user_repository.dart';
import 'package:sparkduet/features/users/data/store/enums.dart';
import 'package:sparkduet/features/users/data/store/user_state.dart';

class UserCubit extends Cubit<UserState> {

  final UserRepository userRepository;
  UserCubit({required this.userRepository}) : super(const UserState());

  void setUser(UserModel user) {
      emit(state.copyWith(status: UserStatus.setUserInProgress));
      emit(state.copyWith(status: UserStatus.setUserCompleted, user: user));
  }


  void fetchUserInfo({required int? userId}) async {
    emit(state.copyWith(status: UserStatus.fetchUserInfoInProgress));
    final either = await userRepository.fetchUserProfile(userId: userId);
    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: UserStatus.fetchUserInfoFailed, message: l));
      return;
    }

    final r = either.asRight();
    setUser(r);
    emit(state.copyWith(status: UserStatus.fetchUserInfoSuccessful));
  }


}