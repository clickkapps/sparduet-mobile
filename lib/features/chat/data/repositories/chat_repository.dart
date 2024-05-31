import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:dartz/dartz.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/network/network_provider.dart';

class ChatRepository {
  final NetworkProvider networkProvider;
  const ChatRepository({required this.networkProvider});

  Future<Either<String, CubeDialog>> createChatConnection(UserModel opponent) async {

    try {

      final opponentId = opponent.id;
      if(opponentId == null) {
        return const Left("Invalid opponent id");
      }

      CubeDialog newDialog = CubeDialog(
          CubeDialogType.PRIVATE,
          occupantsIds: [opponentId]);

      final createdDialog = await createDialog(newDialog);
      return  Right(createdDialog);

    }catch(e) {
      return Left(e.toString());
    }

  }

  Future<Either<String, PagedResult<CubeDialog>?>> fetchChatConnection() async {

    try {

      //If you want to retrieve only dialogs updated after some specific date time, you can use updated_at[gt] filter.
      //Map<String, dynamic> additionalParams = {
      //     'updated_at[gt]': 1583402980
      // };

      final PagedResult<CubeDialog>? pagedResult = await getDialogs();

      return  Right(pagedResult);

    }catch(e) {
      return Left(e.toString());
    }

  }

}