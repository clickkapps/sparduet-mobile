import 'package:dartz/dartz.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';

class ChatRepository {

  final NetworkProvider networkProvider;
  const ChatRepository({required this.networkProvider});

  Future<Either<String, List<UserModel>>> fetchSuggestedChatUsers() async {

    try {

      // by default it fetches the current loggedIn User Profile

      const path = AppApiRoutes.suggestedChatUsers;

      final response = await networkProvider.call(
        path: path,
        method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final dynamicList = response.data["extra"] as List<dynamic>;
        final list = List<UserModel>.from(dynamicList.map((x) => UserModel.fromJson(x!)));
        return Right(list);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }catch(error) {
      return Left(error.toString());
    }

  }


  // the api returns existing connection if already created, else it creates a new connection
  Future<Either<String, ChatConnectionModel?>> createChatConnection(AuthUserModel? authUser, UserModel? opponent, bool createConnectionIfNotExist) async {

    try {

      const path = AppApiRoutes.createChatConnection;
      final body = {
        "first_participant_id": authUser?.id,
        "second_participant_id": opponent?.id,
        "create_connection_if_not_exist": createConnectionIfNotExist
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

        final data = response.data["extra"];
        if(data == null) {
          return const Right(null);
        }
        final json = data as Map<String, dynamic>;
        final connection = ChatConnectionModel.fromJson(json);
        return Right(connection);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }catch(e) {
      return Left(e.toString());
    }

  }

  Future<Either<String, List<ChatConnectionModel>>>?  fetchChatChatConnections({bool fromCache = true}) async {
    try {

      // by default it fetches the current loggedIn User Profile

      const path = AppApiRoutes.fetchChatConnections;

      final response = await networkProvider.call(
        path: path,
        method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final dynamicList = response.data["extra"] as List<dynamic>;
        final list = List<ChatConnectionModel>.from(dynamicList.map((x) => ChatConnectionModel.fromJson(x!)));
        return Right(list);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }catch(error) {
      return Left(error.toString());
    }
  }

  Future<ChatConnectionModel?> getChatConnectionById({required int chatConnectionId}) async {

    try {

      final path = AppApiRoutes.getChatConnection(chatConnectionId);
      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return null;
        }

        final data = response.data["extra"];
        final connection = ChatConnectionModel.fromJson(data);
        return connection;

      } else {
        return null;
      }

    }catch(e) {
      return null;
    }

  }



}