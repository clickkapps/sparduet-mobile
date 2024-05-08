import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';

class UserBookmarkedFeedsCubit extends FeedsCubit {
  UserBookmarkedFeedsCubit(super.fileRepository, {required super.feedsRepository, required super.feedBroadcastRepository});
}