import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';

class UserFeedsCubit extends FeedsCubit {
  UserFeedsCubit(super.fileRepository, {required super.feedsRepository, required super.feedBroadcastRepository});
}