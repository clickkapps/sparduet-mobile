import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/auth/data/store/auth_state.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import '../repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {

  final AuthRepository authRepository;
  AuthCubit({required this.authRepository}): super(const AuthState());

  Future<AuthUserModel?> getCurrentUserSession() async {
    AuthUserModel? user  = state.authUser;
    // return user session if any
    user ??= await authRepository.getCurrentUserSession();
    return user;
  }

  void updateAuthUserInfo({required AuthUserModel updatedAuthUser}) {
    emit(state.copyWith(authUser: updatedAuthUser));
  }

  void login({required String token}) async {

    emit(state.copyWith(status: AuthStatus.logInInProgress));

    final either = await authRepository.login(token: token);

    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: AuthStatus.loginFailed, message: l));
      return;
    }

    // login successful
    final r = either.asRight();
    updateAuthUserInfo(updatedAuthUser: r);
    emit(state.copyWith(status: AuthStatus.loginSuccessful));

  }

  void submitEmail({required String email}) async {

    emit(state.copyWith(status: AuthStatus.submitEmailInProgress));

    final either = await authRepository.submitEmailForAuthorization(email: email);

    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: AuthStatus.submitEmailFailed, message: l));
      return;
    }

    emit(state.copyWith(status: AuthStatus.submitEmailSuccessful));

  }

  void resendEmail({required String email}) async {

    emit(state.copyWith(status: AuthStatus.resendEmailInProgress));

    final either = await authRepository.submitEmailForAuthorization(email: email);
    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: AuthStatus.resendEmailFailed, message: l));
      return;
    }

    emit(state.copyWith(status: AuthStatus.resendEmailSuccessful));

  }

  void authorizeEmail({ required String email, required String code}) async {

    emit(state.copyWith(status: AuthStatus.authorizeEmailInProgress));

    final either = await authRepository.authorizeEmail(email: email, code: code);

    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: AuthStatus.authorizeEmailFailed, message: l));
      return;
    }

    final r = either.asRight(); // token
    emit(state.copyWith( status: AuthStatus.authorizeEmailSuccessful, data: r ));

  }

  void logout() async {
    emit(state.copyWith(status: AuthStatus.logOutInProgress));
    await authRepository.logout();
    emit(state.copyWith(status: AuthStatus.logOutCompleted, authUser: null));
  }

}