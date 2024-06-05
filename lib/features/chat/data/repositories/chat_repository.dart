import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_user_model.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

final chatsRef = FirebaseFirestore.instance.collection('chats').withConverter<ChatModel>(
  fromFirestore: (snapshot, _) => ChatModel.fromJson(snapshot.data()!),
  toFirestore: (chat, _) => chat.toJson(),
);

// final messagesRef = (String chatId) => ;
CollectionReference<MessageModel> messagesRef({required String chatId}) {
  return FirebaseFirestore.instance.collection('chats/$chatId/messages').withConverter<MessageModel>(
    fromFirestore: (snapshot, _) => MessageModel.fromJson(snapshot.data()!),
    toFirestore: (message, _) => message.toJson(),
  );
}

class ChatRepository {

  final NetworkProvider networkProvider;
  const ChatRepository({required this.networkProvider});


  Future<Either<String, List<QueryDocumentSnapshot<MessageModel>>>>? fetchMessages({required ChatModel chatConnection, GetOptions? options}) async {

    try {

      final query = messagesRef(chatId: chatConnection.id ?? "").where("deleted", isEqualTo: false);
      final messagesList = await query.get(options).then((snapshot) => snapshot.docs);
      return Right(messagesList);

    }catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Stream<QuerySnapshot<MessageModel>>>> listenToMessages({required ChatModel chatConnection}) async {
    try {

      final query = messagesRef(chatId: chatConnection.id ?? '').where("deleted", isEqualTo: false);
      final messagesStream = query.snapshots();
      return Right(messagesStream);

    }catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>>? sendMessage({required DocumentReference doc, required MessageModel thisMessage}) async {

    try {

      doc.set(thisMessage);
      
      return const Right(null);

    }catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>>? deleteMessage({required ChatModel chatConnection, required MessageModel message}) async {

    try {

      // final docId = generateChatId(message.sentBy?.id ?? '', message.sentTo?.id ?? '');
      await messagesRef(chatId: chatConnection.id!).doc(message.id).set(message);
      return const Right(null);

    }catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ChatModel>> createChatConnection(AuthUserModel authUser, ChatUserModel otherParticipant) async {

    try {

      final thisParticipant = ChatUserModel.fromJson(authUser.toJson());

      // check if there's a chat connection with both participants
      final query = chatsRef.where("participantIds", arrayContains: thisParticipant.id);
      final q  = await query.get();

      late ChatModel chat;
      if(q.docs.isEmpty) {
        chat = _createChat(thisParticipant: thisParticipant, otherParticipant: otherParticipant);
      }else {
          final chatList = q.docs;
          final chatFound = chatList.where((element) => (element.data().participants?.where((el) => el.id == otherParticipant.id).firstOrNull) != null ).firstOrNull;
          chat = chatFound != null ? chatFound.data() : _createChat(thisParticipant: thisParticipant, otherParticipant: otherParticipant);
      }
      // final docId = generateChatId(currentUser.id ?? '', otherUser.id ?? '');
      // await chatsRef.doc(docId).set(ChatModel(
      //   id: docId,
      //   createdAt: DateTime.now(),
      //   participants: [
      //     thisParticipant, // other participant
      //     otherParticipant
      //   ],
      // ), SetOptions(merge: true));

       return  Right(chat);

    }catch(e) {
      return Left(e.toString());
    }

  }

  ChatModel _createChat({required ChatUserModel thisParticipant, required ChatUserModel otherParticipant}) {
    final docRef = chatsRef.doc();

    final chat = ChatModel(
      id: docRef.id,
      createdAt: DateTime.now(),
      participants: [
        thisParticipant, // other participant
        otherParticipant
      ],
      participantIds: <int?>[
        thisParticipant.id,
        otherParticipant.id
      ]
    );
    chatsRef.doc(docRef.id).set(chat);
    return chat;
  }

  //const GetOptions(source: Source.cache)

  Future<Either<String, List<QueryDocumentSnapshot<ChatModel>>>>?  getChatChatConnections(AuthUserModel authUser, [GetOptions? options]) async {
    try{

      final currentUser = authUser;
      final query = chatsRef.where('participantIds', arrayContains: currentUser.id );
      // if(withAtLeastOneMessage) {
      //   query.where('lastMessage', isNotEqualTo: null);
      // }
      final chatList = await query.get(options).then((snapshot) => snapshot.docs);

      return Right(chatList);

    }catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Stream<QuerySnapshot<ChatModel>>>>?  listenToChatConnections(AuthUserModel authUser) async {
    try{

      final currentUser = authUser;

      final query = chatsRef.where('participantIds', arrayContains: currentUser.id );

      final chatStream = query.snapshots();

      return Right(chatStream);

    }catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> markChatConnectionAsRead(AuthUserModel authUser, ChatModel chatConnection) async {
    try{

      final chatConnectionId = chatConnection.id;

      final document = await chatsRef.doc(chatConnectionId).get();
      final chat = document.data();
      final thisParticipantIndex = chat?.participants?.indexWhere((element) => element.id == authUser.id);
      if((thisParticipantIndex ?? -1) < 0) {
        return const Left("Unknown participant");
      }
      final participants = chat?.participants ?? [];
      final thisParticipant = participants[thisParticipantIndex!];
      final modifiedThisParticipant = thisParticipant.copyWith(
        unreadMessages: 0
      );
      participants[thisParticipantIndex] = modifiedThisParticipant;
      final modifiedChat = chat?.copyWith(
        participants: participants
      );
      chatsRef.doc(chatConnectionId).set(modifiedChat!, SetOptions(merge: true));
      return const Right(null);

    }catch(e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> markOtherParticipantMessageAsRead(ChatModel chatConnection) async {

    try{

      /// To Fix. Its cause flicking of chats
      // final currentUser = AppStorage.currentUserSession;
      // final query = messagesRef(chatId: chatConnection.id ?? "").where("seen", isEqualTo: false);
      // final unSeenMessagesList = await query.get().then((snapshot) => snapshot.docs);
      // final thisUserUnseenMessageList = unSeenMessagesList.where((element) => element.data().sentTo?.id == currentUser?.id).toList();
      // for (final element in thisUserUnseenMessageList) {
      //   final docId = element.id;
      //   final message = element.data();
      //   final modifiedMessage = message.copyWith(
      //       seen: true,
      //       // createdAt: message.createdAt
      //   );
      //   messagesRef(chatId: chatConnection.id ?? "").doc(docId).set(modifiedMessage, SetOptions(merge: true));
      // }

      return const Right(null);

    }catch(e) {
      return Left(e.toString());
    }

  }

  Future<ChatModel?> getChatConnectionById({required String chatConnectionId}) async {
    final document = await chatsRef.doc(chatConnectionId).get();
    return document.data();
  }

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



}