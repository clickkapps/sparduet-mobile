import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/presentation/pages/auth_profile_page.dart';
import 'package:sparkduet/features/auth/presentation/pages/login_page.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/presentation/pages/chat_connections_page.dart';
import 'package:sparkduet/features/chat/presentation/pages/chat_preview_page.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_purpose.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/feed_editor_camera_page.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_feeds_page.dart';
import 'package:sparkduet/features/home/presentation/pages/home_page.dart';
import 'package:sparkduet/features/preferences/presentation/pages/preferences_page.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/presentation/pages/user_profile_page.dart';
import 'package:sparkduet/utils/custom_photo_gallery_page.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey<NavigatorState>(debugLabel: 'root');

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

    return null;
  },
  initialLocation: AppRoutes.home,
  navigatorKey: _rootNavigator,
  routes: [

    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const AuthLoginPage(),
    ),

    GoRoute(
      path: AppRoutes.camera,
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) {
        final map = state.extra as Map<String, dynamic>;
        final cameras = map['cameras'] as List<CameraDescription>;
        final feedPurpose = map["feedPurpose"] as PostFeedPurpose?;
        return FeedEditorCameraPage(cameras: cameras, purpose: feedPurpose,);
      },
    ),

    //! extra: -> images (list of files / list of imageUrls), initialIndex (optional)
    GoRoute(
      path: AppRoutes.photoGalleryPage,
      parentNavigatorKey: _rootNavigator,
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
    GoRoute(
      path: AppRoutes.chatPreview,
      parentNavigatorKey: _rootNavigator,
      pageBuilder: (context, state) {

        final map = state.extra as Map<String, dynamic>;
        final chatConnection = map["connection"] as ChatConnectionModel?;
        final opponent = map["opponent"] as UserModel;

        return  MaterialPage(name: state.path, arguments: state.extra,
            child: ChatPreviewPage(opponent: opponent, connection: chatConnection,)
        );
      },
    ),

    /// Home page shell
    StatefulShellRoute.indexedStack(
      // navigatorKey: _shellNavigatorKey,

      builder: (BuildContext context, GoRouterState state, Widget child) {
        return HomePage(child: child);
      },
      branches: [
        // The route branch for the 1º Tab

        StatefulShellBranch(routes: <RouteBase>[
            // Add this branch routes
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (ctx, state) => NoTransitionPage(child: const StoriesFeedsPage(), name: state.path,  arguments: state.extra),

            ),
          ],
        ),

        // The route branch for 2º Tab
        StatefulShellBranch(
          // Add this branch routes
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.inbox,
              pageBuilder: (ctx, state) => NoTransitionPage(child: const ChatConnectionsPage(), name: state.path, arguments: state.extra),
            ),
          ],
        ),

        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          GoRoute(
              path: AppRoutes.authProfile,
              pageBuilder: (ctx, state) {
                final map = state.extra as Map<String,dynamic>?;
                final bool focusOnYourPosts  = (map?["focusOnYourPosts"] as bool?) ?? false;
                final bool focusOnBookmarks = (map?["focusOnBookmarks"] as bool?) ?? false;
                return NoTransitionPage(child:  AuthProfilePage(focusOnBookmarks: focusOnBookmarks,focusOnYourPosts: focusOnYourPosts,), name: state.fullPath, arguments: state.extra);
              }
          ),
        ],
        ),

        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          GoRoute(
            path: AppRoutes.preferences,
            pageBuilder: (ctx, state) => NoTransitionPage(child: const PreferencesPage(), name: state.fullPath, arguments: state.extra),
          ),
        ], ),
      ],
    ),

  ],
);