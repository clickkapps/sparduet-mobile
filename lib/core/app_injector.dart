import 'package:get_it/get_it.dart';
import 'package:sparkduet/core/app_storage.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_broadcast_repository.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_broadcast_repository.dart';
import 'package:sparkduet/features/home/data/repositories/socket_connection_repository.dart';
import 'package:sparkduet/network/network_provider.dart';

/// Using Get It as the service locator -> for dependency injections
final sl = GetIt.instance;

/// Initializes all dependencies.
/// We register as lazy singletons to boost performance
/// meaning, Get It would instantiate objects on demand
Future<void> init() async {

  sl.registerLazySingleton(() => NetworkProvider());
  sl.registerLazySingleton(() => AppStorage());
  sl.registerLazySingleton(() => FeedBroadcastRepository());
  sl.registerLazySingleton(() => ChatBroadcastRepository());
  // sl.registerLazySingleton(() => EngagedFeedBroadcastRepository());
  sl.registerLazySingleton(() => SocketConnectionRepository(localStorageProvider: sl()));

}



