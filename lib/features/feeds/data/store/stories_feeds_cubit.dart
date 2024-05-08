import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';

class StoriesFeedsCubit extends FeedsCubit {
  StoriesFeedsCubit(super.fileRepository, {required super.feedsRepository, required super.feedBroadcastRepository});
}