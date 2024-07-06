import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_assets.dart';
import 'package:sparkduet/core/app_classes.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_previews_page.dart';
import 'package:sparkduet/features/users/presentation/widgets/completed_user_post_item.dart';
import 'package:sparkduet/features/users/presentation/widgets/uncompleted_user_post_item.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/utils/custom_infinite_grid_view_widget.dart';

class UserPostsTabViewWidget<C extends FeedsCubit> extends StatefulWidget {
  final int? userId;
  final Function(PagingController<int, dynamic>)? builder;
  const UserPostsTabViewWidget({super.key, this.userId, this.builder});

  @override
  State<UserPostsTabViewWidget> createState() => _UserPostsTabViewWidgetState<C>();
}

class _UserPostsTabViewWidgetState<C extends FeedsCubit> extends State<UserPostsTabViewWidget> with AutomaticKeepAliveClientMixin {

  PagingController<int, dynamic>? pagingController;
  late C feedsCubit;
  late StreamSubscription streamSubscription;
  bool userPostsInitialized = false;
  StreamSubscription? cubeChatConnectionStateStream;

  @override
  void initState() {
    feedsCubit = context.read<C>();
    streamSubscription = feedsCubit.stream.listen((event) {
      if(event.status == FeedStatus.refreshListCompleted) {
        pagingController?.itemList = event.feeds;
      }
      if(event.status == FeedStatus.deletePostFailed) {
          context.showSnackBar(event.message);
      }
      if(event.status == FeedStatus.deletePostSuccessful) {
        context.showSnackBar("Post deleted!");
      }

    });
    establishConnection();
    super.initState();
  }

  @override
  void dispose() {
    pagingController?.dispose();
    cubeChatConnectionStateStream?.cancel();
    streamSubscription.cancel();
    super.dispose();
  }

  void establishConnection() async {

    // reconnect if connection is lost
    cubeChatConnectionStateStream = Connectivity().onConnectivityChanged.listen((connectivityType) async {
      if(await isNetworkConnected() && mounted) {
        if(!userPostsInitialized && pagingController != null) {
          pagingController?.refresh();
        }
      }

    });
  }

  Future<(String?, List<FeedModel>?)> fetchData(int pageKey) async {
    final path = AppApiRoutes.userPosts(userId: widget.userId);
     final result = await feedsCubit.fetchFeeds(path: path, pageKey: pageKey, queryParams: {"page": pageKey, "limit": AppConstants.gridPageSize});
    if(pageKey == 1 && result.$2 != null) {
      userPostsInitialized = true;
    }
    return result;
  }

  void showDeleteOption(BuildContext context, FeedModel post) {
    context.showCustomListBottomSheet(items: [ const ListItem(id: "delete", title: "Delete Post")], onItemTapped: (item) {
      if(item.id == "delete") {
        context.read<C>().deletePost(post: post);
      }
    });
        // working on delete option and realtime showing of censor
  }

  Widget loadingProgressIndicator(BuildContext context) => Lottie.asset(AppAssets.kLoveLoaderJson, height:  MediaQuery.of(context).size.width * 0.1);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final authenticatedUser = context.read<AuthCubit>().state.authUser;

    return CustomInfiniteGridViewWidget<FeedModel>(fetchData: fetchData, itemBuilder: (_, dynamic item, index) {
        final post = item as FeedModel;

        if(post.id == null || post.tempId != null) {
          return UncompletedUserPostItem(post: post, onTap: () {
            if(post.id != null) {
              context.pushScreen(StoriesPreviewsPage(feeds: feedsCubit.state.feeds, initialFeedIndex: feedsCubit.state.feeds.indexWhere((element) => element.id == post.id),));
            }
          },);
        }else{
         return CompletedUserPostItem(post: post, onTap: () {
           final initialIndex = feedsCubit.state.feeds.indexWhere((element) => element.id == post.id);
           context.push(AppRoutes.feedPreviewPage, extra: {'feeds': feedsCubit.state.feeds, 'initialIndex': initialIndex });
           // context.pushScreen(StoriesPreviewsPage(feeds: feedsCubit.state.feeds, initialFeedIndex: ,));
           // context.pushScreen(StoriesPreviewsPage(feeds: feedsCubit.state.feeds, initialFeedIndex: feedsCubit.state.feeds.indexWhere((element) => element.id == post.id),));
         }, onLongPress: () {
           if(authenticatedUser?.id == post.user?.id) {
             showDeleteOption(context, post);
           }
         },);
        }
    }, builder: (controller) {
      widget.builder?.call(controller);
      pagingController ??= controller;
    }, padding: const EdgeInsets.symmetric(horizontal: 15),
      crossAxisSpacing: 3,
      mainAxisSpacing: 3,
      crossAxisCount: 3,
      // loadingIndicator: loadingProgressIndicator(context),
      emptyTitle: "No posts available yet...",
      emptySubTitle: "Related posts will be displayed here",
    );
  }

  @override
  bool get wantKeepAlive => true;
}
