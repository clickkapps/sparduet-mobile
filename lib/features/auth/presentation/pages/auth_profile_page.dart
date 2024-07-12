import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pulsator/pulsator.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_classes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_bookmarked_feeds_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_feeds_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_state.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/features/auth/presentation/mixin/auth_profile_mixin.dart';
import 'package:sparkduet/features/countries/data/store/countries_cubit.dart';
import 'package:sparkduet/features/countries/data/store/countries_state.dart';
import 'package:sparkduet/features/countries/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/feed_editor_camera_page.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_previews_page.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/censored_feed_checker_widget.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';
import 'package:sparkduet/features/home/data/store/nav_cubit.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/subscriptions/presentation/ui_mixin/subsription_page_mixin.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_state.dart';
import 'package:sparkduet/features/users/presentation/pages/unread_viewers_page.dart';
import 'package:sparkduet/features/users/presentation/widgets/bookmarked_posts_tab_view_widget.dart';
import 'package:sparkduet/features/users/presentation/widgets/user_posts_tab_view_widget.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_chip_widget.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class AuthProfilePage extends StatefulWidget {

  final bool focusOnYourPosts;
  final bool focusOnBookmarks;
  const AuthProfilePage({super.key, this.focusOnBookmarks = false, this.focusOnYourPosts = false});

  @override
  State<AuthProfilePage> createState() => _AuthProfilePageState();
}

class _AuthProfilePageState extends State<AuthProfilePage> with TickerProviderStateMixin, AuthUIMixin, SubscriptionPageMixin {

  static int aboutYouIndex = 0;
  static int yourPostsIndex = 1;

  late AutoScrollController autoScrollController;
  late PageController tabController;
  late List<Map<String, dynamic>> tabItems;
  PagingController<int, dynamic>? userPostsPagingController;
  PagingController<int, dynamic>? userBookmarksPagingController;
  late AuthCubit authCubit;
  late UserCubit userCubit;
  late AuthFeedsCubit feedsCubit;
  StreamSubscription? feedCubitSubscription;
  StreamSubscription? authubitSubscription;
  ValueNotifier<int> activeTab = ValueNotifier(0);
  dynamic profilePhoto;
  late StreamSubscription navStreamSubscription;
  late NavCubit navCubit;

  @override
  void initState() {
    super.initState();
    autoScrollController = AutoScrollController(
      //add this for advanced viewport boundary. e.g. SafeArea
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).viewInsets.bottom),

      //choose vertical/horizontal
      axis: Axis.vertical,
    );
    authCubit = context.read<AuthCubit>();
    userCubit = context.read<UserCubit>();
    userCubit.countUnreadProfileViews();
    feedsCubit = context.read<AuthFeedsCubit>();
    feedCubitSubscription = feedsCubit.stream.listen((event) {
        if(event.status == FeedStatus.postFeedInProgress) {
            // userPostsPagingController?.itemList = <FeedModel>[...event.feeds];
            tabController.jumpToPage(0);
            autoScrollController.scrollToIndex(aboutYouIndex, preferPosition: AutoScrollPosition.begin, duration: const Duration(milliseconds: 500));
        }
        if(event.status == FeedStatus.postFeedFailed) {
          // userPostsPagingController?.itemList = event.feeds;
        }
        if(event.status == FeedStatus.postFeedSuccessful) {
          // userPostsPagingController?.itemList = event.feeds;
          // context.showSnackBar("Post created", appearance: NotificationAppearance.info);
        }
        if(event.status == FeedStatus.postFeedProcessFileCompleted) {
          // userPostsPagingController?.itemList = event.feeds;
          final feed = event.data as FeedModel;
          if(mounted) {
            //! if the purpose of the video is introduction, and there's an existing video
            // change the data source
            if(feed.purpose == "introduction") {
              authCubit.setIntroductoryPost(feed);
            }
          }
        }
        if(event.status == FeedStatus.unCompletedPostsWithFeeds) {
          // userPostsPagingController?.itemList = event.feeds;
        }
    });
    authubitSubscription = authCubit.stream.listen((event) {
        if(event.status == AuthStatus.updateAuthUserProfilePhotoSuccessful) {
           // when profile photo updates.. set the new pic
            setState(() {
              profilePhoto = authCubit.state.authUser?.info?.profilePicPath;
            });
        }
        // if(even)
    });

    navCubit = context.read<NavCubit>();
    navStreamSubscription = navCubit.stream.listen((event) {

      if(event.status == NavStatus.onActiveIndexTappedCompleted) {
        final tabIndex = event.data as int;
        if(tabIndex == 3) {
          autoScrollController.animateTo(0.00, duration: const Duration(milliseconds: 275), curve: Curves.linear);
        }
      }

      if(event.status == NavStatus.onTabChangeRequested) {
        if(event.requestedTabIndex == NavPosition.profile) {
          if(event.data is Map<String, dynamic>) {
            final data = event.data as Map<String, dynamic>;
            final focusOnPosts = data["focusOnYourPosts"] as bool?;
            if(focusOnPosts ?? false) {
              autoScrollController.scrollToIndex(aboutYouIndex, preferPosition: AutoScrollPosition.begin, duration: const Duration(milliseconds: 500));
            }
          }
        }
        // final tabIndex = event.data as int;
        // if(tabIndex == 3) {
        //   autoScrollController.animateTo(0.00, duration: const Duration(milliseconds: 275), curve: Curves.linear);
        // }
      }


    });

    final authenticatedUser = authCubit.state.authUser;
    tabItems = [
      {
        "key": "your-posts",
        "page": UserPostsTabViewWidget<AuthFeedsCubit>(userId: authenticatedUser?.id, builder: (controller) => userPostsPagingController ??= controller,)
      },
      {
        "key": "bookmarked-posts",
        "page": BookmarkedPostsTabViewPage<AuthBookmarkedFeedsCubit>(userId: authenticatedUser?.id, builder: (controller) => userBookmarksPagingController ??= controller,)
      },
    ];
    tabController = PageController(initialPage: 0);


    // setProfilePhoto
    profilePhoto = authCubit.state.authUser?.info?.profilePicPath;
    onWidgetBindingComplete(onComplete: (){
      if(widget.focusOnYourPosts) {
        autoScrollController.scrollToIndex(aboutYouIndex, preferPosition: AutoScrollPosition.begin, duration: const Duration(milliseconds: 500));
      }
    });


  }

  @override
  void dispose() {
    tabController.dispose();
    feedCubitSubscription?.cancel();
    navStreamSubscription.cancel();
    authubitSubscription?.cancel();
    super.dispose();
  }

  void changePhotoHandler(BuildContext context) {
    context.pickFileFromGallery(fileType: FileType.image, onSuccess: (file) async {

      if(context.mounted) {
        setState(() { profilePhoto = file; });
        context.read<AuthCubit>().updateAuthUserProfilePhoto(file: file);
      }

    }, onError: (error) {

    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  void didUpdateWidget(covariant AuthProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void changeIntroductionVideoHandler(BuildContext context) {
    openFeedCamera(context, purpose: AppConstants.introductoryPostFeedPurpose);
  }


  void profileViewersHandler(BuildContext context) {

    if(!context.read<SubscriptionCubit>().state.subscribed) {
      showSubscriptionPaywall(context, openAsModal: true);
      return;
    }

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
                  child: UnreadViewersPage(controller: controller)
              );
            }
        ),
      ],
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
          leading: CloseButton(color: AppColors.darkColorScheme.onBackground, onPressed: () {
            context.read<NavCubit>().requestTabChange(NavPosition.home);
          },),
        ),
        extendBodyBehindAppBar: true,
        body: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (_, state) {
            return state.status == AuthStatus.setAuthUserInfoCompleted;
          },
          builder: (context, authState) {
            final authUser = authState.authUser;
            return NestedScrollView(
                controller: autoScrollController,
                headerSliverBuilder: (BuildContext context,
                    bool innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 225,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if(authUser?.introductoryPost != null) {
                                  context.showCustomListBottomSheet(items: [
                                    const ListItem(id: 'preview', title: "Preview video"),
                                    const ListItem(id: 'change', title: "Change video")
                                  ], onItemTapped: (item) {
                                    if(item.id == "preview") {
                                      // if introductory video is part of feedList, show it with the feed list, else just show the intro video
                                      final indexOfVideo = feedsCubit.state.feeds.indexWhere((element) => element.id == authUser?.introductoryPost?.id);
                                      if(indexOfVideo > -1){
                                        context.pushScreen(StoriesPreviewsPage(feeds: feedsCubit.state.feeds, initialFeedIndex: indexOfVideo,));
                                      }else {
                                        context.pushScreen(StoriesPreviewsPage(feeds: <FeedModel>[authUser!.introductoryPost!], initialFeedIndex: 0,));
                                      }

                                    }else {
                                      changeIntroductionVideoHandler(context);
                                    }
                                  });
                                }else{
                                  changeIntroductionVideoHandler(context);
                                }

                              },
                              child: SizedBox(
                                width: double.maxFinite,
                                height: 190,
                                child: ColoredBox(
                                  color: AppColors.darkColorScheme.surface,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if(authUser?.introductoryPost?.mediaPath != null) ... {

                                        AspectRatio(
                                          aspectRatio: 9 / 16,
                                          child: CensoredFeedCheckerWidget(feed: authUser?.introductoryPost, child: SizedBox(
                                              width: double.maxFinite,
                                              child: Image.network(AppConstants.thumbnailMediaPath(mediaId: authUser?.introductoryPost?.mediaPath ?? ""), fit: BoxFit.cover,)
                                          ),),
                                        )
                                        // CustomVideoPlayer(
                                        //   videoSource: VideoSource.network,
                                        //   networkUrl: AppConstants.videoMediaPath(playbackId: authUser?.introductoryPost?.mediaPath ?? ""),
                                        //   fit: BoxFit.contain,
                                        //   mute: true,
                                        //   hls: true,
                                        //   autoPlay: false,
                                        //   builder: (controller) => introVideoPlayerController = controller,
                                        // )
                                      },
                                      Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const IgnorePointer(
                                              ignoring: true,
                                              child: PulseIcon(
                                                icon: Icons.play_circle,
                                                pulseColor: Colors.red,
                                                iconColor: Colors.white,
                                                iconSize: 24,
                                                innerSize: 30,
                                                pulseSize: 70,
                                                pulseCount: 4,
                                                pulseDuration: Duration(seconds: 4),
                                              ),
                                            ),
                                            if(authUser?.introductoryPost == null) ... {
                                              Text("Introduce yourself here", style: TextStyle(
                                                  color: AppColors.darkColorScheme.onBackground),)
                                            }
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 15,
                                child: GestureDetector(
                                    onTap: () {
                                      if(profilePhoto is String) {
                                        // give user option to preview or pick from gallery
                                        context.showCustomListBottomSheet(items: [
                                          const ListItem(id: 'preview', title: "Preview Photo"),
                                          const ListItem(id: 'change', title: "Change Photo")
                                        ], onItemTapped: (item) {
                                          if(item.id == "preview") {
                                            context.push(AppRoutes.photoGalleryPage, extra: {"images" : <String>[AppConstants.imageMediaPath(mediaId: (profilePhoto as String))], "showProgressText": false});
                                          }else {
                                            changePhotoHandler(context);
                                          }
                                        });
                                        return;
                                      }
                                      changePhotoHandler(context);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: SizedBox(
                                        width: theme.brightness == Brightness.dark ? 77 : 70,
                                        height: theme.brightness == Brightness.dark ? 77 : 70,
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if(profilePhoto is File) ... {
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: Image.file(profilePhoto, fit: BoxFit.cover, width: 70, height: 70,),
                                                  )
                                                }
                                                else if(profilePhoto is String) ... {
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: CustomUserAvatarWidget(size: 70, showBorder: theme.brightness == Brightness.dark ? true : false, fit: BoxFit.cover,
                                                      imageUrl: AppConstants.imageMediaPath(mediaId: profilePhoto), placeHolderName: authUser?.name ?? authUser?.username
                                                    ),
                                                  )

                                                }else ... {
                                                  CustomUserAvatarWidget(size: 70, showBorder: theme.brightness == Brightness.dark ? true : false, fit: BoxFit.cover, placeHolderName: authUser?.name ?? authUser?.username,)
                                                }
                                              ],
                                            ),
                                            BlocBuilder<AuthCubit, AuthState>(
                                                builder: (cx, authState){
                                                  if(authState.status == AuthStatus.updateAuthUserProfilePhotoInProgress){
                                                    return const Align(
                                                      alignment: Alignment.center,
                                                      child: CustomAdaptiveCircularIndicator(),
                                                    );
                                                  }
                                                  return const SizedBox.shrink();
                                                }
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                )
                            )

                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 10,),),

                    SliverToBoxAdapter(
                      child: SeparatedColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10,);
                        },
                        children: [
                          BlocSelector<UserCubit, UserState, num>(
                            selector: (state) {
                              return state.unreadViewersCount;
                            },
                            builder: (context, unreadViewersCount) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),

                                child: GestureDetector(
                                  onTap: () => profileViewersHandler(context),
                                  behavior: HitTestBehavior.opaque,
                                  child: CustomCard(
                                    padding: 10,
                                    child: SizedBox(
                                      width: double.maxFinite,
                                      child: Row(
                                        children: [

                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              ClipRRect(
                                                child: Stack(
                                                  children: [
                                                    const CustomUserAvatarWidget(size: 35,),
                                                    Positioned.fill(
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(35),
                                                        child: BackdropFilter(
                                                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                                          child: Container(
                                                            color: Colors.transparent,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned( left: 35 * 0.5,child: Stack(children: [
                                                const CustomUserAvatarWidget(size: 35,),
                                                Positioned.fill(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(35),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                                      child: Container(
                                                        color: Colors.transparent,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],)),
                                              // Positioned(left: (35 + 35 * 0.5) * , child: CustomUserAvatarWidget(size: 35,)),
                                            ],),
                                          const SizedBox(width: (35 * 0.5) + 10,),
                                          Expanded(child:
                                          Builder(
                                            builder: (context) {
                                              String message = "See who viewed your profile";
                                              if(unreadViewersCount > 0)  {
                                                message = "$unreadViewersCount+ people viewed your profile";
                                              }
                                              return Text(message, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.normal, color: theme.colorScheme.secondary),);
                                            }
                                          ))
                                        ],
                                      ),),
                                  ),
                                ),);
                            },
                          )
                          ,
                          AutoScrollTag(
                              key: ValueKey(aboutYouIndex),
                              controller: autoScrollController,
                              index: aboutYouIndex,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
                                child: Text("About you", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                              )
                          ),
                        ],
                      ),
                    ),


                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: SeparatedColumn(
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 15,);
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: CustomCard(padding: 5, child: SeparatedColumn(
                                separatorBuilder: (BuildContext context, int index) {
                                  return const CustomBorderWidget();
                                },
                                children: [
                                  ListTile(
                                    dense: true,
                                    title: Text("Name", style: theme.textTheme.bodyMedium,),
                                    subtitle: (authUser?.name ?? "").isNotEmpty ? Text(authUser?.name ?? "") : null,
                                    trailing: Icon(
                                      Icons.edit, color: theme.colorScheme.onBackground,
                                      size: 14,),
                                    onTap: () {
                                      showAuthProfileUpdateModal(context, showName: true);
                                    },
                                  ),
                                  ListTile(
                                      dense: true,
                                      title: Text("Bio",
                                        style: theme.textTheme.bodyMedium,),
                                      subtitle: (authUser?.info?.bio ?? "").isNotEmpty ? Text(authUser?.info?.bio ?? "") : null,
                                      // subtitle: const Text(),
                                      trailing: Icon(Icons.edit,
                                        color: theme.colorScheme.onBackground,
                                        size: 14,),
                                    onTap: () {
                                      showAuthProfileUpdateModal(context, showBio: true);
                                    },
                                  ),
                                  ListTile(
                                      dense: true,
                                      title: Text("Age", style: theme.textTheme.bodyMedium,),
                                      subtitle: ((authUser?.displayAge ?? 0) > 0) ? Text("${authUser?.displayAge ?? ""}") : null,
                                      trailing: Icon(Icons.edit,
                                        color: theme.colorScheme.onBackground,
                                        size: 14,),
                                    onTap: () {
                                      showAuthProfileUpdateModal(context, showAge: true);
                                    },
                                  ),
                                  ListTile(
                                      dense: true,
                                      title: Text("Gender",
                                        style: theme.textTheme.bodyMedium,),
                                      subtitle: (authUser?.info?.gender ?? "").isNotEmpty ? Builder(builder: (_) {
                                        final text = AppConstants.genderList.where((element) => element["key"] == (authUser?.info?.gender ?? "")).firstOrNull?["name"];
                                        return Text(text ?? "");
                                      }) : null ,
                                      // subTitle
                                      trailing: Icon(Icons.edit,
                                        color: theme.colorScheme.onBackground,
                                        size: 14,),
                                    onTap: () {
                                      showGenderSelectorListWidget(context);
                                    },
                                  ),

                                  ListTile(
                                    dense: true,
                                    title: Text("Race",
                                      style: theme.textTheme.bodyMedium,),
                                    subtitle: (authUser?.info?.race ?? "").isNotEmpty ? Builder(builder: (_) {
                                      final text = AppConstants.races.where((element) => element["key"] == (authUser?.info?.race ?? "")).firstOrNull?["name"];
                                      return Text(text ?? "");
                                    }): null ,
                                    // subTitle
                                    trailing: Icon(Icons.edit,
                                      color: theme.colorScheme.onBackground,
                                      size: 14,),
                                    onTap: () {
                                      showRaceSelectorListWidget(context);
                                    },
                                  ),

                                  BlocBuilder<CountriesCubit, CountriesState>(
                                    buildWhen: (_, state) {
                                      return state.status == CountryStatus.fetchAllCountriesSuccessful;
                                    },
                                    builder: (context, state) {
                                      return ListTile(
                                    dense: true,
                                    title: Text("Country",
                                      style: theme.textTheme.bodyMedium,),
                                    subtitle: (authUser?.info?.country ?? "").isNotEmpty ? Builder(builder: (_) {
                                      final countryCode = authUser?.info?.country;
                                      final country = state.countries.where((element) => element.countryCode == countryCode).firstOrNull;
                                      if(country == null) {
                                        return const Text("N/A");
                                      }
                                      return Text(country.countryName ?? "");
                                    }): null ,
                                    // subTitle
                                    trailing: Icon(Icons.edit,
                                      color: theme.colorScheme.onBackground,
                                      size: 14,),
                                    onTap: () {
                                      showLocationSelectorPage(context);
                                    },
                                  );
  },
),

                                ],
                              ),),
                            ),
                          ],

                        ),
                      ),
                    ),

                    /// Set user preferences
                    // SliverToBoxAdapter(
                    //   child: AutoScrollTag(
                    //       key: ValueKey(yourPreferencesIndex),
                    //       controller: autoScrollController,
                    //       index: yourPreferencesIndex,
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                    //         child: Text("Your preferences", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                    //       )
                    //   ),
                    // ),

                    // SliverToBoxAdapter(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 15),
                    //     child: SeparatedColumn(
                    //       separatorBuilder: (BuildContext context, int index) {
                    //         return const SizedBox(height: 15,);
                    //       },
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(horizontal: 15),
                    //           child: CustomCard(padding: 5, child: SeparatedColumn(
                    //             separatorBuilder: (BuildContext context, int index) {
                    //               return const CustomBorderWidget();
                    //             },
                    //             children: [
                    //               ListTile(
                    //                 dense: true,
                    //                 title: Text(
                    //                   "Preferred gender", style: theme.textTheme.bodyMedium,),
                    //                 // subtitle: const Text("All except men"),
                    //                 trailing: Icon(
                    //                   Icons.edit, color: theme.colorScheme.onBackground,
                    //                   size: 14,),
                    //               ),
                    //               ListTile(
                    //                   dense: true,
                    //                   title: Text("Preferred age group",
                    //                     style: theme.textTheme.bodyMedium,),
                    //                   trailing: Icon(Icons.edit,
                    //                     color: theme.colorScheme.onBackground,
                    //                     size: 14,)
                    //               ),
                    //               ListTile(
                    //                   dense: true,
                    //                   title: Text(
                    //                     "Preferred race", style: theme.textTheme.bodyMedium,),
                    //                   trailing: Icon(Icons.edit,
                    //                     color: theme.colorScheme.onBackground,
                    //                     size: 14,)
                    //               ),
                    //               ListTile(
                    //                   dense: true,
                    //                   title: Text("Preferred nationalities",
                    //                     style: theme.textTheme.bodyMedium,),
                    //                   trailing: Icon(Icons.edit,
                    //                     color: theme.colorScheme.onBackground,
                    //                     size: 14,)
                    //               ),
                    //             ],
                    //           ),),
                    //         ),
                    //       ],
                    //
                    //     ),
                    //
                    //   ),
                    // ),


                    SliverToBoxAdapter(
                      child: AutoScrollTag(
                          key: ValueKey(yourPostsIndex),
                          controller: autoScrollController,
                          index: yourPostsIndex,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            scrollDirection: Axis.horizontal,
                            child: ValueListenableBuilder<int>(valueListenable: activeTab, builder: (_, val, __) {
                              return SeparatedRow(
                                separatorBuilder: (BuildContext context, int index) {
                                  return const SizedBox(width: 0,);
                                },
                                children: [
                                  BlocBuilder<AuthFeedsCubit, FeedState>(
                                    builder: (context, authState) {
                                      final isPostInProgress = authState.feeds.where((element) => element.status == "loading").isNotEmpty;
                                      return CustomChipWidget(labelWidget: Row(
                                        children: [
                                          Text("Your Posts", style: TextStyle(color: val == 0 ? AppColors.darkColorScheme.onBackground : theme.colorScheme.onBackground,),),
                                          if(val == 0 && !isPostInProgress) ... {
                                            const SizedBox(width: 5,),
                                            Icon(Icons.refresh, size: 16, color: val == 0 ? AppColors.darkColorScheme.onBackground : theme.colorScheme.onBackground,)
                                          }
                                        ],
                                      ), active: (val == 0), onTap: () {
                                        if(activeTab.value == 0) {
                                          if(isPostInProgress) { return; }
                                          userPostsPagingController?.refresh();
                                          return;
                                        }
                                        activeTab.value = 0;
                                        tabController.animateToPage(0, duration: const Duration(milliseconds: 357), curve: Curves.linear);
                                      },);
                                    },
                                  )
                                  ,

                                  CustomChipWidget(
                                    // label: "Bookmarked posts",
                                    labelWidget: Row(
                                      children: [
                                        Text("Bookmarked posts", style: TextStyle(color: val == 1 ? AppColors.darkColorScheme.onBackground : theme.colorScheme.onBackground,),),
                                        if(val == 1) ... {
                                          const SizedBox(width: 5,),
                                          Icon(Icons.refresh, size: 16, color: val == 1 ? AppColors.darkColorScheme.onBackground : theme.colorScheme.onBackground,)
                                        }
                                      ],
                                    ),
                                    active: val == 1, onTap: () {
                                    if(activeTab.value == 1) {
                                      userBookmarksPagingController?.refresh();
                                      return;
                                    }
                                    activeTab.value = 1;
                                    tabController.animateToPage(1, duration: const Duration(milliseconds: 357), curve: Curves.linear);
                                  },),
                                ],
                              );
                            }),
                          )
                      ),
                    )
                  ];
                }, body: PageView.builder(
              controller: tabController,
              onPageChanged: (index) => activeTab.value = index,
              itemCount: tabItems.length,
              itemBuilder: (BuildContext context, int index) {
                final tabItem = tabItems[index];
                final page = tabItem['page'] as Widget;
                return page;
              },
            )


            );
          },
        ));
  }

}
