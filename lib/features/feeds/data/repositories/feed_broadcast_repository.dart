import 'dart:async';

import 'package:sparkduet/features/feeds/data/models/feed_broadcast_event.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';


class FeedBroadcastRepository {
  final _feedBroadcastController = StreamController<FeedBroadCastEvent>.broadcast();
  Stream<FeedBroadCastEvent> get stream => _feedBroadcastController.stream;

  void updateFeed({required FeedModel feed}) {
    _feedBroadcastController.sink.add(FeedBroadCastEvent(action: FeedBroadcastAction.update, feed: feed));
  }

  void addFeed({required FeedModel feed}) {
    _feedBroadcastController.sink.add(FeedBroadCastEvent(action: FeedBroadcastAction.add, feed: feed));
  }

  void deleteFeed({required FeedModel feed}) {
    _feedBroadcastController.sink.add(FeedBroadCastEvent(action: FeedBroadcastAction.delete, feed: feed));
  }

  void updateFeedCensorship({required int? feedId, String? disAction}) {
    _feedBroadcastController.sink.add(FeedBroadCastEvent(action: FeedBroadcastAction.censorUpdated, data: {'id': feedId, 'action': disAction}));
  }

}