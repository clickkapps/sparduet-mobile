import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_previews_page.dart';
import 'package:sparkduet/features/search/data/store/search_cubit.dart';
import 'package:sparkduet/features/users/presentation/widgets/completed_user_post_item.dart';
import 'package:sparkduet/utils/custom_infinite_grid_view_widget.dart';

class PostTabSearchPage extends StatefulWidget {

  final String searchText;
  const PostTabSearchPage({super.key, required this.searchText});

  @override
  State<PostTabSearchPage> createState() => _PostTabSearchPageState();
}

class _PostTabSearchPageState extends State<PostTabSearchPage> {

  PagingController? pagingController;
  late SearchCubit cubit;
  @override
  void initState() {
    cubit = context.read<SearchCubit>();
    super.initState();
  }

  @override
  void dispose() {
    pagingController?.dispose();
    super.dispose();
  }

  // we use infinite scroll view here

  Future<(String?, List<FeedModel>?)> fetchData(int pageKey) async {
    return cubit.searchStories(query: widget.searchText, pageKey: pageKey);
  }

  @override
  Widget build(BuildContext context) {
    return CustomInfiniteGridViewWidget<FeedModel>(
      fetchData: fetchData,
      itemBuilder: (_, dynamic item, index) {
      final post = item as FeedModel;
      return CompletedUserPostItem(post: post, onTap: () {
        context.pushScreen(StoriesPreviewsPage(feeds: cubit.state.stories, initialFeedIndex: index,));
      });
    }, builder: (controller) {
      pagingController ??= controller;
    },
      padding: const EdgeInsets.symmetric(horizontal: 15),
      crossAxisSpacing: 3,
      mainAxisSpacing: 3,
      crossAxisCount: 3,
      emptyTitle: "No search results available yet...",
      emptySubTitle: "Related search results will be displayed here",
    );
  }
}
