import 'dart:async';
import 'package:sparkduet/features/home/data/events/home_broadcast_event.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';


class HomeBroadcastRepository {

  final _controller = StreamController<HomeBroadcastEvent>.broadcast();
  Stream<HomeBroadcastEvent> get stream => _controller.stream;

  void realtimeServerNotificationReceived({required String channelId, required dynamic data}) {
    _controller.sink.add(HomeBroadcastEvent(identifier: channelId, action: HomeBroadcastAction.realtimeServerNotification, data: data));
  }

}