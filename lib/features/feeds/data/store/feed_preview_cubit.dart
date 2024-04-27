import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/features/feeds/data/models/feed_broadcast_event.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_broadcast_repository.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_repository.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_preview_state.dart';
import 'package:sparkduet/features/files/data/repositories/file_repository.dart';

class FeedPreviewCubit extends Cubit<FeedPreviewState> {

  final FeedRepository feedRepository;
  final FileRepository fileRepository;
  final FeedBroadcastRepository feedBroadcastRepository;
  StreamSubscription<FeedBroadCastEvent>? feedBroadcastRepositoryStreamListener;
  FeedPreviewCubit(this.fileRepository, {required this.feedRepository, required this.feedBroadcastRepository}): super(const FeedPreviewState()) {
    listenForFeedUpdate();
  }


  /// This method updates feed when there's a change in state
  void listenForFeedUpdate() async {

    await feedBroadcastRepositoryStreamListener?.cancel();
    feedBroadcastRepositoryStreamListener = feedBroadcastRepository.stream.listen((FeedBroadCastEvent event) {

      // update the corresponding feed
      // if the feed is deleted update it (deletedAtField is updated)
      if(event.action == FeedBroadcastAction.update || event.action == FeedBroadcastAction.delete){

        if(event.feed?.id == state.feed?.id){
          emit(state.copyWith(feed: event.feed));
        }

      }

    });
  }

  @override
  Future<void> close() async {
    feedBroadcastRepositoryStreamListener?.cancel();
    super.close();
  }


}