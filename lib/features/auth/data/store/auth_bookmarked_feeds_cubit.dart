import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';

class AuthBookmarkedFeedsCubit extends FeedsCubit {
  AuthBookmarkedFeedsCubit(super.fileRepository, {required super.feedsRepository, required super.feedBroadcastRepository});
}