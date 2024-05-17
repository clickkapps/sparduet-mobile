import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/files/data/models/media_model.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';

class FeedRepository {

  final NetworkProvider networkProvider;
  const FeedRepository({required this.networkProvider});

  // Create a new story feed
  Future<Either<String, FeedModel>> postFeed({String? purpose, MediaModel? media, String? description, bool commentsDisabled = false}) async {

      try {

        // // Simulated response
        await Future.delayed(const Duration(seconds: 4), );
        const feed = FeedModel(
            id: 1,
            user: UserModel(id: 2, email: "danielkwakye1000@gmail.com"),
            mediaPath: "imnnt00chidoe0appuye",
            mediaType: FileType.video,
            purpose: "introduction",
            description: "Hey✋, let's connect and learn more about each other."
        );
        return const Right(feed);

        // by default it fetches the current loggedIn User Profile
        const path = AppApiRoutes.createFeed;
        final body = {
            "purpose": purpose,
            "media_path": media?.path,
            "media_type": media?.type.name,
            "description": description,
            "comments_disabled": commentsDisabled
        };

        final response = await networkProvider.call(
            path: path,
            method: RequestMethod.post,
            body: body,
        );

        if (response!.statusCode == 200) {

          if(!(response.data["status"] as bool)){
            return Left(response.data["message"] as String);
          }

          final feedJson = response.data["extra"] as Map<String, dynamic>;
          final feed = FeedModel.fromJson(feedJson);
          return Right(feed);

        } else {
          return Left(response.statusMessage ?? "");
        }


      }catch(error) {
        return Left(error.toString());
      }

  }

  Future<Either<String, List<FeedModel>>> fetchFeeds(String path, {Map<String, dynamic>? queryParams}) async {

    try {

      // by default it fetches the current loggedIn User Profile

      final response = await networkProvider.call(
        path: path,
        method: RequestMethod.get,
        queryParams: queryParams ?? const {}
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final dynamicList = response.data["extra"]["data"] as List<dynamic>;
        final list = List<FeedModel>.from(dynamicList.map((x) => FeedModel.fromJson(x!)));
        return Right(list);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }catch(error) {
      return Left(error.toString());
    }

  }

}