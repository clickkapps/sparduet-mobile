import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_previews_page.dart';
import 'package:sparkduet/features/users/presentation/widgets/completed_user_post_item.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/utils/custom_infinite_grid_view_widget.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';

class BookmarkedPostsTabViewPage<C extends FeedsCubit> extends StatefulWidget {

  final int? userId;
  final Function(PagingController<int, dynamic>)? builder;
  const BookmarkedPostsTabViewPage({super.key, this.userId, this.builder});

  @override
  State<BookmarkedPostsTabViewPage> createState() => _BookmarkedPostsTabViewPageState<C>();
}

class _BookmarkedPostsTabViewPageState<C extends FeedsCubit> extends State<BookmarkedPostsTabViewPage> with AutomaticKeepAliveClientMixin {


  PagingController? pagingController;
  late C feedsCubit;

  @override
  void initState() {
    feedsCubit = context.read<C>();
    super.initState();
  }

  @override
  void dispose() {
    pagingController?.dispose();
    super.dispose();
  }

  Future<(String?, List<FeedModel>?)> fetchData(int pageKey) async {
    final path = AppApiRoutes.bookmarkedUserPosts(userId: widget.userId,);
    return feedsCubit.fetchFeeds(path: path, pageKey: pageKey, queryParams: {"limit": AppConstants.gridPageSize, "page": pageKey});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomInfiniteGridViewWidget<FeedModel>(fetchData: fetchData, itemBuilder: (_, dynamic item, index) {
      final post = item as FeedModel;
      return CompletedUserPostItem(post: post, onTap: () {
        context.pushScreen(StoriesPreviewsPage(feeds: feedsCubit.state.feeds, initialFeedIndex: feedsCubit.state.feeds.indexWhere((element) => element.id == post.id),));
      });
    }, builder: (controller) {
      widget.builder?.call(controller);
      pagingController = controller;
    },
      padding: const EdgeInsets.symmetric(horizontal: 15),
      crossAxisSpacing: 3,
      mainAxisSpacing: 3,
      crossAxisCount: 3,
      emptyTitle: "No bookmarked posts available yet...",
      emptySubTitle: "Related bookmarked posts will be displayed here",
    );
  }

  @override
  bool get wantKeepAlive => true;

}
