import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparkduet/app/routing/routes.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/core/app_injector.dart';
import 'package:sparkduet/features/auth/data/repositories/auth_repository.dart';
import 'package:sparkduet/features/auth/data/store/auth_bookmarked_feeds_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_feeds_cubit.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_broadcast_repository.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_repository.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/feed_preview_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/stories_feeds_cubit.dart';
import 'package:sparkduet/features/files/data/repositories/file_repository.dart';
import 'package:sparkduet/features/home/data/nav_cubit.dart';
import 'package:sparkduet/features/theme/data/repositories/theme_repository.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/features/theme/data/store/theme_state.dart';
import 'package:sparkduet/features/users/data/store/user_bookmarked_feeds_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_feeds_cubit.dart';

/// Everyone deserves love
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    final appName = dotenv.env['APP_NAME'] ?? '';

    final authRepository = AuthRepository(networkProvider: sl(), localStorageProvider: sl());
    final themeRepository = ThemeRepository(networkProvider: sl(), localStorageProvider: sl());
    final fileRepository = FileRepository();
    final feedBroadcastRepository = sl<FeedBroadcastRepository>();
    final feedRepository = FeedRepository(networkProvider: sl());

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(authRepository: authRepository)),
          BlocProvider(create: (context) => ThemeCubit(themeRepository: themeRepository)),
          BlocProvider(create: (context) => FeedsCubit(fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => StoriesFeedsCubit(fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => AuthFeedsCubit(fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => UserFeedsCubit(fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => AuthBookmarkedFeedsCubit(fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => UserBookmarkedFeedsCubit(fileRepository, feedsRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => FeedPreviewCubit(fileRepository, feedRepository: feedRepository, feedBroadcastRepository: feedBroadcastRepository)),
          BlocProvider(create: (context) => NavCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              title: appName,
              debugShowCheckedModeBanner: false,
              theme: themeState.themeData,
              routerConfig: router,
              builder: (ctx, widget) =>_InitializeApp(child: widget ?? const SizedBox.shrink()),
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