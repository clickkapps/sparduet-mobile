import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:sparkduet/app/routing/routes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/stories_previews_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_item_widget.dart';
import 'package:sparkduet/utils/custom_fast_page_scroll_physics.dart';
import 'package:sparkduet/utils/custom_play_pause_icon_widget.dart';

class StoriesPreviewsPage extends StatefulWidget {

  final List<FeedModel> feeds;
  final int initialFeedIndex;
  const StoriesPreviewsPage({super.key, required this.feeds, this.initialFeedIndex = 0});

  @override
  State<StoriesPreviewsPage> createState() => _StoriesPreviewsPageState();
}

class _StoriesPreviewsPageState extends State<StoriesPreviewsPage> with WidgetsBindingObserver, RouteAware  {

  late int activeFeedIndex ;
  final Map<int, BetterPlayerController?> videoControllers = {};
  final Map<int, AudioPlayer?> imageControllers = {};
  late StoriesPreviewsCubit storiesPreviewsCubit;
  late PreloadPageController preloadPageController;
  bool activeStoryPlaying = true;
  bool storyPageActive = true;
  bool storyPlayingBeforeLeavingPage = true; // This records the state before user navigates from the page
  final ValueNotifier<bool> showPauseIcon = ValueNotifier(false);

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
  void dispose() {
    pauseActiveStory();
    activeStoryPlaying = false;
    storyPageActive = false;
    preloadPageController.dispose();
    storiesPreviewPageRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    storiesPreviewPageRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // App is in background
      //  requestPostFeedAudioControllers[activeFeedIndex]?.;
      if(storyPageActive){
        setPlayingStateBeforeLeavingAndPauseStory();
      }

    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground
      // playRequestFeedVideo(position)
      if(storyPageActive) {
        resumePlayingIfItWasPlaying();
      }

    }
  }

  @override
  void didPush() {
    // This route was pushed onto the navigator and is now topmost.
    debugPrint('HomePage: didPush');
    storyPageActive = true;
  }

  @override
  void didPopNext() {
    // This route is again the top route.
    storyPageActive = true;
    resumePlayingIfItWasPlaying();
    debugPrint('HomePage: didPopNext');
  }

  @override
  void didPop() {
    // This route was popped off the navigator.
    storyPageActive = false;
    setPlayingStateBeforeLeavingAndPauseStory();
    debugPrint('HomePage: didPop');
  }

  @override
  void didPushNext() {
    // Another route has been pushed above this one.
    setPlayingStateBeforeLeavingAndPauseStory();
    storyPageActive = false;
    debugPrint('HomePage: didPushNext');
  }

  void setPlayingStateBeforeLeavingAndPauseStory() {
    storyPlayingBeforeLeavingPage = activeStoryPlaying;
    pauseActiveStory();
  }

  void resumePlayingIfItWasPlaying() {
    if(storyPlayingBeforeLeavingPage) {
      resumeActiveStory();
    }
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
                buildWhen: (_, state) {
                  return state.status == FeedStatus.setFeedCompleted;
                },
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
                          return Stack(
                            children: [
                              FeedItemWidget(
                                index: i,
                                preloadPageController: preloadPageController,
                                videoBuilder: (controller) {
                                  videoControllers[i] = controller;
                                  playActiveStory();
                                },
                                imageBuilder: (controller) {
                                  imageControllers[i] = controller;
                                  playActiveStory();
                                },
                                onItemTapped: () => activeStoryPlaying ? pauseActiveStory() : resumeActiveStory(),
                                onPageChanged: (bool onPageChanged) {
                                  // if(onPageChanged) {
                                  //   setPlayingStateBeforeLeavingAndPauseStory();
                                  // }else{
                                  //   resumePlayingIfItWasPlaying();
                                  // }
                                },
                                feed: feed, hls: true,),
                              ValueListenableBuilder<bool>(valueListenable: showPauseIcon, builder: (_, show, ch) {
                                if(show) {
                                  return ch!;
                                }
                                return const SizedBox.shrink();
                              }, child: const Align(
                                alignment: Alignment.center,
                                child: CustomPlayPauseIconWidget(eventType: BetterPlayerEventType.pause,),
                              ),)
                            ],
                          );
                        },
                      );

                    },
                    onPageChanged: (int position) async  {

                      pauseActiveStory();
                      resetActiveStory();
                      activeFeedIndex = position;
                      playActiveStory();

                    },
                    preloadPagesCount: widget.feeds.length,
                    physics: const CustomFastPageScrollPhysics(),
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
