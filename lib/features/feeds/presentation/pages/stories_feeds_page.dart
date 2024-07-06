import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:better_player/better_player.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:sparkduet/app/routing/routes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/stories_feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_item_widget.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/request_post_feed_item_widget.dart';
import 'package:sparkduet/features/files/mixin/file_manager_mixin.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';
import 'package:sparkduet/features/home/data/store/home_cubit.dart';
import 'package:sparkduet/features/home/data/store/nav_cubit.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_cubit.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_state.dart';
import 'package:sparkduet/features/notifications/presentation/pages/notifications_page.dart';
import 'package:sparkduet/features/notifications/presentation/widgets/notification_icon_widget.dart';
import 'package:sparkduet/features/preferences/data/store/preferences_cubit.dart';
import 'package:sparkduet/features/search/presentation/pages/top_search_page.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/subscriptions/presentation/ui_mixin/subsription_page_mixin.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/features/users/data/store/enums.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_state.dart';
import 'package:sparkduet/features/users/presentation/pages/users_online_page.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_badge_icon.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_error_content_widget.dart';
import 'package:sparkduet/utils/custom_fast_page_scroll_physics.dart';
import 'package:sparkduet/utils/custom_play_pause_icon_widget.dart';

// https://cloudinary.com/documentation/flutter_media_transformations <-- Transform images/vids with this
class StoriesFeedsPage extends StatefulWidget {
  const StoriesFeedsPage({super.key});

  @override
  State<StoriesFeedsPage> createState() => _StoriesFeedsPageState();
}

class _StoriesFeedsPageState extends State<StoriesFeedsPage> with FileManagerMixin, WidgetsBindingObserver, SingleTickerProviderStateMixin, SubscriptionPageMixin, RouteAware  {

  late StoriesFeedsCubit storiesFeedsCubit;
  late ThemeCubit themeCubit;
  late NavCubit navCubit;
  late HomeCubit homeCubit;
  late UserCubit userCubit;
  late AuthCubit authCubit;
  int activeFeedIndex = 0;
  double percentageOfTimeSpentOnActiveFeed = 0;
  bool canMarkActiveFeedAsWatched = true;
  final Map<int, BetterPlayerController?> videoControllers = {};
  final Map<int, AudioPlayer?> imageControllers = {};
  final Map<int, BetterPlayerController?> requestPostFeedVideoControllers = {};
  int pageKey = 1;
  final preloadPageController = PreloadPageController();
  bool activeStoryPlaying = true;
  bool storyPlayingBeforeLeavingPage = true; // This records the state before user navigates from the page
  StreamSubscription? navCubitSubscription;
  int lastPositionFetched = -1;
  bool initialStoryViewed = false;
  DateTime? _lastPauseTime;
  bool storyPageActive = true;
  final ValueNotifier<bool> showPauseIcon = ValueNotifier(false);

  ///! Hint user to swipe up for more ...
  late AnimationController _hintController;
  late Animation<Offset> _hintOffsetAnimation;
  bool _showHint = false;

  @override
  void initState() {
    themeCubit = context.read<ThemeCubit>();
    navCubit = context.read<NavCubit>();
    homeCubit = context.read<HomeCubit>();
    userCubit = context.read<UserCubit>();
    authCubit = context.read<AuthCubit>();
    navCubitSubscription = navCubit.stream.listen((event) {
        if(event.status == NavStatus.onTabChanged) {{
          if(event.currentTabIndex == 0) {
            resumePlayingIfItWasPlaying();
            storyPageActive = true;
           } else  {
            // This is a fix. we set storyPlayingBeforeLeavingPage if only use is leaving the home page
            if(event.previousIndex == 0) {
              setPlayingStateBeforeLeavingAndPauseStory();
            }
            storyPageActive = false;

          }
        }}

        if(event.status == NavStatus.onActiveIndexTappedCompleted) {
          final tabIndex = event.data as int;
          if(tabIndex == 0) {
            _fetchData(pageKey: 1); // refresh page if user taps on home twice
          }
        }


    });
    homeCubit.stream.listen((event) {
      if(event.status == HomeStatus.didPushToNextCompleted) {
        final data = event.data as Map<String, dynamic>;
        final int tabIndex = data['tabIndex'];
        if(tabIndex == 0 ){
          didPushNext();
        }
        if(tabIndex == 2) { // this means if user clicks on create post from the home page
          final previousActiveIndex = context.read<NavCubit>().state.previousIndex;
          if(previousActiveIndex == 0) {
            didPushNext();
          }
        }
      }

      // Next problem is when the create new post (camera) button is clicked

      if(event.status == HomeStatus.didPopFromNextCompleted) {
        final data = event.data as Map<String, dynamic>;
        final int tabIndex = data['tabIndex'];
        if(tabIndex == 0){
          didPopNext();
        }
        if(tabIndex == 2) {
          final previousActiveIndex = context.read<NavCubit>().state.previousIndex;
          if(previousActiveIndex == 0) {
            didPopNext();
          }
        }
      }
    });
    userCubit.stream.listen((event) {
      if(event.status == UserStatus.getDisciplinaryRecordSuccessful) {
        if(event.disciplinaryRecord != null) {
          Future.delayed(const Duration(seconds: 1), () {
            pauseActiveStory();  // pause story if user has a disciplinary case
          });
        }
      }
    });

    authCubit.stream.listen((event) {
      if(event.status == AuthStatus.filtersAppliedCompleted) {
        _fetchData(pageKey: 1); // refresh page if user applies new filters
      }
    });

    storiesFeedsCubit = context.read<StoriesFeedsCubit>();
    // fetch first page
    // do a background fetch of data. if there's already data, don't fetch again
    _fetchData(pageKey: pageKey, returnExistingFeedsForFirstPage: true);
    onWidgetBindingComplete(onComplete: () {

    });
    WidgetsBinding.instance.addObserver(this);
    initHint();
    configureBackgroundFetch();
    // initPlatformState();
    // onWidgetBindingComplete(onComplete: () {
    //   routeObserver.subscribe(this, ModalRoute.of(context)!);
    // });
    super.initState();

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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> configureBackgroundFetch() async {
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

      // We fetch fetch feeds for the first page and store it for faster load times
      const path = AppApiRoutes.feeds;
      final queryParams = { "page": 1, "limit": 20 };
      final results = await context.read<StoriesFeedsCubit>().fetchFeeds(path: path, pageKey: pageKey, queryParams: queryParams);
      if(results.$2 != null && mounted) {
        context.read<StoriesFeedsCubit>().setBackgroundHasRefreshedFeed(hasRefreshed: true);
      }

      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {  // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      debugPrint("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    debugPrint('[BackgroundFetch] configure success: $status');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  void dispose() {
    storiesPageRouteObserver.unsubscribe(this);
    pauseActiveStory();
    preloadPageController.dispose();
    navCubitSubscription?.cancel();
    _hintController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to the RouteObserver in didChangeDependencies
    storiesPageRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {

      if(storyPageActive) {
        // App is in background
        //  requestPostFeedAudioControllers[activeFeedIndex]?.;
        _lastPauseTime = DateTime.now();
        setPlayingStateBeforeLeavingAndPauseStory();
      }

      // Start the background fetch when user leaves the app.
      BackgroundFetch.start().then((int status) {
        debugPrint('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        debugPrint('[BackgroundFetch] start FAILURE: $e');
      });


    } else if (state == AppLifecycleState.resumed) {

      // if (ModalRoute.of(context)?.isCurrent ?? false) {
      //   // The widget is visible and the app has resumed
      //   debugPrint("in current");
      // }
      // if (storyPageActive) {
        // The widget is visible and the app has resumed
        debugPrint("in current");
        // App is in foreground
        // playRequestFeedVideo(position)
       if(storyPageActive) {
         bool requiresFullRefresh = false;
         if (_lastPauseTime != null) {
           final timeInBackground = DateTime.now().difference(_lastPauseTime!);
           final difInSeconds = timeInBackground.inSeconds;
           final backgroundHasRefreshedFeeds = context.read<StoriesFeedsCubit>().state.backgroundHasRefreshedFeeds;
           if(backgroundHasRefreshedFeeds) {
             activeFeedIndex = 0; // since background refreshed all pages we need to reset activeIndex
           }
           if (difInSeconds >= (5 * 60) && !backgroundHasRefreshedFeeds) {
             // If background has not refresh feeds and the user has delayed for more than 30 seconds before getting back to the app, refresh
             _fetchData(pageKey: 1);
             requiresFullRefresh = true;
           }
         }
         if(!requiresFullRefresh) {
           // resumePlayingIfItWasPlaying();
           onWidgetBindingComplete(onComplete: () {
             // resumeActiveStory();
             resumePlayingIfItWasPlaying();

           });
         }
         _lastPauseTime = null;
       }

      // Stop the background fetch when user gets back to the app.
      BackgroundFetch.stop().then((int status) {
        debugPrint('[BackgroundFetch] stop success: $status');
        context.read<StoriesFeedsCubit>().setBackgroundHasRefreshedFeed(hasRefreshed: false);
      });

    }
  }

  @override
  void didPush() {
    // This route was pushed onto the navigator and is now topmost.
    storyPageActive = true;
    debugPrint('SecondPage: didPush');
  }

  @override
  void didPopNext() {
    // This route is again the top route.
    storyPageActive = true;
    resumePlayingIfItWasPlaying();
    debugPrint('SecondPage: didPopNext');
  }

  @override
  void didPop() {
    // This route was popped off the navigator.
    storyPageActive = false;
    debugPrint('SecondPage: didPop');
    setPlayingStateBeforeLeavingAndPauseStory();
  }

  @override
  void didPushNext() {
    // Another route has been pushed above this one.
    storyPageActive = false;
    debugPrint('SecondPage: didPushNext');
    setPlayingStateBeforeLeavingAndPauseStory();
  }




  _setLight() {
    themeCubit.setLightMode();
    themeCubit.setSystemUIOverlaysToLight();
  }


  // returnExistingFeedsForFirstPage = will enable caching and fast serving of feeds
  _fetchData({required int pageKey, bool returnExistingFeedsForFirstPage = false}) async {
      this.pageKey = pageKey;
      const path = AppApiRoutes.feeds;
      final queryParams = { "page": pageKey, "limit": 20 };
      if(pageKey == 1) { pauseActiveStory(); } // We do this to stop video and then refresh to avoid duplicate sounds
      final res = await storiesFeedsCubit.fetchFeeds(path: path, pageKey: pageKey, queryParams: queryParams, returnExistingFeedsForFirstPage: returnExistingFeedsForFirstPage);
      if(res.$2 != null && pageKey == 1) {
        onWidgetBindingComplete(onComplete: () {
          showPauseIcon.value = false;
          activeFeedIndex = 0;
          playActiveStory();
        });
      } // we do this to resume video after refresh
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

  void setPlayingStateBeforeLeavingAndPauseStory() {
    storyPlayingBeforeLeavingPage = activeStoryPlaying;
    debugPrint("storyPlayingBeforeLeavingPage: $storyPlayingBeforeLeavingPage");
    pauseActiveStory();
    debugPrint("storyPlayingBeforeLeavingPage: $storyPlayingBeforeLeavingPage");
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
    requestPostFeedVideoControllers[activeFeedIndex]?.pause();
    activeStoryPlaying = false;
  }

  Future<void> resetActiveStory() async {
     videoControllers[activeFeedIndex]?.seekTo(Duration.zero);
     requestPostFeedVideoControllers[activeFeedIndex]?.seekTo(Duration.zero);
     imageControllers[activeFeedIndex]?.seek(Duration.zero);
     activeStoryPlaying = true;
     showPauseIcon.value = false;
  }

  void resumeActiveStory() async {
    // videoControllers[activeFeedIndex]?.videoPlayerController?.refresh();
    videoControllers[activeFeedIndex]?.play();
    imageControllers[activeFeedIndex]?.play();
    requestPostFeedVideoControllers[activeFeedIndex]?.play();
    activeStoryPlaying = true;
  }

  void playActiveStory({FeedModel? feed}) async {
    // "request post feed"
    requestPostFeedVideoControllers[activeFeedIndex]?.play();
    // The actual post video
    videoControllers[activeFeedIndex]?.play();
    imageControllers[activeFeedIndex]?.play();
    activeStoryPlaying = true;
    //mark video as seen
    if(feed != null) {
      context.read<FeedsCubit>().viewPost(postId: feed.id, action: "seen");
    }
  }

  void usersOnlineHandler(BuildContext context) async {

    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
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
    );

    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);

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

          BlocSelector<UserCubit, UserState, num>(
            selector: (state) {
              return state.onlineUserIds.length;
            },
            builder: (context, onlineUsersCount) {
              if(onlineUsersCount < 1) {
                return const SizedBox.shrink();
              }
              return UnconstrainedBox(
                child: GestureDetector(
                  onTap: () => usersOnlineHandler(context) ,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(padding: const EdgeInsets.all(10),
                    child: Builder(
                      builder: (ctx) {
                        // Calculate icon size based on parent constraints
                        double iconSize = MediaQuery.of(context).size.width * 0.05; // 10% of parent width

                        // Ensure the icon size is not too small or too large
                        if (iconSize < 24) {
                          iconSize = 24;
                        } else if (iconSize > 100) {
                          iconSize = 100;
                        }

                        return Row(
                            children: [
                              Icon(Icons.person, size: iconSize, color: Colors.green,),
                              Text(convertToCompactFigure(onlineUsersCount.toInt()), style: theme.textTheme.bodyMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),)
                            ],
                          );
                      }
                    ),
                  ),
                ),
              );
            },
          ),

          UnconstrainedBox(
            child: GestureDetector(
              onTap: () async {
                context.pushScreen(const NotificationsPage(), rootNavigator: true);
              } ,
              behavior: HitTestBehavior.opaque,
              child: const Padding(padding: EdgeInsets.all(10),
                child: NotificationIconWidget(),
              ),
            ),
          ),

          UnconstrainedBox(
            child: GestureDetector(
              onTap: () async {
                context.pushScreen(const TopSearchPage(), rootNavigator: true);
                // pauseActiveStory();
                // context.push(AppRoutes.searchPage);
              } ,
              behavior: HitTestBehavior.opaque,
              child: Padding(padding: const EdgeInsets.all(10),
                child: Builder(
                  builder: (context) {
                    // Calculate icon size based on parent constraints
                    double iconSize = MediaQuery.of(context).size.width * 0.05; // 10% of parent width

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
          const SizedBox(width: 10,)
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
                            // return  Center(child: Lottie.asset(AppAssets.kLoveLoaderJson ),);
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

                              return Stack(
                                children: [
                                  Builder(builder: (_) {
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
                                              showPauseIcon.value = activeStoryPlaying ? false : true;
                                            },
                                            onFeedEditorOpened: () {
                                              // setPlayingStateBeforeLeavingAndPauseStory();
                                            }, onFeedEditorClosed: () {
                                              // resumePlayingIfItWasPlaying();
                                            },);
                                        }

                                        // Regular stories .....
                                        return Stack(
                                          children: [
                                            FeedItemWidget(
                                              index: i,
                                              preloadPageController: preloadPageController,
                                              videoBuilder: (controller) {
                                                videoControllers[i] = controller;
                                                if(!initialStoryViewed && i == 0) {
                                                  // after initialization mark post as seen
                                                  context.read<FeedsCubit>().viewPost(postId: feed.id, action: "seen");
                                                }
                                              },
                                              imageBuilder: (controller) {
                                                imageControllers[i] = controller;
                                                if(!initialStoryViewed && i == 0) {
                                                  // after initialization mark post as seen
                                                  context.read<FeedsCubit>().viewPost(postId: feed.id, action: "seen");
                                                }
                                              },
                                              onItemTapped: () {
                                                activeStoryPlaying ? pauseActiveStory() : resumeActiveStory();
                                                showPauseIcon.value = activeStoryPlaying ? false : true;
                                              },
                                              onPageChanged: (bool onPageChanged) {
                                                // if(onPageChanged) {
                                                //   setPlayingStateBeforeLeavingAndPauseStory();
                                                // }else{
                                                //   resumePlayingIfItWasPlaying();
                                                // }
                                              },
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
                                  }),

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
                                // context.read<ChatConnectionsCubit>().fetchSuggestedChatUsers();
                              }


                              playActiveStory(feed: feeds[position]);


                              // any time we reach the second (last) video then we fetch more
                              // if(position)
                              final feedsLastPosition = feeds.length - 1;
                              final feedsMidPosition = ((feeds.length - 1) / 2).ceil();
                              final positionToFetch = (feedsMidPosition - 1);
                              if(positionToFetch != lastPositionFetched && position == positionToFetch ) {
                                pageKey++;
                                _fetchData(pageKey: pageKey);
                                lastPositionFetched = positionToFetch;
                                context.read<ChatConnectionsCubit>().fetchSuggestedChatUsers();
                              }


                            },
                            pageSnapping: true,
                            preloadPagesCount: feeds.length,
                            // pageSnapping: false,
                            // physics: const BouncingScrollPhysics(),
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



