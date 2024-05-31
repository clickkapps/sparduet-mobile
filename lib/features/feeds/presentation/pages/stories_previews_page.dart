import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/stories_previews_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_item_widget.dart';

class StoriesPreviewsPage extends StatefulWidget {

  final List<FeedModel> feeds;
  final int initialFeedIndex;
  const StoriesPreviewsPage({super.key, required this.feeds, this.initialFeedIndex = 0});

  @override
  State<StoriesPreviewsPage> createState() => _StoriesPreviewsPageState();
}

class _StoriesPreviewsPageState extends State<StoriesPreviewsPage> with WidgetsBindingObserver {

  late int activeFeedIndex ;
  final Map<int, BetterPlayerController?> videoControllers = {};
  final Map<int, AssetsAudioPlayer?> imageControllers = {};
  late StoriesPreviewsCubit storiesPreviewsCubit;
  late PreloadPageController preloadPageController;
  bool activeStoryPlaying = true;
  bool storyPlayingBeforeLeavingPage = true; // This records the state before user navigates from the page

  @override
  void initState() {
    activeFeedIndex = widget.initialFeedIndex;
    preloadPageController = PreloadPageController(initialPage: widget.initialFeedIndex);
    storiesPreviewsCubit = context.read<StoriesPreviewsCubit>();
    storiesPreviewsCubit.setFeeds(widget.feeds);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // App is in background
      //  requestPostFeedAudioControllers[activeFeedIndex]?.;
      storyPlayingBeforeLeavingPage = activeStoryPlaying;
      pauseActiveStory();

    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground
      // playRequestFeedVideo(position)
      if(storyPlayingBeforeLeavingPage) {
        resumeActiveStory();
      }
    }
  }

  @override
  void dispose() {
    pauseActiveStory();
    preloadPageController.dispose();
    super.dispose();
  }

  void pauseActiveStory() async {
    // videoControllers[activeFeedIndex]?.videoPlayerController?.refresh();
    videoControllers[activeFeedIndex]?.pause();
    imageControllers[activeFeedIndex]?.pause();
    activeStoryPlaying = false;
  }

  Future<void> resetActiveStory() async {
    videoControllers[activeFeedIndex]?.seekTo(Duration.zero);
    imageControllers[activeFeedIndex]?.seek(Duration.zero);
  }

  void resumeActiveStory() async {
    // videoControllers[activeFeedIndex]?.videoPlayerController?.refresh();
    videoControllers[activeFeedIndex]?.play();
    imageControllers[activeFeedIndex]?.play();
    activeStoryPlaying = true;
  }

  void playActiveStory() async {
    // The actual post video
    videoControllers[activeFeedIndex]?.play();
    imageControllers[activeFeedIndex]?.play();
    activeStoryPlaying = true;
  }


  void feedsPreviewsCubitListener(BuildContext ctx, FeedState event) {
    //videoControllers[activeFeedIndex]?.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.darkColorScheme.onBackground),
        actions:  const [
          // IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.sliders, color: Colors.white,)),
          // IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.search, color: Colors.white,)),
          SizedBox(width: 18,)
        ],
      ),
      extendBodyBehindAppBar: true,
      body: BlocListener<StoriesPreviewsCubit, FeedState>(
        listener: feedsPreviewsCubitListener,
        child: ColoredBox(
          color: AppColors.darkColorScheme.background,
          child: Column(
            children: [
              Expanded(child:
              BlocBuilder<StoriesPreviewsCubit, FeedState>(
                // buildWhen: (_, state) {
                //   return state.status == FeedStatus.fetchFeedsSuccessful
                //       || (state.status == FeedStatus.fetchFeedsInProgress && pageKey == 1) // only show loading if we're fetch the first page
                //       || (state.status == FeedStatus.fetchFeedsFailed && pageKey == 1); // only show error if the first page is unable to load
                // },
                builder: (context, state) {

                  final feeds = state.feeds;
                  return PreloadPageView.builder(
                    itemCount: feeds.length,
                    itemBuilder: (_, i) {

                      ///! Item builder is called as many times as elements in the list
                      final feed = feeds[i];

                      // Regular stories .....
                      return BlocSelector<StoriesPreviewsCubit, FeedState, dynamic>(
                        selector: (state) {
                          return state.feeds.where((element) => element.id == feed.id).firstOrNull ?? feed;
                        },
                        builder: (context, feed) {
                          return FeedItemWidget(
                            videoBuilder: (controller) {
                              videoControllers[i] = controller;
                              playActiveStory();
                            },
                            imageBuilder: (controller) {
                              imageControllers[i] = controller;
                              playActiveStory();
                            },
                            onItemTapped: () => activeStoryPlaying ? pauseActiveStory() : resumeActiveStory(),
                            feed: feed, hls: true,);
                        },
                      )
                      ;

                    },
                    onPageChanged: (int position) async  {

                      pauseActiveStory();
                      resetActiveStory();
                      activeFeedIndex = position;
                      playActiveStory();

                    },
                    preloadPagesCount: 2,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    controller: preloadPageController,
                  );
                },
              )

              ),

              /// Loading
              // BlocBuilder<StoriesFeedsCubit, FeedState>(
              //   builder: (context, state) {
              //     if(state.status == FeedStatus.fetchFeedsInProgress) {
              //        return LinearProgressIndicator(color: theme.colorScheme.primary, minHeight: 2,);
              //     }
              //     return const SizedBox.shrink();
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }

}
