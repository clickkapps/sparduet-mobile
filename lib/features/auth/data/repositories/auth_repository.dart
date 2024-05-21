import 'package:dartz/dartz.dart';
import 'package:sparkduet/core/app_storage.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';

class AuthRepository {

  final NetworkProvider networkProvider;
  final AppStorage localStorageProvider;

  AuthRepository({required this.networkProvider, required this.localStorageProvider});

  Future<AuthUserModel?> getCurrentUserSession() async {
    // attempt to retrieve user details from pref
    // maybe the user has used the app before, so check if there's an authenticated user in local storage
    AuthUserModel? user  = await localStorageProvider.getAuthUserFromLocalStorage();
    // if there's no authUserDetails
    return user;

  }

  Future<Either<String, String>> submitEmailForAuthorization({required String email}) async {

    try{

      const path = AppApiRoutes.submitAuthEmail;

      var response = await networkProvider.call(
          path: path,
          useToken: false,
          method: RequestMethod.post,
          body: {
            'email': email
          }
      );

      if(response!.statusCode == 200){

        if(!(response.data["status"] as bool)) {
          return Left(response.data["message"] as String);
        }

        return const Right("Email sent");

      }else {

        return Left(response.statusMessage ?? "");

      }


    }catch(e){
      return Left(e.toString());
    }


  }

  Future<Either<String, String>> authorizeEmail({
    required String email,
    required String code}) async {

    try {

      const path = AppApiRoutes.authEmail;

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.post,
          useToken: false,
          body: {
            'email': email,
            'code': code
          }
      );

      if(response!.statusCode == 200){

        if(!(response.data["status"] as bool)) {
          return Left(response.data["message"]);
        }

        final token = response.data["extra"] as String;

        return Right(token);

      }else {
        return Left(response.statusMessage ?? "");
      }


    } catch(e) {
      return Left(e.toString());
    }

  }




  /// this method gets information about the current user
  /// and saves to local storage

  Future<Either<String, AuthUserModel>> login({required String token}) async {

    try {

      // set the token in local storage for subsequent requests
      await localStorageProvider.setAuthTokenVal(token);

      // fetch and update the current loggedIn user
      return await fetchAuthUserProfile();

    } catch (e) {
      return Left(e.toString());
    }

  }

  Future<void> saveAuthUser(AuthUserModel updatedUser) async {
    await localStorageProvider.saveAuthUserToLocalStorage(updatedUser);
  }

  // fetch and update the current loggedIn user from the server
  Future<Either<String, AuthUserModel>> fetchAuthUserProfile() async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.userProfile();

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.get
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final data = response.data["extra"];

        final user = AuthUserModel.fromJson(data);
        await localStorageProvider.saveAuthUserToLocalStorage(user);

        return Right(user);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }  catch (e) {
      return Left(e.toString());
    }


  }

  // update auth profile
  Future<Either<String, AuthUserModel>> updateAuthUserProfile({
    required Map<String, dynamic> payload}) async {

    try {

      const path = AppApiRoutes.updateProfile;

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.post,
          useToken: true,
          body: payload
      );

      if(response!.statusCode == 200){

        if(!(response.data["status"] as bool)) {
          return Left(response.data["message"]);
        }

        final data = response.data["extra"] as Map<String, dynamic>;
        final user = AuthUserModel.fromJson(data);
        await localStorageProvider.saveAuthUserToLocalStorage(user);

        return Right(user);
      }else {
        return Left(response.statusMessage ?? "");
      }


    } catch(e) {
      return Left(e.toString());
    }

  }


  Future<void> logout() async{

    // remove user from session

    // remove token
    await localStorageProvider.removeAuthTokenVal();

    // clear user details
    await localStorageProvider.removeAuthUserFromLocalStorage();

  }


}