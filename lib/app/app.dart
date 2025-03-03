import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparkduet/app/routing/routes.dart';
import 'package:sparkduet/core/app_injector.dart';
import 'package:sparkduet/features/auth/data/repositories/auth_repository.dart';
import 'package:sparkduet/features/auth/data/store/auth_bookmarked_feeds_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_feeds_cubit.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_broadcast_repository.dart';
import 'package:sparkduet/features/chat/data/repositories/chat_repository.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/features/countries/data/repositories/countries_repository.dart';
import 'package:sparkduet/features/countries/data/store/countries_cubit.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_broadcast_repository.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_repository.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_previews_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/stories_feeds_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/stories_previews_cubit.dart';
import 'package:sparkduet/features/files/data/repositories/file_repository.dart';
import 'package:sparkduet/features/home/data/repositories/home_broadcast_repository.dart';
import 'package:sparkduet/features/home/data/store/home_cubit.dart';
import 'package:sparkduet/features/home/data/store/nav_cubit.dart';
import 'package:sparkduet/features/home/data/repositories/socket_connection_repository.dart';
import 'package:sparkduet/features/notifications/data/repositories/notifications_repository.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_cubit.dart';
import 'package:sparkduet/features/preferences/data/repositories/preferences_repository.dart';
import 'package:sparkduet/features/preferences/data/store/preferences_cubit.dart';
import 'package:sparkduet/features/search/data/repositories/search_repository.dart';
import 'package:sparkduet/features/search/data/store/search_cubit.dart';
import 'package:sparkduet/features/subscriptions/data/repositories/subscription_repository.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/theme/data/repositories/theme_repository.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/features/theme/data/store/theme_state.dart';
import 'package:sparkduet/features/users/data/repositories/user_repository.dart';
import 'package:sparkduet/features/users/data/store/user_bookmarked_feeds_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_feeds_cubit.dart';

import '../features/chat/data/store/chat_preview_cubit.dart';

/// Everyone deserves love
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    final appName = dotenv.env['APP_NAME'] ?? '';

    final authRepository = AuthRepository(networkProvider: sl(), localStorageProvider: sl());
    final themeRepository = ThemeRepository(networkProvider: sl(), localStorageProvider: sl());
    final fileRepository = FileRepository(networkProvider: sl());
    final feedBroadcastRepository = sl<FeedBroadcastRepository>();
    final feedRepository = FeedRepository(networkProvider: sl());
    final countriesRepository = CountriesRepository(networkProvider: sl());
    final searchRepository = SearchRepository(networkProvider: sl());
    final chatRepository = ChatRepository(networkProvider: sl());
    final userRepository = UserRepository(networkProvider: sl());
    final preferencesRepository = PreferencesRepository(networkProvider: sl());
    final chatBroadcastRepository = sl<ChatBroadcastRepository>();
    final socketRepository = sl<SocketConnectionRepository>();
    final homeBroadcastRepository = sl<HomeBroadcastRepository>();
    final notificationsRepository = NotificationsRepository(networkProvider: sl());
    final subscriptionRepository = SubscriptionRepository(networkProvider: sl());

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => HomeCubit(socketConnectionRepository: socketRepository, homeBroadcastRepository: homeBroadcastRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => AuthCubit(authRepository: authRepository, fileRepository: fileRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => ThemeCubit(themeRepository: themeRepository)),
          BlocProvider(create: (context) => FeedsCubit(fileRepository: fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => StoriesFeedsCubit(fileRepository: fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => AuthFeedsCubit(fileRepository: fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => UserFeedsCubit(fileRepository: fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => AuthBookmarkedFeedsCubit(fileRepository: fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => UserBookmarkedFeedsCubit(fileRepository: fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => FeedsPreviewsCubit(fileRepository: fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => StoriesPreviewsCubit(fileRepository: fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => NavCubit()),
          BlocProvider(create: (context) => CountriesCubit(countriesRepository: countriesRepository)),
          BlocProvider(create: (context) => SearchCubit(searchRepository: searchRepository)),
          BlocProvider(create: (context) => ChatConnectionsCubit(chatRepository: chatRepository, chatBroadcastRepository: chatBroadcastRepository, socketConnectionRepository: socketRepository)),
          BlocProvider(create: (context) => ChatPreviewCubit(chatRepository: chatRepository, chatBroadcastRepository: chatBroadcastRepository, socketConnectionRepository: socketRepository, fileRepository: fileRepository)),
          BlocProvider(create: (context) => UserCubit(userRepository: userRepository, socketConnectionRepository: socketRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => PreferencesCubit(preferencesRepository: preferencesRepository)),
          BlocProvider(create: (context) => NotificationsCubit(notificationsRepository: notificationsRepository, socketConnectionRepository: socketRepository)),
          BlocProvider(create: (context) => SubscriptionCubit(subscriptionRepository: subscriptionRepository)),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              title: appName,
              debugShowCheckedModeBanner: false,
              theme: themeState.themeData,
              routerConfig: router,
              // routeInformationParser: router.routeInformationParser,
              // routerDelegate: router.routerDelegate,
              // routeInformationProvider: router.routeInformationProvider,
              // routeInformationParser: router.routeInformationParser,
              // routerDelegate: router.routerDelegate,

              builder: (ctx, widget) => _InitializeApp(child: widget ?? const SizedBox.shrink()),
            );
          },
        ),
    );
  }
}



class _InitializeApp extends StatefulWidget {

  final Widget child;
  const _InitializeApp({super.key, required this.child});

  @override
  State<_InitializeApp> createState() => _InitializeAppState();
}

class _InitializeAppState extends State<_InitializeApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}