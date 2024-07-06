import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/presentation/pages/auth_profile_page.dart';
import 'package:sparkduet/features/auth/presentation/pages/auth_user_location_page.dart';
import 'package:sparkduet/features/auth/presentation/pages/login_page.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/presentation/pages/chat_connections_page.dart';
import 'package:sparkduet/features/chat/presentation/pages/chat_preview_page.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_purpose.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/feed_editor_camera_page.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_feeds_page.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_previews_page.dart';
import 'package:sparkduet/features/home/presentation/pages/home_page.dart';
import 'package:sparkduet/features/preferences/presentation/pages/preferences_page.dart';
import 'package:sparkduet/features/search/presentation/pages/top_search_page.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/presentation/pages/user_profile_page.dart';
import 'package:sparkduet/utils/custom_photo_gallery_page.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _inboxNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _createPostNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _profileNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _prefNavigatorKey = GlobalKey<NavigatorState>();
// final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();
// final RouteObserver<PageRoute<dynamic>> routeObserver = RouteObserver<PageRoute<dynamic>>();
final RouteObserver<ModalRoute<void>> storiesPageRouteObserver = RouteObserver<ModalRoute<void>>();
final RouteObserver<ModalRoute<void>> homePageRouteObserver = RouteObserver<ModalRoute<void>>();
final RouteObserver<ModalRoute<void>> storiesPreviewPageRouteObserver = RouteObserver<ModalRoute<void>>();
// final CustomRouteObserver routeObserver = CustomRouteObserver();
// Add more navigator keys for additional tabs

/// Guest Routes
final List<String> guestRoutes = [
  AppRoutes.login,
];

final router = GoRouter(
  redirect: (BuildContext context, state)  async {

    // allow all guest route navigation
    if(guestRoutes.contains(state.matchedLocation)) {
      return null;
    }

    //! protected routes
    AuthUserModel? user  = await context.read<AuthCubit>().getCurrentUserSession();
    if(user == null) {
      return AppRoutes.login;
    }

    if((user.info?.preferredNationalities ?? "").isEmpty) {
      return AppRoutes.location;
    }

    return null;
  },
  initialLocation: AppRoutes.home,
  navigatorKey: rootNavigatorKey,
  routes: [

    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const AuthLoginPage(),
    ),

    // GoRoute(
    //   path: AppRoutes.camera,
    //   parentNavigatorKey: rootNavigatorKey,
    //   builder: (context, state) {
    //     final map = state.extra as Map<String, dynamic>;
    //     final cameras = map['cameras'] as List<CameraDescription>;
    //     final feedPurpose = map["feedPurpose"] as PostFeedPurpose?;
    //     return FeedEditorCameraPage(cameras: cameras, purpose: feedPurpose,);
    //   },
    // ),

    //! extra: -> images (list of files / list of imageUrls), initialIndex (optional)
    GoRoute(
      path: AppRoutes.photoGalleryPage,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        PhotoFileSource fileSource = PhotoFileSource.url;
        if(extra['images'] is List<File>) {
          fileSource = PhotoFileSource.file;
        }

        final initialPageIndex = extra['initialIndex'] as int?;
        final showProgressText = extra['showProgressText'] as bool?;
        return CustomTransitionPage(
          fullscreenDialog: true,
          opaque: false,
          arguments: extra,
          name: state.fullPath,
          transitionsBuilder: (_, __, ___, child) => child,
          child: CustomPhotoGalleryPage(
            urls: fileSource == PhotoFileSource.url ? extra['images'] as List<String> : null,
            files: fileSource == PhotoFileSource.file ? extra['images'] as List<File> : null,
            fileSource: fileSource,
            initialPageIndex: initialPageIndex ?? 0,
            showProgressText: showProgressText ?? true,
          ),
        );
      },
    ),


    // Chate preview page
    // GoRoute(
    //   path: AppRoutes.chatPreview,
    //   parentNavigatorKey: rootNavigatorKey,
    //   pageBuilder: (context, state) {
    //
    //     late UserModel opponent;
    //     ChatConnectionModel? chatConnection;
    //     if(state.extra is Map<String, dynamic>) {
    //       final map = state.extra as Map<String, dynamic>;
    //        chatConnection = map["connection"] as ChatConnectionModel?;
    //        opponent = map["user"] as UserModel;
    //     }else {
    //       opponent = state.extra as UserModel;
    //     }
    //
    //     return  MaterialPage(name: state.path, arguments: state.extra,
    //         child: ChatPreviewPage(opponent: opponent, connection: chatConnection,)
    //     );
    //   },
    // ),

    GoRoute(
      path: AppRoutes.location,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        return  MaterialPage(name: state.path, arguments: state.extra,
            child: const AuthUserLocationPage(fetchFeedsOnSuccess: true,)
        );
      },
    ),

    GoRoute(
      path: AppRoutes.feedPreviewPage,
      // parentNavigatorKey: _rootNavigator,
      pageBuilder: (context, state) {
        final map = state.extra as Map<String, dynamic>;
        final feeds = map["feeds"] as List<FeedModel>;
        final initialIndex = map["initialIndex"] as int?;
        return  MaterialPage(name: state.path, arguments: state.extra,
            child:  StoriesPreviewsPage(feeds: feeds, initialFeedIndex: initialIndex ?? 0, )
        );
      },

    ),

    GoRoute(
      path: AppRoutes.searchPage,
      pageBuilder: (context, state) {
        return  MaterialPage(name: state.path, arguments: state.extra,
            child: const TopSearchPage()
        );
      },
    ),


    /// Home page shell
    StatefulShellRoute.indexedStack(
      // navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return HomePage(navigatorKeys: [
          _homeNavigatorKey,
          _inboxNavigatorKey,
          _createPostNavigatorKey,
          _profileNavigatorKey,
          _prefNavigatorKey
        ],child: child,);
      },
      branches: [
        // The route branch for the 1º Tab

        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          observers: [storiesPageRouteObserver],
          routes: <RouteBase>[
            // Add this branch routes
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (ctx, state) => NoTransitionPage(child: const StoriesFeedsPage(), name: state.path,  arguments: state.extra),

            ),
          ],
        ),

        // The route branch for 2º Tab
        StatefulShellBranch(
          // observers: [routeObserver],
          navigatorKey: _inboxNavigatorKey,
          // Add this branch routes
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.inbox,
              pageBuilder: (ctx, state) => NoTransitionPage(child: const ChatConnectionsPage(), name: state.path, arguments: state.extra),
            ),
          ],
        ),

        StatefulShellBranch(
          // observers: [routeObserver],
          navigatorKey: _profileNavigatorKey,
          routes: <RouteBase>[
          // Add this branch routes
          GoRoute(
              path: AppRoutes.authProfile,
              pageBuilder: (ctx, state) {

                final map = state.extra is Map<String,dynamic> ? state.extra as Map<String,dynamic>? : null;
                final bool focusOnYourPosts  = (map?["focusOnYourPosts"] as bool?) ?? false;
                final bool focusOnBookmarks = (map?["focusOnBookmarks"] as bool?) ?? false;
                return NoTransitionPage(child:  AuthProfilePage(focusOnBookmarks: focusOnBookmarks,focusOnYourPosts: focusOnYourPosts,), name: state.fullPath, arguments: state.extra);

              }
          ),
        ],
        ),

        StatefulShellBranch(
          // observers: [routeObserver],
          navigatorKey: _prefNavigatorKey,
          routes: <RouteBase>[
          // Add this branch routes
          GoRoute(
            path: AppRoutes.preferences,
            pageBuilder: (ctx, state) => NoTransitionPage(child: const PreferencesPage(), name: state.fullPath, arguments: state.extra),
          ),
        ], ),
      ],
    ),

  ],
  observers: [homePageRouteObserver, storiesPreviewPageRouteObserver]
);