import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/stories_feeds_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/stories_previews_cubit.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_cubit.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';

mixin AuthMixin {
  void logout(BuildContext context) async {
    final authUser = context.read<AuthCubit>().state.authUser;
    context.read<UserCubit>().removeOnlineUser(userId: authUser?.id);
    context.read<ChatPreviewCubit>().clearMessages();
    context.read<ChatConnectionsCubit>().clearChatConnectionsCache();
    context.read<AuthCubit>().clearState();
    context.read<FeedsCubit>().clearState();
    context.read<StoriesFeedsCubit>().clearState();
    context.read<StoriesPreviewsCubit>().clearState();
    context.read<ChatConnectionsCubit>().clearState();
    context.read<ChatPreviewCubit>().clearState();
    context.read<NotificationsCubit>().clearState();
    context.read<SubscriptionCubit>().clearState();
    context.read<UserCubit>().clearState();
    await context.read<AuthCubit>().logout();
    if(context.mounted){
      context.go(AppRoutes.login);
    }
  }

  void deleteAccount(BuildContext context) {
    context.read<AuthCubit>().deleteAccount();
  }
}