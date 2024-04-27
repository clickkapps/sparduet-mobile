import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';

class FeedBroadCastEvent {
  final FeedBroadcastAction action;
  final FeedModel? feed;
  final dynamic data;
  const FeedBroadCastEvent({required this.action, this.feed, this.data});
}