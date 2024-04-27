import 'package:dartz/dartz.dart';
import 'package:sparkduet/features/files/data/models/media_model.dart';
import 'package:sparkduet/network/api_config.dart';
import 'package:sparkduet/network/network_provider.dart';

class FeedRepository {

  final NetworkProvider networkProvider;
  const FeedRepository({required this.networkProvider});

  // Create a new story feed
  Future<Either<String, void>> postFeed({String? purpose, MediaModel? media, String? description, bool commentsDisabled = false}) async {

      try {

        // by default it fetches the current loggedIn User Profile
        const path = ApiConfig.feeds;
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

          return const Right(null);

        } else {
          return Left(response.statusMessage ?? "");
        }


      }catch(error) {
        return Left(error.toString());
      }

  }

}