import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:sparkduet/core/app_storage.dart';
import 'package:sparkduet/network/api_routes.dart';

class SocketConnectionRepository {

  final AppStorage localStorageProvider;
  PusherChannelsFlutter? pusher;

  SocketConnectionRepository({ required this.localStorageProvider });


  Future<PusherChannelsFlutter?> getWebSocketConnection(String channel, {Function(PusherEvent event)? onEvent}) async {

    try {
      if(pusher == null) {
        pusher = PusherChannelsFlutter.getInstance();
        final pusherKey = dotenv.env['PUSHER_APP_KEY'] ?? '';
        final pusherCluster = dotenv.env['PUSHER_APP_CLUSTER'] ?? '';
        await pusher?.init(
            apiKey: pusherKey,
            cluster: pusherCluster,
            // authParams: {
            //   'params': { 'foo': 'bar' },
            //   'headers': { 'X-CSRF-Token': 'SOME_CSRF_TOKEN' }
            // },
            onConnectionStateChange: (currentState, previousState) {
              debugPrint("Pusher: onConnectionStateChange: previousState: $previousState -> currentState : $currentState");
            },
            onError: (String message, int? code, dynamic error) {
              debugPrint("Pusher: onError: $error");
            },
            onSubscriptionSucceeded: (String channelName, dynamic data) {
              debugPrint("Pusher: onSubscriptionSucceeded: $channelName");
              debugPrint("Pusher: data: $data");
            },
            onEvent: (PusherEvent event) {
              // debugPrint("Pusher: onEvent: ${event.data}");
              onEvent?.call(event);
            },
            onSubscriptionError: (String message, dynamic error) {
              debugPrint("Pusher: onSubscriptionError: $error");
            },
            onMemberAdded: (String channelName, PusherMember member) {
              debugPrint("Pusher:onMemberAdded: $channelName user: $member");
            },
            onMemberRemoved: (String channelName, PusherMember member) {
              debugPrint("Pusher: onMemberRemoved: $channelName user: $member");
            }
        );
        await pusher?.connect();
      }

      await pusher?.subscribe(channelName: channel);
      return pusher;
    } catch (e) {
      debugPrint("Pusher: ERROR: $e");
      return null;
    }

  }

}