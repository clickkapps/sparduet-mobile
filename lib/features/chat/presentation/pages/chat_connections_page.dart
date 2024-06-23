import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_state.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';
import 'package:sparkduet/features/chat/presentation/widgets/chat_connection_item_widget.dart';
import 'package:sparkduet/features/chat/presentation/widgets/empty_chat_widget.dart';
import 'package:sparkduet/features/home/data/store/nav_cubit.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class ChatConnectionsPage extends StatefulWidget {
  const ChatConnectionsPage({super.key});

  @override
  State<ChatConnectionsPage> createState() => _ChatConnectionsPageState();
}

class _ChatConnectionsPageState extends State<ChatConnectionsPage> {

  late ChatConnectionsCubit chatConnectionsCubit;
  @override
  void initState() {
    chatConnectionsCubit = context.read<ChatConnectionsCubit>();
    chatConnectionsCubit.fetchChatConnections().then((value) {
        chatConnectionsCubit.setServerPushChannels();
        chatConnectionsCubit.listenToServerChatUpdates();
    });
    super.initState();
  }

  @override
  void dispose() {
    // chatConnectionsCubit.cancelChatConnectionsListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {

        return [
          SliverAppBar(
            elevation: 0,
            title: const Text("Inbox"),
            leading: CloseButton(color: theme.colorScheme.onBackground, onPressed: () => {
              context.read<NavCubit>().requestTabChange(NavPosition.home)
            },),
          ),
          BlocBuilder<ChatConnectionsCubit, ChatConnectionState>(
            buildWhen: (ctx, chatState) {
              return chatState.status == ChatConnectionStatus.fetchSuggestedChatUsersSuccessful;
            },
            builder: (context, chatState) {
              if(chatState.suggestedChatUsers.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink(),);
              }
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Text("Suggested people", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              );
            },
          ),

          SliverToBoxAdapter(
            child: BlocBuilder<ChatConnectionsCubit, ChatConnectionState>(
              buildWhen: (ctx, chatState) {
                return chatState.status == ChatConnectionStatus.fetchSuggestedChatUsersSuccessful;
              },
              builder: (context, chatState) {
                if(chatState.suggestedChatUsers.isEmpty) {
                  return const SizedBox.shrink();
                }
                return SizedBox(
                  height: 110,
                  child: ListView.separated(itemBuilder: (_, i) {
                    final user = chatState.suggestedChatUsers[i];
                    return  GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.chatPreview, extra: user );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UnconstrainedBox(child: CustomUserAvatarWidget(size: 70, online: true, showBorder: false,
                              imageUrl: AppConstants.imageMediaPath(mediaId: user.info?.profilePicPath ?? ''),
                            ),),
                            Text(user.name ?? (user.username ?? ""), maxLines: 1, overflow: TextOverflow.ellipsis,)
                          ],
                        ),
                      ),
                    );
                  }, separatorBuilder: (_, i) {
                    return const SizedBox(width: 10,);
                  }, itemCount: chatState.suggestedChatUsers.take(5).length, scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 10, bottom: 10), ),
                );
              },
            ),
          ),
          BlocBuilder<ChatConnectionsCubit, ChatConnectionState>(
            buildWhen: (ctx, chatState) {
              return chatState.status == ChatConnectionStatus.refreshChatConnectionsCompleted;
            },
            builder: (context, chatState) {
              if(chatState.chatConnections.where((element) => element.lastMessage != null).isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink(),);
              }
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
                  child: Text("Recent conversations", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              );
            },
          )
        ];

      }, body:
      // Dont! use infinte scroll here. list all the previous chat of the user
      BlocBuilder<ChatConnectionsCubit, ChatConnectionState>(
        buildWhen: (ctx, chatState) {
          return chatState.status == ChatConnectionStatus.refreshChatConnectionsCompleted;
        },
        builder: (context, chatState) {

          if(chatState.status == ChatConnectionStatus.fetchChatConnectionLoading){
            return const Center(child: CustomAdaptiveCircularIndicator(),);
          }

          if(chatState.chatConnections.where((element) => element.lastMessage != null).isEmpty) {
            return const SingleChildScrollView(child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: EmptyChatWidget(message: "Your conversations will appear here",)),);
          }
          return ListView.separated(itemBuilder: (ctx, i){
            final chatConnectionItem = chatState.chatConnections.where((element) => element.lastMessage != null).toList()[i];
            return ChatConnectionItemWidget(key: ValueKey(chatConnectionItem.id), chatConnection: chatConnectionItem);
          }, separatorBuilder: (ctx,i){
            return const SizedBox(height: 1,);
          }, itemCount: chatState.chatConnections.where((element) => element.lastMessage != null).length, padding: const EdgeInsets.only(bottom: 10),);
        },
      )
        // ListView.separated(itemBuilder: (ctx, i) {
        //   return  ;
        // }, itemCount: 3, separatorBuilder: (BuildContext context, int index) {
        //   return const SizedBox(height: 1,);
        // }, padding: const EdgeInsets.only(top: 0),),
      ),
    );
  }

}
