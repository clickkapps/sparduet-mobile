import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/presentation/pages/auth_profile_page.dart';
import 'package:sparkduet/features/auth/presentation/pages/login_page.dart';
import 'package:sparkduet/features/chat/presentation/pages/chat_connections_page.dart';
import 'package:sparkduet/features/chat/presentation/pages/chat_preview_page.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_purpose.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/feed_editor_camera_page.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_feeds_page.dart';
import 'package:sparkduet/features/home/presentation/pages/home_page.dart';
import 'package:sparkduet/features/preferences/presentation/pages/preferences_page.dart';
import 'package:sparkduet/features/users/presentation/pages/user_profile_page.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

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
  routes: [

    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const AuthLoginPage(),
    ),

    GoRoute(
      path: AppRoutes.camera,
      builder: (context, state) {
        final map = state.extra as Map<String, dynamic>;
        final cameras = map['cameras'] as List<CameraDescription>;
        final feedPurpose = map["feedPurpose"] as PostFeedPurpose?;
        return FeedEditorCameraPage(cameras: cameras, purpose: feedPurpose,);
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
              routes: [
                GoRoute(
                  path: ":id",
                  pageBuilder: (ctx, state) => NoTransitionPage(child: const ChatPreviewPage(), name: state.path, arguments: state.extra),
                )
              ]
            ),
          ],
        ),

        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          GoRoute(
              path: AppRoutes.authProfile,
              pageBuilder: (ctx, state) {
                return NoTransitionPage(child: const AuthProfilePage(), name: state.fullPath, arguments: state.extra);
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