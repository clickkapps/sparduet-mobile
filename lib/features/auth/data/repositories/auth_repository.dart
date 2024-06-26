import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sparkduet/core/app_storage.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_notice_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

  Future<Either<String, (String, String)>> authorizeEmail({
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

        final tokens = response.data["extra"] as Map<String, dynamic>;
        final accessToken = tokens['access_token'] as String;
        final customToken = tokens['custom_token'] as String;

        return Right((accessToken, customToken));

      }else {
        return Left(response.statusMessage ?? "");
      }


    } catch(e) {
      return Left(e.toString());
    }

  }




  /// this method gets information about the current user
  /// and saves to local storage

  Future<Either<String, AuthUserModel>> login({required String token, required String customToken}) async {

    try {

      // set the token in local storage for subsequent requests
      await FirebaseAuth.instance.signInWithCustomToken(customToken);
      await localStorageProvider.setAuthTokenVal(token);

      // fetch and update the current loggedIn user
      final either = await fetchAuthUserProfile();
      return either;

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-custom-token":
          debugPrint("The supplied token is not a Firebase custom auth token.");
          return const Left("The supplied token is not a Firebase custom auth token.");
        case "custom-token-mismatch":
          debugPrint("The supplied token is for a different Firebase project.");
          return const Left("The supplied token is for a different Firebase project.");
        default:
          return Left(e.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }

  }

  Future<void> setChatId() async {

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

    OneSignal.logout();
    FirebaseAuth.instance.signOut();

  }


  Future<Either<String, AuthUserNoticeModel>> getUserNotice() async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.getUserNotice;

      final response = await networkProvider.call(
        path: path,
        method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final data = response.data["extra"] as Map<String, dynamic>;
        final notice = AuthUserNoticeModel.fromJson(data);
        return  Right(notice);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }  catch (e) {
      return Left(e.toString());
    }

  }

  Future<Either<String, void>> markNoticeAsRead({required int? noticeId}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.markNoticeAsRead;

      final body = {
        "notice_id": noticeId
      };

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.post,
          body: body
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        return const Right(null);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }  catch (e) {
      return Left(e.toString());
    }


  }

  Future<Either<String, void>> reportUser({required int? offenderId, required String reason}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.reportUser;

      final body = {
        "offender_id": offenderId,
        "reason": reason
      };

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.post,
          body: body
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        return const Right(null);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }  catch (e) {
      return Left(e.toString());
    }

  }

  Future<Either<String, void>> blockUser({required int? offenderId, String? reason}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.blockUser;

      final body = {
        "offender_id": offenderId,
        "reason": reason
      };

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.post,
          body: body
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        return const Right(null);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }  catch (e) {
      return Left(e.toString());
    }


  }

  Future<Either<String, void>> unblockUser({required int? offenderId}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.unblockUser;

      final body = {
        "offender_id": offenderId,
      };

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.post,
          body: body
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        return const Right(null);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }  catch (e) {
      return Left(e.toString());
    }


  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  /// (String, Position?) is countryCode and cordinates
  Future<Either<String? , AuthUserModel>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return const Left('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied forever, handle appropriately.
        final locationSetupResponse = await _setupAuthUserLocation(countryCode: null, position: null);
        if(locationSetupResponse.$1 != null) {
          return Left(locationSetupResponse.$1);
        }
        final user = locationSetupResponse.$2;
        return Right(user!);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      final locationSetupResponse = await _setupAuthUserLocation(countryCode: null, position: null);
      if(locationSetupResponse.$1 != null) {
        return Left(locationSetupResponse.$1);
      }
      final user = locationSetupResponse.$2;
      return Right(user!);
      // return const Left(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    String? countryCode;
    if (placemarks.isNotEmpty) {
      countryCode = placemarks.first.isoCountryCode;
    }
    final locationSetupResponse = await _setupAuthUserLocation(countryCode: countryCode, position: position);
    if(locationSetupResponse.$1 != null) {
      return Left(locationSetupResponse.$1);
    }
    final user = locationSetupResponse.$2;
    return Right(user!);
  }

  Future<(String?, AuthUserModel?)> _setupAuthUserLocation({String? countryCode, Position? position}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.setupUserLocation;

      final body = {
        "country_code": countryCode,
        "loc": position != null ? "${position.latitude},${position.longitude}" : null
      };

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.post,
          body: body
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return (response.data["message"] as String, null);
        }

        final data = response.data["extra"] as Map<String, dynamic>;
        final user = AuthUserModel.fromJson(data);
        await localStorageProvider.saveAuthUserToLocalStorage(user);
        return (null, user);

      } else {
        return (response.statusMessage ?? "", null);
      }

    }  catch (e) {
      return (e.toString(), null);
    }

  }


}