import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/models/post_feed_request.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';

part 'feed_state.g.dart';

@CopyWith()
class FeedState extends Equatable {

  final FeedStatus status;
  final String? message;
  final List<FeedModel>  feeds;
  final PostFeedRequest postFeedRequest;

  const FeedState({
    this.status = FeedStatus.initial,
    this.message,
    this.feeds = const  [],
    this.postFeedRequest = const PostFeedRequest()
  });

  @override
  List<Object?> get props => [status, feeds];

}