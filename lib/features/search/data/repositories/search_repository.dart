import 'package:dartz/dartz.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';


class SearchRepository {
  final NetworkProvider networkProvider;
  const SearchRepository({required this.networkProvider});

  Future<Either<String, (List<UserModel>, List<FeedModel>)>> topSearch({String? query}) async {
    try {

      const path = AppApiRoutes.topSearch;

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.get,
          queryParams: {
            'terms': query
          }
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final usersDynamicList = response.data["extra"]["users"]['data'] as List<dynamic>;
        final storiesDynamicList = response.data["extra"]["stories"]['data'] as List<dynamic>;
        final userList = List<UserModel>.from(usersDynamicList.map((x) => UserModel.fromJson(x)));
        final storiesList = List<FeedModel>.from(storiesDynamicList.map((x) => FeedModel.fromJson(x)));
        return Right((userList, storiesList));

      } else {
        return Left(response.statusMessage ?? "");
      }


    }catch(error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<UserModel>>> searchUsers({String? query, int? pageKey}) async {
    try {

      const path = AppApiRoutes.usersSearch;

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.get,
          queryParams: {
            'terms': query,
            'page': pageKey,
            'limit': AppConstants.listPageSize
          }
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final usersDynamicList = response.data["extra"]['data'] as List<dynamic>;
        final userList = List<UserModel>.from(usersDynamicList.map((x) => UserModel.fromJson(x!)));
        return Right(userList);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }catch(error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<FeedModel>>> searchStories({String? query, int? pageKey}) async {
    try {

      const path = AppApiRoutes.storiesSearch;

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.get,
          queryParams: {
            'terms': query,
            'page': pageKey,
            'limit': AppConstants.gridPageSize
          }
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final storiesDynamicList = response.data["extra"]['data'] as List<dynamic>;
        final storiesList = List<FeedModel>.from(storiesDynamicList.map((x) => FeedModel.fromJson(x!)));
        return Right(storiesList);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }catch(error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<String>>> popularSearchTerms() async {
    try {

      const path = AppApiRoutes.popularSearchTerms;

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final dynamicList = response.data["extra"] as List<dynamic>;
        final list = List<String>.from(dynamicList.map((x) => x['search'] as String));
        return Right(list);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }catch(error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<String>>> recentSearchTerms() async {
    try {

      const path = AppApiRoutes.userSearchTerms;

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final dynamicList = response.data["extra"] as List<dynamic>;
        final list = List<String>.from(dynamicList.map((x) => x['query']));
        return Right(list);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }catch(error) {
      return Left(error.toString());
    }
  }

}