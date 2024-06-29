import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';

class AuthBookmarkedFeedsCubit extends FeedsCubit {
  AuthBookmarkedFeedsCubit({required super.fileRepository, required super.feedsRepository, required super.feedBroadcastRepository}) {

    feedBroadcastRepository.stream.listen((event) {

      final copiedFeeds = [...state.feeds];
      if(event.action == FeedBroadcastAction.update) {
        final feed = event.feed;
        if(feed == null){
          return;
        }

        /// if the bookmark was removed, remove from the list

        final feedIndex = copiedFeeds.indexWhere((element) => element.id == event.feed!.id);
        // feed was unbookmarked
        if(!(feed.hasBookmarked ?? false)) {
          if(feedIndex > -1){
            copiedFeeds.removeAt(feedIndex);
            refreshList(updatedFeeds: copiedFeeds);
          }
        }else {

          // feed bookmarked
          if(feedIndex < 0) {
            copiedFeeds.insert(0, feed);
            refreshList(updatedFeeds: copiedFeeds);
          }

        }


      }

    });
  }
}