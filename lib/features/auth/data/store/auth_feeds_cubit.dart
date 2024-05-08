import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';

class AuthFeedsCubit extends FeedsCubit {
  AuthFeedsCubit(super.fileRepository, {required super.feedsRepository, required super.feedBroadcastRepository});
}