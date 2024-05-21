import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/auth/data/store/auth_state.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/files/data/repositories/file_repository.dart';
import '../repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {

  final AuthRepository authRepository;
  final FileRepository fileRepository;
  AuthCubit({required this.authRepository, required this.fileRepository}): super(const AuthState());

  Future<AuthUserModel?> getCurrentUserSession() async {
    AuthUserModel? user  = state.authUser;
    // return user session if any
    if(user != null) {
      return user;
    }
    user = await authRepository.getCurrentUserSession();
    if(user != null) {
      setAuthUserInfo(updatedAuthUser: user);
    }
    return user;
  }

  void setIntroductoryPost(FeedModel feedModel) {
    final user = state.authUser?.copyWith(
      introductoryPost: feedModel
    );
    if(user == null) {return;}
    authRepository.saveAuthUser(user);
    setAuthUserInfo(updatedAuthUser: user);
  }

  void fetchAuthUserInfo() async {
    emit(state.copyWith(status: AuthStatus.fetchAuthUserInfoInProgress));
    final either = await authRepository.fetchAuthUserProfile();
    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: AuthStatus.fetchAuthUserInfoFailed, message: l));
      return;
    }

    final r = either.asRight();
    setAuthUserInfo(updatedAuthUser: r);
    emit(state.copyWith(status: AuthStatus.fetchAuthUserInfoSuccessful));
  }

  void setAuthUserInfo({required AuthUserModel updatedAuthUser}) {
    emit(state.copyWith(status: AuthStatus.setAuthUserInfoInProgress));
    emit(state.copyWith(authUser: updatedAuthUser, status: AuthStatus.setAuthUserInfoCompleted));
  }

  // update user profile on the server
  Future<(String?, AuthUserModel?)> updateAuthUserProfile({required Map<String, dynamic> payload, AuthUserModel? authUser}) async {

    final existingAuthUserState = state.authUser;
    emit(state.copyWith(status: AuthStatus.updateAuthUserProfileInProgress));

    // if set, will cause UI to update immediately
    if(authUser != null) { setAuthUserInfo(updatedAuthUser: authUser); }

    final either = await authRepository.updateAuthUserProfile(payload: payload);
    if(either.isLeft()) {
      final l = either.asLeft();
      // this will cause any auth updates to revert
      if(existingAuthUserState != null) {
        setAuthUserInfo(updatedAuthUser: existingAuthUserState);
      }
      emit(state.copyWith(status: AuthStatus.updateAuthUserProfileFailed, message: l));
      return (l, null);
    }

    final r = either.asRight();
    setAuthUserInfo(updatedAuthUser: r);
    emit(state.copyWith(status: AuthStatus.updateAuthUserProfileSuccessful));
    return (null, r);

  }

  // void uploadAuthUserProfile()
  void updateAuthUserProfilePhoto({required File file}) async {

    emit(state.copyWith(status: AuthStatus.updateAuthUserProfilePhotoInProgress));
    final uploadResponse = await fileRepository.uploadFilesToServer(files: <File>[file]);

    if(uploadResponse.isLeft()){
      final l = uploadResponse.asLeft();
      emit(state.copyWith(status: AuthStatus.updateAuthUserProfilePhotoFailed, message: l));
      return;
    }

    final uploads = uploadResponse.asRight();
    final filePath = uploads.first;

    final updated = await updateAuthUserProfile(payload: {"profilePhoto": filePath});
    if(updated.$1 != null) {
      // error
      emit(state.copyWith(status: AuthStatus.updateAuthUserProfilePhotoFailed, message: updated.$1));
      return;
    }

    // successful, auth user profile already updated
    emit(state.copyWith(status: AuthStatus.updateAuthUserProfilePhotoSuccessful));

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
    setAuthUserInfo(updatedAuthUser: r);
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