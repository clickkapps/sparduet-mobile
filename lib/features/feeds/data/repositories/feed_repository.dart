import 'package:dartz/dartz.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/files/data/models/media_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';

class FeedRepository {

  final NetworkProvider networkProvider;
  const FeedRepository({required this.networkProvider});

  // Initiate post without the media to get the Id
  Future<Either<String, int>> createPost({String? purpose, MediaModel? media, String? description, bool commentsDisabled = false}) async {

      try {

        // // Simulated response
        // await Future.delayed(const Duration(seconds: 4), );
        // const feed = FeedModel(
        //     id: 1,
        //     user: UserModel(id: 2, email: "danielkwakye1000@gmail.com"),
        //     mediaPath: "imnnt00chidoe0appuye",
        //     mediaType: FileType.video,
        //     purpose: "introduction",
        //     description: "Hey✋, let's connect and learn more about each other."
        // );
        // return const Right(feed);

        // by default it fetches the current loggedIn User Profile
        const path = AppApiRoutes.createPost;
        final body = {
            "purpose": purpose,
            "media_path": media?.path ?? "",
            "media_type": media?.type.name ?? "",
            "asset_id": media?.assetId ?? "",
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

          final feedId = response.data["extra"]["id"] as int;
          return Right(feedId);

        } else {
          return Left(response.statusMessage ?? "");
        }


      }catch(error) {
        return Left(error.toString());
      }

  }

  Future<Either<String, FeedModel>> attachMediaToPost({required int postId,required MediaModel media}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.attachMediaToPost(postId: postId);
      final body = {
        "media_path": media.path,
        "media_type": media.type.name,
        "asset_id": media.assetId,
        "aspect_ratio": media.aspectRatio
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

        if(!(response.data["status"] as bool)) {
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


  /// Like / unlike post
  /// actions - ["add", "remove"]
  Future<Either<String, void>> togglePostLikeAction({required int? postId, required String action}) async {
    try{

      final path = AppApiRoutes.togglePostLikeAction(postId: postId);
      final body = {
        "action": action,
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
        return const Right(null);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }catch(error) {
      return Left(error.toString());
    }
  }

  /// bookmark / unBookmark post

  Future<Either<String, void>> togglePostBookmarkAction({required int? postId}) async {

    try{

      final path = AppApiRoutes.togglePostBookmarkAction(postId: postId);

      final response = await networkProvider.call(
        path: path,
        method: RequestMethod.post,
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

/// report post
  Future<Either<String, void>> reportPost({required int? postId, required String reason}) async {
    try{

      final path = AppApiRoutes.reportPostAction(postId: postId);

      final body = {
        "reason": reason,
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


/// view post
  /// actions -> ['seen', 'watched']
  Future<Either<String, void>> viewPost({required int? postId, required String action}) async {
    try{

      final path = AppApiRoutes.viewPostAction(postId: postId);

      final body = {
        "action": action,
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


  Future<Either<String, void>> deletePost({required int? postId}) async {
    try{

      // await Future.delayed(const Duration(seconds: 1));
      // return const Right(null);

      final path = AppApiRoutes.deletePostAction(postId: postId);

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.post,
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