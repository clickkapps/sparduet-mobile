import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/features/feeds/data/models/feed_broadcast_event.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_broadcast_repository.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_repository.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_previews_state.dart';
import 'package:sparkduet/features/files/data/repositories/file_repository.dart';

class FeedsPreviewsCubit extends Cubit<FeedsPreviewsState> {

  final FeedRepository feedRepository;
  final FileRepository fileRepository;
  final FeedBroadcastRepository feedBroadcastRepository;
  StreamSubscription<FeedBroadCastEvent>? feedBroadcastRepositoryStreamListener;
  FeedsPreviewsCubit(this.fileRepository, {required this.feedRepository, required this.feedBroadcastRepository}): super(const FeedsPreviewsState()) {
    listenForFeedUpdate();
  }


  /// This method updates feed when there's a change in state
  void listenForFeedUpdate() async {

    await feedBroadcastRepositoryStreamListener?.cancel();
    feedBroadcastRepositoryStreamListener = feedBroadcastRepository.stream.listen((FeedBroadCastEvent event) {

      // update the corresponding feed
      // if the feed is deleted update it (deletedAtField is updated)
      if(event.action == FeedBroadcastAction.update || event.action == FeedBroadcastAction.delete){

        // if(event.feed?.id == state.feed?.id){
        //   emit(state.copyWith(feed: event.feed));
        // }

      }

    });
  }

  void setFeeds(List<FeedModel> feeds) {
    emit(state.copyWith(status: FeedStatus.setFeedInProgress));
    emit(state.copyWith(status: FeedStatus.setFeedCompleted, feeds: feeds));
  }

  @override
  Future<void> close() async {
    feedBroadcastRepositoryStreamListener?.cancel();
    super.close();
  }


}