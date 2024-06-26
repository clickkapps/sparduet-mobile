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


  Future<Either<String, void>> saveProfileView({required int? profileId}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.saveProfileView;

      final body = {
        "profile_id": profileId
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

  Future<Either<String, void>> markProfileViewAsRead({required List<int> ids}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.markProfileViewAsRead;

      final body = {
        "ids": ids
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

  Future<Either<String, List<UserModel>>> fetchUnreadProfileViewers({int? pageKey}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.fetchUnreadProfileViewers;

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.get,
          queryParams:  {"page": pageKey}
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final dynamicList = response.data["extra"]["data"] as List<dynamic>;
        final list = List<UserModel>.from(dynamicList.map((x) => UserModel.fromJson(x['viewer'])));

        // mark profile views as read
        List<int> ids = list.where((element) => element.id != null).map((e) => e.id!).toList();
        if(ids.isNotEmpty) {
          markProfileViewAsRead(ids: ids);
        }

        return  Right(list);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }  catch (e) {
      return Left(e.toString());
    }


  }


  Future<Either<String, num>> countUnreadProfileViews() async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.countUnreadProfileViewers;

      final response = await networkProvider.call(
        path: path,
        method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final cnt = response.data["extra"] as num;
        return  Right(cnt);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }  catch (e) {
      return Left(e.toString());
    }

  }


}