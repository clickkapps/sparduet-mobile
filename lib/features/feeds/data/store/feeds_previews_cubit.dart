import 'dart:async';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';

class FeedsPreviewsCubit extends FeedsCubit {

  FeedsPreviewsCubit({required super.fileRepository, required super.feedsRepository, required super.feedBroadcastRepository});

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