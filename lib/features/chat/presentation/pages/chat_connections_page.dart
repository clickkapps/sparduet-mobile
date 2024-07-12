import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_state.dart';
import 'package:sparkduet/features/chat/data/store/enums.dart';
import 'package:sparkduet/features/chat/presentation/widgets/chat_connection_item_widget.dart';
import 'package:sparkduet/features/chat/presentation/widgets/empty_chat_widget.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';
import 'package:sparkduet/features/home/data/store/nav_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_state.dart';
import 'package:sparkduet/features/users/presentation/pages/users_online_page.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_infinite_list_view_widget.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class ChatConnectionsPage extends StatefulWidget {
  const ChatConnectionsPage({super.key});

  @override
  State<ChatConnectionsPage> createState() => _ChatConnectionsPageState();
}

class _ChatConnectionsPageState extends State<ChatConnectionsPage> {


  late ChatConnectionsCubit chatConnectionsCubit;
  PagingController<int, dynamic>? pagingController;
  ScrollController scrollController = ScrollController();
  late StreamSubscription navStreamSubscription;
  late NavCubit navCubit;
  @override
  void initState() {
    chatConnectionsCubit = context.read<ChatConnectionsCubit>();
    // chatConnectionsCubit.stream.listen((event) {
    //   if(event.status == ChatConnectionStatus.refreshChatConnectionsCompleted) {
    //     pagingController?.itemList = event.chatConnections;
    //     // pagingController?.itemList = [];
    //   }
    // });
    navCubit = context.read<NavCubit>();
    navStreamSubscription = navCubit.stream.listen((event) {

      if(event.status == NavStatus.onActiveIndexTappedCompleted) {
        final tabIndex = event.data as int;
        if(tabIndex == 1) {
          scrollController.animateTo(0.00, duration: const Duration(milliseconds: 275), curve: Curves.linear);
        }
      }


    });
    chatConnectionsCubit.fetchChatConnections().then((value) {});
    super.initState();
  }

  @override
  void dispose() {
    pagingController?.dispose();
    navStreamSubscription.cancel();
    scrollController.dispose();
    // chatConnectionsCubit.cancelChatConnectionsListener();
    super.dispose();
  }

  void usersOnlineHandler(BuildContext context) {

    final ch = Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(color: Colors.transparent), // Transparent container to detect taps
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 0.9,
            minChildSize: 0.7,
            builder: (_ , controller) {
              return ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: UsersOnlinePage(controller: controller)
              );
            }
        ),
      ],
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  // Future<(String?, List<ChatConnectionModel>?)> fetchData(int pageKey) async {
  //   return chatConnectionsCubit.fetchChatConnections(pageKey: pageKey);
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {

        return [
          SliverAppBar(
            elevation: 0,
            title: const Text("Inbox"),
            leading: CloseButton(color: theme.colorScheme.onBackground, onPressed: () => {
              context.read<NavCubit>().requestTabChange(NavPosition.home)
            },),
            centerTitle: false,
            actions: [
              BlocSelector<UserCubit, UserState, num>(
                selector: (state) {
                  return state.onlineUserIds.length;
                },
                builder: (context, onlineUsersCount) {
                  if(onlineUsersCount < 1) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () => usersOnlineHandler(context),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 16, color:theme.brightness == Brightness.dark ? AppColors.onlineGreen : Colors.green,),
                        Text("${convertToCompactFigure(onlineUsersCount.toInt())} online", style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.onlineGreen, fontWeight: FontWeight.bold),)
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 15,)

            ],
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
                        context.pushToChatPreview( user );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UnconstrainedBox(child: CustomUserAvatarWidget(size: 70, userId: user.id, showBorder: false,
                              imageUrl: AppConstants.imageMediaPath(mediaId: user.info?.profilePicPath ?? ''),
                              placeHolderName: user.name ?? user.username,
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

          ///Look into infinite scroll later
          //CustomInfiniteListViewWidget<ChatConnectionModel>(itemBuilder: (item, index) {
        //         final chatConnectionItem = item as ChatConnectionModel;
        //         return ChatConnectionItemWidget(key: ValueKey(chatConnectionItem.id), chatConnection: chatConnectionItem);
        //       }, fetchData: fetchData,
        //         pageViewBuilder: (controller) => pagingController = controller,
        //         padding: const EdgeInsets.only(bottom: 10),
        //         separatorBuilder: (_, __) {
        //           return const SizedBox(height: 1,);
        //         },
        //         noItemsFoundIndicator: const SingleChildScrollView(child: Padding(
        //             padding: EdgeInsets.only(bottom: 20),
        //             child: EmptyChatWidget(message: "Your conversations will appear here",)),),
        //       )

        // ListView.separated(itemBuilder: (ctx, i) {
        //   return  ;
        // }, itemCount: 3, separatorBuilder: (BuildContext context, int index) {
        //   return const SizedBox(height: 1,);
        // }, padding: const EdgeInsets.only(top: 0),),
      ),
    );
  }

}
