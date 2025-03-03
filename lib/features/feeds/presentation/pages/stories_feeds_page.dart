import 'dart:async';
import 'package:better_player/better_player.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:sparkduet/app/routing/routes.dart';
import 'package:sparkduet/core/app_classes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_feeds_cubit.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/stories_feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_explanation_page.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_item_widget.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/request_post_feed_item_widget.dart';
import 'package:sparkduet/features/files/mixin/file_manager_mixin.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';
import 'package:sparkduet/features/home/data/store/home_cubit.dart';
import 'package:sparkduet/features/home/data/store/nav_cubit.dart';
import 'package:sparkduet/features/notifications/presentation/pages/notifications_page.dart';
import 'package:sparkduet/features/notifications/presentation/widgets/notification_icon_widget.dart';
import 'package:sparkduet/features/preferences/data/store/preferences_cubit.dart';
import 'package:sparkduet/features/search/presentation/pages/top_search_page.dart';
import 'package:sparkduet/features/subscriptions/presentation/ui_mixin/subsription_page_mixin.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/features/users/data/store/enums.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_state.dart';
import 'package:sparkduet/features/users/presentation/pages/users_online_page.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
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
  StreamSubscription? navCubitSubscription;
  StreamSubscription? homeCubitSubscription;
  StreamSubscription? userCubitSubscription;
  StreamSubscription? authCubitSubscription;
  int lastPositionFetched = -1;
  // bool initialStoryViewed = false;
  DateTime? _lastPauseTime;
  // bool storyPageActive = true;
  final CurrentPageIsActiveNotifier currentPageIsActiveNotifier = CurrentPageIsActiveNotifier();
  final ValueNotifier<bool> showPlayIcon = ValueNotifier(false);

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
            // resumePlayingIfItWasPlaying();
            currentPageIsActiveNotifier.value = true;
           } else  {
            // // This is a fix. we set storyPlayingBeforeLeavingPage if only use is leaving the home page
            // if(event.previousIndex == 0) {
            //   setPlayingStateBeforeLeavingAndPauseStory();
            // }
            currentPageIsActiveNotifier.value = false;
          }
        }}

        if(event.status == NavStatus.onActiveIndexTappedCompleted) {
          final tabIndex = event.data as int;
          if(tabIndex == 0) {
            _fetchData(pageKey: 1); // refresh page if user taps on home twice
          }
        }


    });
    homeCubitSubscription = homeCubit.stream.listen((event) {
      if(event.status == HomeStatus.didPushToNextCompleted) {
        final data = event.data as Map<String, dynamic>;
        final int tabIndex = data['tabIndex'];
        if(tabIndex == 0 && currentPageIsActiveNotifier.value){
          didPushNext();
        }
        // if(tabIndex == 2) { // this means if user clicks on create post from the home page
        //   final previousActiveIndex = context.read<NavCubit>().state.previousIndex;
        //   if(previousActiveIndex == 0 && currentPageIsActiveNotifier.value) {
        //     didPushNext();
        //   }
        // }
      }

      // Next problem is when the create new post (camera) button is clicked

      if(event.status == HomeStatus.didPopFromNextCompleted) {
        final data = event.data as Map<String, dynamic>;
        final int tabIndex = data['tabIndex'];
        if(tabIndex == 0){
          didPopNext();
        }
        // if(tabIndex == 2 && currentPageIsActiveNotifier.value) {
        //   final previousActiveIndex = context.read<NavCubit>().state.previousIndex;
        //   if(previousActiveIndex == 0) {
        //     didPopNext();
        //   }
        // }
      }
    });
    userCubitSubscription = userCubit.stream.listen((event) {
      if(event.status == UserStatus.getDisciplinaryRecordSuccessful) {

        // Future.delayed(const Duration(seconds: 1), () {
        //   if(event.disciplinaryRecord != null && mounted) {
        //
        //     if(event.disciplinaryRecord?.disciplinaryAction == "banned") {
        //       pauseActiveStory();
        //     }
        //     if(event.disciplinaryRecord?.disciplinaryAction == "warned" && event.disciplinaryRecord?.userReadAt == null) {
        //       pauseActiveStory();
        //     }
        //     if(event.disciplinaryRecord?.disciplinaryAction == "notice"  && event.disciplinaryRecord?.userReadAt == null) {
        //       pauseActiveStory();
        //     }
        //
        //   }
        //   // pauseActiveStory();  // pause story if user has a disciplinary case
        // });

        // if(event.disciplinaryRecord != null) {
        //   Future.delayed(const Duration(seconds: 1), () {
        //     pauseActiveStory();  // pause story if user has a disciplinary case
        //   });
        // }
      }
    });

    authCubitSubscription = authCubit.stream.listen((event) {
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
    // initPlatformState();
    // onWidgetBindingComplete(onComplete: () {
    //   routeObserver.subscribe(this, ModalRoute.of(context)!);
    // });
    currentPageIsActiveNotifier.addListener(currentPageIsActiveListener);
    super.initState();

  }

  void currentPageIsActiveListener() {
    final pageIsActive = currentPageIsActiveNotifier.value;
    if(pageIsActive) {
      if(
      (videoControllers.containsKey(activeFeedIndex) && videoControllers[activeFeedIndex] != null)
      || (imageControllers.containsKey(activeFeedIndex) && imageControllers[activeFeedIndex] != null)
      || (requestPostFeedVideoControllers.containsKey(activeFeedIndex) && requestPostFeedVideoControllers[activeFeedIndex] != null)
      ) {
        playActiveStory();
      }

    }else{
      pauseActiveStory();
    }
  }

  void firstPostInitialized() {
    // activeIndex is expected to be 0 here.
    if(currentPageIsActiveNotifier.value) {
      playActiveStory();
    }else {
      pauseActiveStory();
    }
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
  void dispose() {
    storiesPageRouteObserver.unsubscribe(this);
    pauseActiveStory();
    preloadPageController.dispose();
    navCubitSubscription?.cancel();
    homeCubitSubscription?.cancel();
    userCubitSubscription?.cancel();
    authCubitSubscription?.cancel();
    _hintController.dispose();
    currentPageIsActiveNotifier.dispose();
    resetControllers();
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
    // if(state == AppLifecycleState.hidden) {
    //
    // }

    if (state == AppLifecycleState.paused) {

      if(currentPageIsActiveNotifier.value) {
        pauseActiveStory();
      }

    } else if (state == AppLifecycleState.resumed) {

      // Stop the background fetch when user gets back to the app.

      // if (ModalRoute.of(context)?.isCurrent ?? false) {
      //   // The widget is visible and the app has resumed
      //   debugPrint("in current");
      // }
      // if (storyPageActive) {
        // The widget is visible and the app has resumed
        debugPrint("in current");
        // App is in foreground
        // playRequestFeedVideo(position)
       if(currentPageIsActiveNotifier.value) {

         bool requiresFullRefresh = false;
         final backgroundHasRefreshedFeeds = context.read<StoriesFeedsCubit>().state.backgroundHasRefreshedFeeds;
         if (_lastPauseTime != null) {
           final timeInBackground = DateTime.now().difference(_lastPauseTime!);
           final difInSeconds = timeInBackground.inSeconds;

           //2 * 60
           if (difInSeconds >= (3 * 60) && !backgroundHasRefreshedFeeds) {
             // If background has not refresh feeds and the user has delayed for more than 30 seconds before getting back to the app, refresh
             _fetchData(pageKey: 1);
             requiresFullRefresh = true;
           }
         }
         if(!requiresFullRefresh) {
           if(backgroundHasRefreshedFeeds) {
             _fetchData(pageKey: 1, returnExistingFeedsForFirstPage: true); // for quick access to feeds
           }else {
             // background has not refreshed feeds yet
             try{
               if(videoControllers[activeFeedIndex] == null && imageControllers[activeFeedIndex] == null) {
                 // if the active controller turns null, fetch all feeds again
                 _fetchData(pageKey: 1);
               }else {

                 // resumePlayingIfItWasPlaying();
                 // resumePlayingIfItWasPlaying();

                 // on widget binding complete is important here
                 onWidgetBindingComplete(onComplete: () {
                   if(currentPageIsActiveNotifier.value) {
                     playActiveStory();
                   }
                 });

               }
             }catch(e) {
               _fetchData(pageKey: 1);
             }
           }

         }
         _lastPauseTime = null;
       }



    }
  }

  @override
  void didPush() {
    // This route was pushed onto the navigator and is now topmost.
    currentPageIsActiveNotifier.value = true;
    debugPrint('SecondPage: didPush');
  }

  @override
  void didPopNext() {
    // This route is again the top route.
    currentPageIsActiveNotifier.value = true;
    // resumePlayingIfItWasPlaying();
    debugPrint('SecondPage: didPopNext');
  }

  @override
  void didPop() {
    // This route was popped off the navigator.
    currentPageIsActiveNotifier.value = false;
    debugPrint('SecondPage: didPop');
    // setPlayingStateBeforeLeavingAndPauseStory();
  }

  @override
  void didPushNext() {
    // Another route has been pushed above this one.
    currentPageIsActiveNotifier.value = false;
    debugPrint('SecondPage: didPushNext');
    // setPlayingStateBeforeLeavingAndPauseStory();
  }


  _setLight() {
    themeCubit.setLightMode();
    themeCubit.setSystemUIOverlaysToLight();
  }


  // returnExistingFeedsForFirstPage = will enable caching and fast serving of feeds
  _fetchData({required int pageKey, bool returnExistingFeedsForFirstPage = false}) async {
      this.pageKey = pageKey;
      if(pageKey == 1) {
        // the order is important here
        pauseActiveStory();
        activeFeedIndex = 0;
        resetActiveStory();
        resetControllers();
      } // We do this to stop video and then refresh to avoid duplicate sounds
      const path = AppApiRoutes.feeds;
      final queryParams = { "page": pageKey, "limit": 5 };
      await storiesFeedsCubit.fetchFeeds(path: path, pageKey: pageKey, queryParams: queryParams, returnExistingFeedsForFirstPage: returnExistingFeedsForFirstPage);
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
  }

  Future<void> resetActiveStory() async {
     videoControllers[activeFeedIndex]?.seekTo(Duration.zero);
     requestPostFeedVideoControllers[activeFeedIndex]?.seekTo(Duration.zero);
     imageControllers[activeFeedIndex]?.seek(Duration.zero);
  }

  Future<void> resetControllers() async {
    videoControllers.forEach((key, value) {
      videoControllers[key]?.dispose();
    });
    imageControllers.forEach((key, value) {
      imageControllers[key]?.dispose();
    });
    requestPostFeedVideoControllers.forEach((key, value) {
      requestPostFeedVideoControllers[key]?.dispose();
    });
    videoControllers.clear();
    requestPostFeedVideoControllers.clear();
    imageControllers.clear();
  }

  // void resumeActiveStory() async {
  //   // videoControllers[activeFeedIndex]?.videoPlayerController?.refresh();
  //   videoControllers[activeFeedIndex]?.play();
  //   imageControllers[activeFeedIndex]?.play();
  //   requestPostFeedVideoControllers[activeFeedIndex]?.play();
  //   activeStoryPlaying = true;
  // }

  void playActiveStory() async {
    // "request post feed"

    showPlayIcon.value = false;
    // The actual post video
    videoControllers[activeFeedIndex]?.play();
    imageControllers[activeFeedIndex]?.play();
    requestPostFeedVideoControllers[activeFeedIndex]?.play();
    //mark video as seen
    final feeds = context.read<StoriesFeedsCubit>().state.feeds;
    final feed = feeds[activeFeedIndex];
    if((feed.id ?? 0) > 0) {
      context.read<FeedsCubit>().viewPost(postId: feed.id, action: "seen");
    }
  }

  void usersOnlineHandler(BuildContext context) async {

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

  void showFindLoveExplanationModal(BuildContext context) {
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
            minChildSize: 0.9,
            shouldCloseOnMinExtent: true,
            builder: (_ , controller) {
              return ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: StoriesExplanationPage(controller: controller,)
              );
            }
        ),
      ],
    );
    context.showCustomBottomSheet(
        child: ch,
        isDismissible: true,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:  GestureDetector(
          onTap: () {
            showFindLoveExplanationModal(context);
          },
          behavior: HitTestBehavior.opaque,
          child: const Text("Find love ❤️", style: TextStyle(color: Colors.white,
              // fontSize: 16
          ),),
        ),
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
                              Icon(Icons.person, size: iconSize, color: AppColors.onlineGreen,),
                              Text(convertToCompactFigure(onlineUsersCount.toInt()), style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.onlineGreen, fontWeight: FontWeight.bold, fontSize: 14),)
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
                                            if(i == 0)  { firstPostInitialized(); }
                                          },
                                            onTap: () {
                                              (requestPostFeedVideoControllers[i]?.isPlaying() ?? false) ? pauseActiveStory() : playActiveStory();
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
                                                if(i == 0)  { firstPostInitialized(); }
                                              },
                                              imageBuilder: (controller) {
                                                imageControllers[i] = controller;
                                                if(i == 0)  { firstPostInitialized(); }
                                              },
                                              onItemTapped: () {
                                                if(i == activeFeedIndex) {
                                                  if((videoControllers[i]?.isPlaying() ?? false) || (imageControllers[i]?.playing ?? false)) {
                                                    pauseActiveStory();
                                                    showPlayIcon.value = true;
                                                  }else {
                                                    playActiveStory();
                                                  }
                                                }
                                              },
                                              onPageChanged: (bool onPageChanged) {
                                                // if(onPageChanged) {
                                                //   setPlayingStateBeforeLeavingAndPauseStory();
                                                // }else{
                                                //   resumePlayingIfItWasPlaying();
                                                // }
                                              },
                                              feed: feed,
                                              // autoPlay: !initialStoryViewed && i == 0,
                                              autoPlay: false,
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

                                  ValueListenableBuilder<bool>(valueListenable: showPlayIcon, builder: (_, show, ch) {
                                    if(show) {
                                      return ch!;
                                    }
                                    return const SizedBox.shrink();
                                  }, child:  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        if((videoControllers[i]?.isPlaying() ?? false) || (imageControllers[i]?.playing ?? false)) {
                                          pauseActiveStory();
                                          showPlayIcon.value = true;
                                        }else {
                                          playActiveStory();
                                        }
                                      }, behavior: HitTestBehavior.opaque,
                                        child: const CustomPlayPauseIconWidget(eventType: BetterPlayerEventType.pause,)),
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
                              // if(initialStoryViewed == false) {
                              //   initialStoryViewed = true;
                              // }

                              ///! active index is now current position

                              playActiveStory();


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
                            // preloadPagesCount: 3,
                            // pageSnapping: false,
                            // physics: const BouncingScrollPhysics(),
                            physics: const CustomFastPageScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            controller: preloadPageController,
                          );
                        },
                      )

                  ),


                  BlocBuilder<AuthFeedsCubit, FeedState>(
                    builder: (context, state) {
                      final isPostInProgress = state.feeds.where((element) => element.status == "loading").isNotEmpty;
                      if(!isPostInProgress) {
                        return const SizedBox.shrink();
                      }
                      return FadeInUp(child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.navyBlue,
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // context.read<NavCubit>().requestTabChange(NavPosition.profile);
                            context.read<NavCubit>().requestTabChange(NavPosition.profile, data: {"focusOnYourPosts":true});
                            // context.go(AppRoutes.authProfile, extra: {"focusOnYourPosts":true});
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                LoadingAnimationWidget.fourRotatingDots(
                                  color: Colors.amber,
                                  // color: AppColors.buttonBlue,
                                  size: 20,
                                ),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(15),
                                //   child: SizedBox(width: 25, height: 25,
                                //     child: Container(
                                //       decoration: const BoxDecoration(
                                //           color: Colors.green
                                //       ),
                                //       child: const Icon(Icons.check, color: Colors.white, size: 17,),
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(width: 10,),
                                const Text("Your post is processing ...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),),
                                const Spacer(),
                                const Icon(Icons.keyboard_arrow_right_outlined, color: Colors.white, size: 24,),
                              ],
                            ),
                          ),
                        ),
                      ));
                    },
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




