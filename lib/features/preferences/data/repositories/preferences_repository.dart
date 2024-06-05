import 'package:dartz/dartz.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';

class PreferencesRepository {
  final NetworkProvider networkProvider;
  const PreferencesRepository({required this.networkProvider});

  Future<Either<String, Map<String, dynamic>>> fetchUserSettings() async {

    try {

      // by default it fetches the current loggedIn User Profile

      const path = AppApiRoutes.fetchSettings;

      final response = await networkProvider.call(
        path: path,
        method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final settings = response.data["extra"] as Map<String, dynamic>;
        // final list = List<UserModel>.from(dynamicList.map((x) => UserModel.fromJson(x!)));
        return Right(settings);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }catch(error) {
      return Left(error.toString());
    }

  }

  Future<Either<String, Map<String, dynamic>>> updateUserSettings({
    required Map<String, dynamic> payload}) async {

    try {

      const path = AppApiRoutes.updateSettings;

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


        final settings = response.data["extra"] as Map<String, dynamic>;
        return Right(settings);

      }else {
        return Left(response.statusMessage ?? "");
      }


    } catch(e) {
      return Left(e.toString());
    }

  }


  /// create feedback
  Future<Either<String, void>> createFeedback({required String message}) async {
    try{

      const path = AppApiRoutes.createFeedback;

      final body = {
        "message": message,
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

    }catch(error) {
      return Left(error.toString());
    }
  }


}