import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:better_player/better_player.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/stories_feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_item_widget.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/request_post_feed_item_widget.dart';
import 'package:sparkduet/features/files/mixin/file_manager_mixin.dart';
import 'package:sparkduet/features/home/data/enums.dart';
import 'package:sparkduet/features/home/data/nav_cubit.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/network/api_config.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_error_content_widget.dart';

// https://cloudinary.com/documentation/flutter_media_transformations <-- Transform images/vids with this
class StoriesFeedsPage extends StatefulWidget {
  const StoriesFeedsPage({super.key});

  @override
  State<StoriesFeedsPage> createState() => _StoriesFeedsPageState();
}

class _StoriesFeedsPageState extends State<StoriesFeedsPage> with FileManagerMixin, WidgetsBindingObserver {

  late StoriesFeedsCubit storiesFeedsCubit;
  late ThemeCubit themeCubit;
  late NavCubit navCubit;
  int activeFeedIndex = 0;
  final Map<int, BetterPlayerController?> videoControllers = {};
  final Map<int, AudioPlayer?> requestPostFeedAudioControllers = {}; // we use this when we request user to post a feed
  final Map<int, BetterPlayerController?> requestPostFeedVideoControllers = {};
  final int pageKey = 1;
  final preloadPageController = PreloadPageController();
  bool activeStoryPlaying = true;
  bool storyPlayingBeforeLeavingPage = true; // This records the state before user navigates from the page
  StreamSubscription? navCubitSubscription;
  
  @override
  void initState() {
    themeCubit = context.read<ThemeCubit>();
    navCubit = context.read<NavCubit>();
    navCubitSubscription = navCubit.stream.listen((event) {
        if(event.status == NavStatus.onTabChanged) {{
          if(event.currentTabIndex == 0) {

            if(storyPlayingBeforeLeavingPage) { resumeActiveStory();}

           } else  {
            // This is a fix. we set storyPlayingBeforeLeavingPage if only use is leaving the home page
            if(event.previousIndex == 0) {
              storyPlayingBeforeLeavingPage = activeStoryPlaying;
              pauseActiveStory();
            }

          }
        }}
    });
    storiesFeedsCubit = context.read<StoriesFeedsCubit>();
    // fetch first page
    _fetchData(pageKey: pageKey);
    onWidgetBindingComplete(onComplete: () {

    });
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
    preloadPageController.dispose();
    navCubitSubscription?.cancel();
    super.dispose();
  }

  _setLight() {
    themeCubit.setLightMode();
    themeCubit.setSystemUIOverlaysToLight();
  }

  _fetchData({required int pageKey}) {
      const path = AppApiRoutes.feeds;
      final queryParams = { "page": pageKey};
      storiesFeedsCubit.fetchFeeds(path: path, pageKey: pageKey, queryParams: queryParams);
  }

  void feedCubitListener(BuildContext ctx, FeedState event) {
    //videoControllers[activeFeedIndex]?.pause();
  }
  
  void pauseActiveStory() async {
    // videoControllers[activeFeedIndex]?.videoPlayerController?.refresh();
    await videoControllers[activeFeedIndex]?.pause();
    await requestPostFeedAudioControllers[activeFeedIndex]?.pause();
    await requestPostFeedVideoControllers[activeFeedIndex]?.pause();
    activeStoryPlaying = false;
  }

  void resumeActiveStory() async {
    // videoControllers[activeFeedIndex]?.videoPlayerController?.refresh();
    await videoControllers[activeFeedIndex]?.play();
    await requestPostFeedAudioControllers[activeFeedIndex]?.resume();
    await requestPostFeedVideoControllers[activeFeedIndex]?.play();
    activeStoryPlaying = true;
  }

  void playActiveStoryFromStart() async {
    // "request post feed"
    await requestPostFeedVideoControllers[activeFeedIndex]?.play();
    requestPostFeedAudioControllers[activeFeedIndex]?..setReleaseMode(ReleaseMode.loop)..play(UrlSource(AppConstants.requestPostFeedAudioUrl));
    // The actual post video
    videoControllers[activeFeedIndex]?..seekTo(Duration.zero)..play();
    activeStoryPlaying = true;
  }
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Connections ❤️", style: TextStyle(color: Colors.white,
            // fontSize: 16
        ),),
        actions:  [
          // IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.sliders, color: Colors.white,)),
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.search, color: Colors.white,)),
          const SizedBox(width: 18,)
        ],
      ),
      extendBodyBehindAppBar: true,
      body: BlocListener<FeedsCubit, FeedState>(
        listener: feedCubitListener,
        child: ColoredBox(
          color: AppColors.darkColorScheme.background,
          child: Column(
                children: [
                  Expanded(child:
                      BlocBuilder<StoriesFeedsCubit, FeedState>(
                        buildWhen: (_, state) {
                          return state.status == FeedStatus.fetchFeedsSuccessful
                              || (state.status == FeedStatus.fetchFeedsInProgress && pageKey == 1) // only show loading if we're fetch the first page
                              || (state.status == FeedStatus.fetchFeedsFailed && pageKey == 1); // only show error if the first page is unable to load
                        },
                        builder: (context, state) {
                          if(state.status == FeedStatus.fetchFeedsInProgress) {
                            return const Center(child: CustomAdaptiveCircularIndicator(),);
                          }
                          else if(state.status == FeedStatus.fetchFeedsFailed) {
                            return Center(child: CustomErrorContentWidget(onTap: () {
                                _fetchData(pageKey: pageKey);
                            }, titleColor: AppColors.darkColorScheme.onBackground, subTitleColor: AppColors.darkColorScheme.onBackground,),);
                          }
                          final feeds = state.feeds;
                          return PreloadPageView.builder(
                            itemCount: feeds.length,
                            itemBuilder: (_, i) {

                              debugPrint("CustomLog: PreloadPageView called for i = $i");

                              ///! Item builder is called as many times as elements in the list
                              final feed = feeds[i];

                              // negative ids are meant to request the user to create a post
                              if((feed.id  ?? 0) < 0) {
                                return RequestPostFeedItem(feedId: feed.id!, builder: (videoController, audioController) {
                                   requestPostFeedVideoControllers[i] = videoController;
                                   requestPostFeedAudioControllers[i] = audioController;
                                   // play first after initializing
                                   if(i == 0) { playActiveStoryFromStart(); }
                                },
                                  onTap: () => activeStoryPlaying ? pauseActiveStory() : resumeActiveStory(),
                                  onFeedEditorOpened: () {
                                    storyPlayingBeforeLeavingPage = activeStoryPlaying;
                                    pauseActiveStory();
                                  }, onFeedEditorClosed: () {
                                    if(storyPlayingBeforeLeavingPage) { resumeActiveStory();}
                                  },);
                              }

                              // Regular stories .....
                              return StoryFeedItemWidget(videoBuilder: (controller) {
                                videoControllers[i] = controller;
                              }, onItemTapped: () => activeStoryPlaying ? pauseActiveStory() : resumeActiveStory(),
                                feed: feed,);

                            },
                            onPageChanged: (int position) async  {

                              pauseActiveStory();
                              activeFeedIndex = position;
                              playActiveStoryFromStart();

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
