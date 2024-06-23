import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';

class ChatRepository {

  final NetworkProvider networkProvider;
  final Box<ChatMessageModel> chatMessagesBox = Hive.box<ChatMessageModel>(AppConstants.kChatMessages);
  final Box<ChatConnectionModel> chatConnectionsBox = Hive.box<ChatConnectionModel>(AppConstants.kChatConnections);

  ChatRepository({required this.networkProvider});

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

  void refreshAllChatMessagesInCache({required int? connectionId, required List<ChatMessageModel> chatMessages}) async {
    // final chatsKeys = box.keys;
    final keysToDelete = <int>[];
    for (var entry in chatMessagesBox.toMap().entries) {
      if(entry.value.chatConnectionId == connectionId){
        keysToDelete.add(entry.key);
      }
    }
    chatMessagesBox.deleteAll(keysToDelete);
    chatMessagesBox.addAll(chatMessages);

  }

  void refreshAllChatConnectionsInCache(List<ChatConnectionModel> recipients) async {
    await chatConnectionsBox.clear();
    chatConnectionsBox.addAll(recipients);
  }

  // get data from cache
  Future<List<ChatMessageModel>> fetchChatMessagesFromCache({required int? connectionId}) async {
    // Retrieve data from cache first
    final cachedMessagesList = chatMessagesBox.values.where((element) => element.chatConnectionId == connectionId).toList();
    return cachedMessagesList;
  }

  Future<List<ChatConnectionModel>> fetchChatConnectionsFromCache() async {
    // Retrieve data from cache first
    final cachedConnectionsList = chatConnectionsBox.values.toList();
    return cachedConnectionsList;
  }

  void closeMessagesBox() {
    chatMessagesBox.close();
  }
  void clearChatMessages() {
    chatMessagesBox.clear();
  }
  void closeConnectionBox() {
    chatConnectionsBox.close();
  }
  void clearChatConnections() {
    chatConnectionsBox.clear();
  }

  Future<Either<String, ChatMessageModel>>? sendMessage({required int? chatConnectionId, required ChatMessageModel message}) async {

    try {

      const path = AppApiRoutes.sendChatMessage;
      final body = {
        "chat_connection_id": chatConnectionId,
        "sent_by_id": message.sentById,
        "sent_to_id": message.sentToId,
        "client_id": message.clientId,
        "text": message.text,
        "parent_id": message.parent?.id
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

        final json = response.data["extra"] as Map<String, dynamic>;
        final serverMessage = ChatMessageModel.fromJson(json);

        // add to chat messages in cache
        chatMessagesBox.add(serverMessage);

        return Right(serverMessage);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }catch(e) {
      return Left(e.toString());
    }

  }

  Future<Either<String, ChatMessageModel>>? deleteMessage({required int? messageId, required int? opponentId}) async {

    try {

      const path = AppApiRoutes.sendChatMessage;
      final body = {
        "opponent_id": opponentId,
        "message_id": messageId,
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

        final json = response.data["extra"] as Map<String, dynamic>;
        final serverMessage = ChatMessageModel.fromJson(json);
        return Right(serverMessage);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }catch(e) {
      return Left(e.toString());
    }

  }

  Future<Either<String, List<ChatMessageModel>>>  fetchMessages({required int? chatConnectionId, required int? pageKey }) async {
    try {

      const path = AppApiRoutes.fetchChatMessages;
      final queryParams = {
        "conn_id": chatConnectionId,
        "limit": 15,
        "page": pageKey
      };

      final response = await networkProvider.call(
        path: path,
        method: RequestMethod.get,
        queryParams: queryParams
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final dynamicList = response.data["extra"]["data"] as List<dynamic>;
        final list = List<ChatMessageModel>.from(dynamicList.map((x) => ChatMessageModel.fromJson(x!)));

        if(pageKey == 1) {
          refreshAllChatMessagesInCache(connectionId: chatConnectionId, chatMessages: list);
        }

        return Right(list);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }catch(error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<ChatConnectionModel>>>  fetchChatConnections({ required int? pageKey }) async {
    try {

      const path = AppApiRoutes.fetchChatConnections;
      final queryParams = {
        "limit": 15,
        "page": pageKey
      };

      final response = await networkProvider.call(
        path: path,
        method: RequestMethod.get,
        queryParams: queryParams
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return Left(response.data["message"] as String);
        }

        final dynamicList = response.data["extra"]["data"] as List<dynamic>;
        final list = List<ChatConnectionModel>.from(dynamicList.map((x) => ChatConnectionModel.fromJson(x!)));

        if(pageKey == 1) {
          refreshAllChatConnectionsInCache(list);
        }

        return Right(list);

      } else {
        return Left(response.statusMessage ?? "");
      }


    }catch(error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, void>> markMessagesRead({required int? connectionId, required int? opponentId}) async {

    try {

      const path = AppApiRoutes.markChatMessagesAsRead;
      final body = {
        "chat_connection_id": connectionId,
        "opponent_id": opponentId,
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

    }catch(e) {
      return Left(e.toString());
    }

  }

}