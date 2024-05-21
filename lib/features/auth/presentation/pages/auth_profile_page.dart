import 'dart:async';
import 'dart:io';
import 'package:better_player/better_player.dart';
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
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_state.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/features/auth/presentation/mixin/auth_profile_mixin.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/feed_editor_camera_page.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_previews_page.dart';
import 'package:sparkduet/features/home/data/nav_cubit.dart';
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

class _AuthProfilePageState extends State<AuthProfilePage> with TickerProviderStateMixin, AuthUIMixin {

  static int aboutYouIndex = 0;
  static int yourPostsIndex = 1;

  late AutoScrollController autoScrollController;
  late PageController tabController;
  late List<Map<String, dynamic>> tabItems;
  PagingController<int, dynamic>? userPostsPagingController;
  late AuthCubit authCubit;
  late FeedsCubit feedsCubit;
  StreamSubscription? feedCubitSubscription;
  StreamSubscription? authubitSubscription;
  ValueNotifier<int> activeTab = ValueNotifier(0);
  dynamic profilePhoto;

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
    feedsCubit = context.read<FeedsCubit>();
    feedCubitSubscription = feedsCubit.stream.listen((event) {
        if(event.status == FeedStatus.postFeedInProgress) {
            userPostsPagingController?.itemList = event.feeds;
            tabController.jumpToPage(0);
            autoScrollController.scrollToIndex(aboutYouIndex, preferPosition: AutoScrollPosition.begin, duration: const Duration(milliseconds: 500));
        }
        if(event.status == FeedStatus.postFeedFailed) {
          userPostsPagingController?.itemList = event.feeds;
        }
        if(event.status == FeedStatus.postFeedSuccessful) {
          userPostsPagingController?.itemList = event.feeds;
          context.showSnackBar("Post created", appearance: NotificationAppearance.info);
        }
        if(event.status == FeedStatus.postFeedProcessFileCompleted) {
          userPostsPagingController?.itemList = event.feeds;
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
          userPostsPagingController?.itemList = event.feeds;
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
    final authenticatedUser = authCubit.state.authUser;
    tabItems = [
      {
        "key": "your-posts",
        "page": UserPostsTabViewWidget(userId: authenticatedUser?.id, builder: (controller) => userPostsPagingController = controller,)
      },
      {
        "key": "bookmarked-posts",
        "page": BookmarkedPostsTabViewPage(userId: authenticatedUser?.id,)
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
    super.dispose();
  }

  void changePhotoHandler(BuildContext context) {
    context.pickFileFromGallery(fileType: FileType.image, onSuccess: (file) {
      setState(() { profilePhoto = file; });
      context.read<AuthCubit>().updateAuthUserProfilePhoto(file: file);
    }, onError: (error) {

    });
  }

  void changeIntroductionVideoHandler(BuildContext context) {
    openFeedCamera(context, purpose: AppConstants.introductoryPostFeedPurpose);
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
                                          child: SizedBox(
                                              width: double.maxFinite,
                                              child: Image.network(AppConstants.thumbnailMediaPath(mediaId: authUser?.introductoryPost?.mediaPath ?? ""), fit: BoxFit.cover,)),
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
                                            const PulseIcon(
                                              icon: Icons.play_circle,
                                              pulseColor: Colors.red,
                                              iconColor: Colors.white,
                                              iconSize: 24,
                                              innerSize: 30,
                                              pulseSize: 70,
                                              pulseCount: 4,
                                              pulseDuration: Duration(seconds: 4),
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
                                        width: 70,
                                        height: 70,
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
                                                  CustomUserAvatarWidget(size: 70, showBorder: theme.brightness == Brightness.dark ? true : false, fit: BoxFit.cover,
                                                    imageUrl: AppConstants.imageMediaPath(mediaId: profilePhoto),
                                                  )
                                                }else ... {
                                                  CustomUserAvatarWidget(size: 70, showBorder: theme.brightness == Brightness.dark ? true : false, fit: BoxFit.cover)
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

                    SliverToBoxAdapter(
                      child: AutoScrollTag(
                          key: ValueKey(aboutYouIndex),
                          controller: autoScrollController,
                          index: aboutYouIndex,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
                            child: Text("About you", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                          )
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
                                      subtitle: (authUser?.info?.gender ?? "").isNotEmpty ? Text(authUser?.info?.gender ?? "") : null ,
                                      // subTitle
                                      trailing: Icon(Icons.edit,
                                        color: theme.colorScheme.onBackground,
                                        size: 14,),
                                    onTap: () {
                                      showGenderSelectorListWidget(context);
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
                                  CustomChipWidget(label: "Your posts", active: val == 0, onTap: () {
                                    activeTab.value = 0;
                                    tabController.animateToPage(0, duration: const Duration(milliseconds: 357), curve: Curves.linear);
                                  },),
                                  CustomChipWidget(label: "Bookmarked posts", active: val == 1, onTap: () {
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
