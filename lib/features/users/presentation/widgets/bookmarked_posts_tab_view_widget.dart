import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/utils/custom_infinite_grid_view_widget.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';

class BookmarkedPostsTabViewPage extends StatefulWidget {

  final int? userId;
  const BookmarkedPostsTabViewPage({super.key, this.userId});

  @override
  State<BookmarkedPostsTabViewPage> createState() => _BookmarkedPostsTabViewPageState();
}

class _BookmarkedPostsTabViewPageState extends State<BookmarkedPostsTabViewPage> {


  PagingController? pagingController;

  Future<(String?, List<FeedModel>?)> fetchData(int pageKey) async {
    if(pageKey == 2) {
      return (null, <FeedModel>[]);
    }
    return (null, List.generate(3, (index) => FeedModel(id: index)));
  }

  @override
  Widget build(BuildContext context) {
    return CustomInfiniteGridViewWidget<FeedModel>(fetchData: fetchData, itemBuilder: (_, dynamic item, index) {
      final post = item as FeedModel;
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            CustomVideoPlayer(
              networkUrl: index % 2 == 0 ? "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/hl6is7u3aksdcg2gptgs.mp4" :
              "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/poqdyuhljyrrdpfhsgkg.mp4",
              autoPlay: false,
              loop: false,
              fit: BoxFit.cover,
              videoSource: VideoSource.network,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Gist about my preview relationship", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.darkColorScheme.onBackground,fontSize: 12),),
              ),
            )
          ],
        ),
      );
    }, builder: (controller) => pagingController = controller,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      crossAxisSpacing: 3,
      mainAxisSpacing: 3,
      crossAxisCount: 3,
    );
  }

}
