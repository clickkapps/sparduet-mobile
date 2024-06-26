import 'package:dartz/dartz.dart';
import 'package:sparkduet/features/notifications/data/models/notification_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';

class NotificationsRepository {
  final NetworkProvider networkProvider;
  const NotificationsRepository({required this.networkProvider});

  Future<Either<String, num>> countUnseenNotifications() async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.countUnseenNotifications;

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

  Future<Either<String, void>> markNotificationsAsSeen() async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.markNotificationsAsSeen;


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

    }  catch (e) {
      return Left(e.toString());
    }


  }

  Future<Either<String, void>> markNotificationAsRead({required int? notificationId}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.markNotificationAsRead(id: notificationId);

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

    }  catch (e) {
      return Left(e.toString());
    }


  }


  Future<Either<String, List<NotificationModel>>> fetchNotifications({int? pageKey}) async {

    try {

      // by default it fetches the current loggedIn User Profile
      final path = AppApiRoutes.fetchNotifications;

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
        final list = List<NotificationModel>.from(dynamicList.map((x) => NotificationModel.fromJson(x)));

        return  Right(list);

      } else {
        return Left(response.statusMessage ?? "");
      }

    }  catch (e) {
      return Left(e.toString());
    }


  }

}