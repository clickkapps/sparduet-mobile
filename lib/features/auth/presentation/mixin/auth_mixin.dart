import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';

mixin AuthMixin {
  void logout(BuildContext context) {
    context.read<AuthCubit>().logout();
    final authUser = context.read<AuthCubit>().state.authUser;
    context.read<UserCubit>().removeOnlineUser(userId: authUser?.id);
    context.read<ChatPreviewCubit>().clearMessages();
    context.read<ChatConnectionsCubit>().clearChatConnectionsCache();
    context.go(AppRoutes.login);
  }

  void deleteAccount(BuildContext context) {
    context.read<AuthCubit>().deleteAccount();
  }
}