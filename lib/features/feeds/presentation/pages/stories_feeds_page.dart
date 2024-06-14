import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:background_fetch/background_fetch.dart';
// import 'package:background_fetch/background_fetch.dart';
import 'package:better_player/better_player.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/stories_feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_item_widget.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/request_post_feed_item_widget.dart';
import 'package:sparkduet/features/files/mixin/file_manager_mixin.dart';
import 'package:sparkduet/features/home/data/enums.dart';
import 'package:sparkduet/features/home/data/nav_cubit.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_cubit.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_state.dart';
import 'package:sparkduet/features/preferences/data/store/preferences_cubit.dart';
import 'package:sparkduet/features/search/presentation/pages/top_search_page.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/subscriptions/presentation/ui_mixin/subsription_page_mixin.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_badge_icon.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_error_content_widget.dart';

// https://cloudinary.com/documentation/flutter_media_transformations <-- Transform images/vids with this
class StoriesFeedsPage extends StatefulWidget {
  const StoriesFeedsPage({super.key});

  @override
  State<StoriesFeedsPage> createState() => _StoriesFeedsPageState();
}

class _StoriesFeedsPageState extends State<StoriesFeedsPage> with FileManagerMixin, WidgetsBindingObserver, SingleTickerProviderStateMixin, SubscriptionPageMixin  {

  late StoriesFeedsCubit storiesFeedsCubit;
  late ThemeCubit themeCubit;
  late NavCubit navCubit;
  int activeFeedIndex = 0;
  double percentageOfTimeSpentOnActiveFeed = 0;
  bool canMarkActiveFeedAsWatched = true;
  final Map<int, BetterPlayerController?> videoControllers = {};
  final Map<int, AssetsAudioPlayer?> imageControllers = {};
  final Map<int, BetterPlayerController?> requestPostFeedVideoControllers = {};
  int pageKey = 1;
  final preloadPageController = PreloadPageController();
  bool activeStoryPlaying = true;
  bool storyPlayingBeforeLeavingPage = true; // This records the state before user navigates from the page
  StreamSubscription? navCubitSubscription;
  int lastPositionFetched = -1;
  bool initialStoryViewed = false;

  ///! Hint user to swipe up for more ...
  late AnimationController _hintController;
  late Animation<Offset> _hintOffsetAnimation;
  bool _showHint = false;
  
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
    initHint();
    // initPlatformState();
    super.initState();
  }

  void presentPaywall() async {
    // final offering = await context.read<SubscriptionCubit>().getOffering();
    // if(offering == null){
    //   debugPrint("Unable to fetch offering");
    //   return;
    // }
    // final paywallResult = await RevenueCatUI.presentPaywall(offering: offering);
    // debugPrint('Paywall result: $paywallResult');
    showSubscriptionPaywall(context);
  }

  void initHint() {
    _hintController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _hintOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -0.4),
    ).animate(CurvedAnimation(
      parent: _hintController,
      curve: Curves.easeInOut,
    ));
  }

  void showHint() {
    setState(() {
      _showHint = true;
      _hintController.repeat(reverse: true);
    });
  }

  void hideHint() {
    // upd
    context.read<PreferencesCubit>().updateUserSettings(payload: {"show_swipe_up_stories_hint": 0 });
    setState(() {
      _showHint = false;
      _hintController.stop();
    });
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
    navCubitSubscription?.cancel();
    _hintController.dispose();
    super.dispose();
  }

  _setLight() {
    themeCubit.setLightMode();
    themeCubit.setSystemUIOverlaysToLight();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE
    ), (String taskId) async {  // <-- Event handler
      // This is the fetch-event callback.
      debugPrint("[BackgroundFetch] Event received $taskId");
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.


      // fetch stories in the background
      pageKey = 1;
      _fetchData(pageKey: pageKey, returnExistingFeedsForFirstPage: false);

      BackgroundFetch.finish(taskId);
    }, (String taskId) async {  // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      debugPrint("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    debugPrint('[BackgroundFetch] configure success: $status');
    BackgroundFetch.start();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  // returnExistingFeedsForFirstPage = will enable caching and fast serving of feeds
  _fetchData({required int pageKey, bool returnExistingFeedsForFirstPage = true}) {
      const path = AppApiRoutes.feeds;
      final queryParams = { "page": pageKey, "limit": 3 };
      storiesFeedsCubit.fetchFeeds(path: path, pageKey: pageKey, queryParams: queryParams, returnExistingFeedsForFirstPage: returnExistingFeedsForFirstPage);
  }

  void feedCubitListener(BuildContext ctx, FeedState event) {
    if(event.status == FeedStatus.fetchFeedsSuccessful) {
        final map  = event.data as Map<String, dynamic>;
        if(map.containsKey("pageKey")) {
          final pageKey = map['pageKey'] as int;
          if(pageKey == 1 && event.feeds.length > 1) {
            Future.delayed(const Duration(seconds: 2), () {
             final showSwipeUpStoriesHint = context.read<PreferencesCubit>().state.showSwipeUpStoriesHint ?? false;
             if(showSwipeUpStoriesHint) {
               showHint();
             }
              // showHint();
            });
          }
        }
    }
  }
  
  void pauseActiveStory() async {
    // videoControllers[activeFeedIndex]?.videoPlayerController?.refresh();
    videoControllers[activeFeedIndex]?.pause();
    imageControllers[activeFeedIndex]?.pause();
    requestPostFeedVideoControllers[activeFeedIndex]?.pause();
    activeStoryPlaying = false;
  }

  Future<void> resetActiveStory() async {
     videoControllers[activeFeedIndex]?.seekTo(Duration.zero);
     requestPostFeedVideoControllers[activeFeedIndex]?.seekTo(Duration.zero);
     // imageControllers[activeFeedIndex]?.seek(Duration.zero);
  }

  void resumeActiveStory() async {
    // videoControllers[activeFeedIndex]?.videoPlayerController?.refresh();
    videoControllers[activeFeedIndex]?.play();
    // imageControllers[activeFeedIndex]?.play();
    requestPostFeedVideoControllers[activeFeedIndex]?.play();
    activeStoryPlaying = true;
  }

  void playActiveStory({FeedModel? feed}) async {
    // "request post feed"


    requestPostFeedVideoControllers[activeFeedIndex]?.play();
    // The actual post video
    videoControllers[activeFeedIndex]?.play();
    // imageControllers[activeFeedIndex]?.play();
    activeStoryPlaying = true;
    //mark video as seen
    if(feed != null) {
      context.read<FeedsCubit>().viewPost(postId: feed.id, action: "seen");
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Find love ❤️", style: TextStyle(color: Colors.white,
            // fontSize: 16
        ),),
        actions:  [
          UnconstrainedBox(
            child: GestureDetector(
              onTap: () {
                presentPaywall();
              } ,
              behavior: HitTestBehavior.opaque,
              child: Padding(padding: const EdgeInsets.all(10),
                child: Builder(
                  builder: (context) {
                    // Calculate icon size based on parent constraints
                    double iconSize = MediaQuery.of(context).size.width * 0.065; // 10% of parent width

                    // Ensure the icon size is not too small or too large
                    if (iconSize < 24) {
                      iconSize = 24;
                    } else if (iconSize > 100) {
                      iconSize = 100;
                    }

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(FeatherIcons.bell, color: Colors.white, size: iconSize,),
                        Positioned(
                          right: -5, top: -3,
                        child: BlocSelector<NotificationsCubit, NotificationsState, int>(
                          selector: (state) {
                            return state.count;
                          },
                          builder: (context, cnt) {
                            if(cnt > 0)  {
                              return Container(
                                width: 17,
                                height: 17,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.buttonBlue,
                                ),
                                child: Center(
                                  child: FittedBox(fit: BoxFit.scaleDown,child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text("$cnt", style: const TextStyle(fontSize: 12, color: Colors.white),),
                                  ),),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        )),

                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          UnconstrainedBox(
            child: GestureDetector(
              onTap: () {
                context.pushScreen(const TopSearchPage());
              } ,
              behavior: HitTestBehavior.opaque,
              child: Padding(padding: const EdgeInsets.all(10),
                child: Builder(
                  builder: (context) {
                    // Calculate icon size based on parent constraints
                    double iconSize = MediaQuery.of(context).size.width * 0.07; // 10% of parent width

                    // Ensure the icon size is not too small or too large
                    if (iconSize < 24) {
                      iconSize = 24;
                    } else if (iconSize > 100) {
                      iconSize = 100;
                    }

                    return Icon(FeatherIcons.search, color: Colors.white, size: iconSize,);
                  },
                ),
              ),
            ),
          ),

          // const Icon(FeatherIcons.search, color: Colors.white,)),
          const SizedBox(width: 18,)
        ],
      ),
      extendBodyBehindAppBar: true,
      body: BlocListener<StoriesFeedsCubit, FeedState>(
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

                              ///! Item builder is called as many times as elements in the list
                              final feed = feeds[i];

                              return BlocSelector<StoriesFeedsCubit, FeedState, FeedModel>(
                                selector: (state) {
                                  return state.feeds.where((element) => element.id == feed.id).firstOrNull ?? feed;
                                },
                                builder: (context, feed) {
                                  // negative ids are meant to request the user to create a post
                                  if((feed.id  ?? 0) < 0) {
                                    return RequestPostFeedItem(feedId: feed.id!, builder: (videoController) {
                                      requestPostFeedVideoControllers[i] = videoController;
                                      // play first after initializing
                                      if(!initialStoryViewed && i == 0) { playActiveStory(); }
                                    },
                                      onTap: () {
                                        activeStoryPlaying ? pauseActiveStory() : resumeActiveStory();
                                      },
                                      onFeedEditorOpened: () {
                                        storyPlayingBeforeLeavingPage = activeStoryPlaying;
                                        pauseActiveStory();
                                      }, onFeedEditorClosed: () {
                                        if(storyPlayingBeforeLeavingPage) { resumeActiveStory();}
                                      },);
                                  }

                                  // Regular stories .....
                                  return Stack(
                                    children: [
                                      FeedItemWidget(videoBuilder: (controller) {
                                        videoControllers[i] = controller;
                                        if(!initialStoryViewed && i == 0) {
                                          // after initialization mark post as seen
                                          context.read<FeedsCubit>().viewPost(postId: feed.id, action: "seen");
                                        }
                                      },
                                        imageBuilder: (controller) {
                                          // imageControllers[i] = controller;
                                          if(!initialStoryViewed && i == 0) {
                                            // after initialization mark post as seen
                                            context.read<FeedsCubit>().viewPost(postId: feed.id, action: "seen");
                                          }
                                        },
                                        onItemTapped: () => activeStoryPlaying ? pauseActiveStory() : resumeActiveStory(),
                                        feed: feed,
                                        autoPlay: !initialStoryViewed && i == 0,
                                        hls: true,
                                        useCache: false,
                                        onProgress: (progress) {

                                          if(percentageOfTimeSpentOnActiveFeed < 50) { // this is to avoid reset percentageOfTimeSpentOnActiveFeed back to 0 from here when video is looping
                                            percentageOfTimeSpentOnActiveFeed = progress;
                                            if(percentageOfTimeSpentOnActiveFeed > 20 && canMarkActiveFeedAsWatched) {
                                              context.read<FeedsCubit>().viewPost(postId: feed.id, action: "watched");
                                              canMarkActiveFeedAsWatched = false;
                                              debugPrint("progress: $progress");
                                            }
                                          }

                                        },
                                      ),

                                      if(_showHint) ... {
                                        ColoredBox(
                                          color: Colors.black.withOpacity(0.8),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SlideTransition(
                                                  position: _hintOffsetAnimation,
                                                  child: const Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.swipe_up, size: 50, color: Colors.white),
                                                    ],
                                                  ),
                                                ),
                                                Text("Swipe up", style: theme.textTheme.titleLarge?.copyWith(color: AppColors.darkColorScheme.onBackground),),
                                                Text("To see more posts", style: theme.textTheme.titleSmall?.copyWith(color: AppColors.darkColorScheme.onBackground),),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                  child: CustomButtonWidget(text: "Got it", onPressed: () {
                                                    hideHint();
                                                  }, appearance: ButtonAppearance.clean, borderRadius: 20, outlineColor: AppColors.darkColorScheme.onBackground, textColor: AppColors.darkColorScheme.onBackground,),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      },

                                    ],
                                  );
                                },
                              );


                            },
                            onPageChanged: (int position) async  {

                              ///! active index is previous position
                              if(_showHint) {
                                hideHint();
                              }
                              pauseActiveStory();
                              resetActiveStory();

                              activeFeedIndex = position;
                              percentageOfTimeSpentOnActiveFeed = 0;
                              canMarkActiveFeedAsWatched = true;
                              if(initialStoryViewed == false) {
                                initialStoryViewed = true;
                              }

                              ///! active index is now current position

                              // mark post as seen
                              if((feeds[position].id ?? -1) > -1) {
                                context.read<FeedsCubit>().viewPost(postId: feeds[position].id, action: "seen");
                              }


                              playActiveStory(feed: feeds[position]);




                              // any time we reach the second (last) video then we fetch more
                              // if(position)
                              final feedsLastPosition = feeds.length - 1;
                              final positionToFetch = (feedsLastPosition - 1);
                              if(positionToFetch != lastPositionFetched && position == positionToFetch ) {
                                pageKey++;
                                _fetchData(pageKey: pageKey);
                                lastPositionFetched = positionToFetch;
                              }


                            },
                            preloadPagesCount: 3,
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
