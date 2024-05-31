import 'package:dartz/dartz.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';

class UserRepository {
  final NetworkProvider networkProvider;
  const UserRepository({required this.networkProvider});

  // fetch and update selected user
  Future<Either<String, UserModel>> fetchUserProfile({required int? userId}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.userProfile(userId: userId);

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.get
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final data = response.data["extra"];

        final user = UserModel.fromJson(data);
        return Right(user);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }  catch (e) {
      return Left(e.toString());
    }


  }

}