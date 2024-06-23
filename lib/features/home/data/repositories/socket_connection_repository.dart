import 'dart:convert';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:sparkduet/core/app_storage.dart';
import 'package:sparkduet/network/api_routes.dart';

class SocketConnectionRepository {

  final AppStorage localStorageProvider;
  PusherChannelsFlutter? pusher;
  ably.Realtime? realtimeInstance;

  SocketConnectionRepository({ required this.localStorageProvider });


  Future<PusherChannelsFlutter?> getWebSocketConnection({Function(PusherEvent event)? onEvent}) async {

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
              if(event.eventName == "pusher:subscription_succeeded"){
                debugPrint("pusher: subscribed to channel: ${event.channelName}");
                return;
              }
              //{ channelName: users.1.general-notifications, eventName: pusher:subscription_succeeded, data: {}, userId: null }
              debugPrint("Pusher: onEvent: ${event.data}");
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
      return pusher;
    } catch (e) {
      debugPrint("Pusher: ERROR: $e");
      return null;
    }

  }

  Future<ably.Realtime?> createAblyRealtimeInstance() async {
    if(realtimeInstance == null) {
      final ablyKey = dotenv.env['ABLY_APP_KEY'] ?? '';
      // Connect to Ably with your API key
      final clientOptions = ably.ClientOptions(key: ablyKey,);
      realtimeInstance = ably.Realtime(options: clientOptions);
      realtimeInstance?.connection.on(ably.ConnectionEvent.connected).listen((ably.ConnectionStateChange stateChange) {
        debugPrint('Ably connection state is: ${stateChange.current}');
        switch (stateChange.current) {
          case ably.ConnectionState.connected:
            debugPrint('Connected to Ably!');
            break;
          case ably.ConnectionState.failed:
            debugPrint('The connection to Ably failed.');
            // Failed connection
            break;
          case ably.ConnectionState.initialized:
            debugPrint('The connection to Ably initialized.');
            break;
          case ably.ConnectionState.connecting:
            debugPrint('The connection to Ably is connecting.');
            break;
          case ably.ConnectionState.disconnected:
            debugPrint('The connection to Ably disconnected.');
            break;
          case ably.ConnectionState.suspended:
            debugPrint('The connection to Ably suspended.');
            break;
          case ably.ConnectionState.closing:
            debugPrint('The connection to Ably is closing.');
            break;
          case ably.ConnectionState.closed:
            debugPrint('The connection to Ably closed.');
            break;
        }


        // // Create a channel called 'get-started' and register a listener to subscribe to all messages with the name 'first'

        // Publish a message with the name 'first' and the contents 'Here is my first message!'
        // await channel.publish(name: 'first', data: "Here is my first message!");

        // Close the connection to Ably
        // realtimeInstance.connection.close();
        // realtimeInstance.connection
        //     .on(ably.ConnectionEvent.closed)
        //     .listen((ably.ConnectionStateChange stateChange) async {
        //   debugPrint('New state is: ${stateChange.current}');
        //   switch (stateChange.current) {
        //     case ably.ConnectionState.closed:
        //       print('Closed connection to Ably.');
        //       break;
        //     case ably.ConnectionState.failed:
        //       break;
        //   }
        // });
      });
    }

    return realtimeInstance;
  }

}