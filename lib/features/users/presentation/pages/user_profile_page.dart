import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pulsator/pulsator.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/countries/data/store/countries_cubit.dart';
import 'package:sparkduet/features/countries/data/store/countries_state.dart';
import 'package:sparkduet/features/countries/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_previews_page.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/censored_feed_checker_widget.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/data/store/enums.dart';
import 'package:sparkduet/features/users/data/store/user_bookmarked_feeds_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_feeds_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_state.dart';
import 'package:sparkduet/features/users/presentation/pages/block_user_page.dart';
import 'package:sparkduet/features/users/presentation/pages/report_user_page.dart';
import 'package:sparkduet/features/users/presentation/pages/user_blocked_you_explanation_page.dart';
import 'package:sparkduet/features/users/presentation/pages/you_blocked_user_explanation_page.dart';
import 'package:sparkduet/features/users/presentation/widgets/bookmarked_posts_tab_view_widget.dart';
import 'package:sparkduet/features/users/presentation/widgets/user_posts_tab_view_widget.dart';
import 'package:sparkduet/features/users/presentation/widgets/user_profile_action_widget.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_chip_widget.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class UserProfilePage extends StatefulWidget {

  final UserModel user;
  const UserProfilePage({super.key, required this.user});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  static int aboutYouIndex = 0;
  static int yourPostsIndex = 1;
  late UserCubit userCubit;
  late UserFeedsCubit feedsCubit;
  late AutoScrollController autoScrollController;
  PagingController<int, dynamic>? userPostsPagingController;
  PagingController<int, dynamic>? userBookmarksPagingController;
  late PageController tabController;
  late List<Map<String, dynamic>> tabItems;
  ValueNotifier<int> activeTab = ValueNotifier(0);

  @override
  void initState() {
    userCubit = context.read<UserCubit>();
    feedsCubit = context.read<UserFeedsCubit>();
    userCubit.setUser(widget.user);
    userCubit.setUserBlockedStatus(youBlockedUser: false, userBlockedYou: false);
    userCubit.getUserBlockStatus(profileId: widget.user.id);
    userCubit.fetchUserInfo(userId: widget.user.id);
    autoScrollController = AutoScrollController(
      //add this for advanced viewport boundary. e.g. SafeArea
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).viewInsets.bottom),

      //choose vertical/horizontal
      axis: Axis.vertical,
    );

    tabItems = [
      {
        "key": "your-posts",
        "page": UserPostsTabViewWidget<UserFeedsCubit>(userId: widget.user.id, builder: (controller) => userPostsPagingController ??= controller,)
      },
      {
        "key": "bookmarked-posts",
        "page": BookmarkedPostsTabViewPage<UserBookmarkedFeedsCubit>(userId: widget.user.id,  builder: (controller) => userBookmarksPagingController ??= controller,)
      },
    ];
    tabController = PageController(initialPage: 0);
    userCubit.saveProfileView(profileId: widget.user.id);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void reportUserHandler(BuildContext context) {
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
                  child: ReportUserPage(controller: controller, user: widget.user,)
              );
            }
        ),
      ],
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  void blockUserHandler(BuildContext context) {
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
                  child: BlockUserPage(controller: controller, user: widget.user,)
              );
            }
        ),
      ],
    );
    context.showCustomBottomSheet(
        child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  void showYouBlockedUserPage(BuildContext context) {
    final ch = DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.9,
        builder: (_ , controller) {
          return ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: YouBlockedUserExplanationPage(controller: controller, onCloseTapped: () {
                context.popScreen();
              }, user: widget.user,)
          );
        }
    );
    context.showCustomBottomSheet(child: ch, isDismissible: false,  enableDrag: false, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  void showUserBlockedYouPage(BuildContext context) {
    final ch = DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.9,
        builder: (_ , controller) {
          return ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: UserBlockedYouExplanationPage( onCloseTapped: () {
                context.popScreen();
              },)
          );
        }
    );
    context.showCustomBottomSheet(child: ch,isDismissible: false, enableDrag: false, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  void userCubitListener(BuildContext context, UserState event) {
    if(event.status == UserStatus.setUserBlockedStatusCompleted) {
      if(mounted) {
        if(event.youBlockedUser) {
          showYouBlockedUserPage(context);
        }
        else if(event.userBlockedYou) {
          showUserBlockedYouPage(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final headerContainerHeight = media.size.height * 0.35;
    final headerBackgroundHeight = headerContainerHeight * 0.75;
    final headerIconSize = headerContainerHeight * 0.3;
    final heightBetweenBackgroundAndContainer = headerContainerHeight - headerBackgroundHeight;
    final actionIconSize = heightBetweenBackgroundAndContainer - (10 + 10); // 10 + 10 is the padding top and button



    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: CloseButton(color: AppColors.darkColorScheme.onBackground,),
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<UserCubit, UserState>(
        buildWhen: (_, state){
          return state.status == UserStatus.setUserCompleted;
        },
        listener: userCubitListener,
        builder: (context, userSate) {
          final user = userSate.user ?? widget.user;
          return NestedScrollView(
              controller: autoScrollController,
              headerSliverBuilder: (BuildContext context,
                  bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      width: double.maxFinite,
                      height: headerContainerHeight,
                      // height: 250,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {

                              // if introductory video is part of feedList, show it with the feed list, else just show the intro video
                              if((user.introductoryPost?.mediaPath ?? "").isNotEmpty) {
                                final indexOfVideo = feedsCubit.state.feeds.indexWhere((element) => element.id == user.introductoryPost?.id);
                                if(indexOfVideo > -1){
                                  context.pushScreen(StoriesPreviewsPage(feeds: feedsCubit.state.feeds, initialFeedIndex: indexOfVideo,));
                                }else {
                                  context.pushScreen(StoriesPreviewsPage(feeds: <FeedModel>[user.introductoryPost!], initialFeedIndex: 0,));
                                }
                              }

                            },
                            child: SizedBox(
                              width: double.maxFinite,
                              height: headerBackgroundHeight,
                              child: ColoredBox(
                                color: AppColors.darkColorScheme.surface,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if(user.introductoryPost?.mediaPath != null) ... {

                                      AspectRatio(
                                        aspectRatio: 9 / 16,
                                        child: CensoredFeedCheckerWidget(feed: user.introductoryPost, child: SizedBox(
                                            width: double.maxFinite,
                                            child: Image.network(AppConstants.thumbnailMediaPath(mediaId: user.introductoryPost?.mediaPath ?? ""), fit: BoxFit.cover,)
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
                                    const Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          PulseIcon(
                                            icon: Icons.play_circle,
                                            pulseColor: Colors.red,
                                            iconColor: Colors.white,
                                            iconSize: 24,
                                            innerSize: 30,
                                            pulseSize: 70,
                                            pulseCount: 4,
                                            pulseDuration: Duration(seconds: 4),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: (headerContainerHeight - headerBackgroundHeight) - (headerIconSize / 2),
                              right: 15,
                              child: GestureDetector(
                                  onTap: () {
                                    if((user.info?.profilePicPath ?? "").isNotEmpty) {
                                      context.push(AppRoutes.photoGalleryPage, extra: {"images" : <String>[AppConstants.imageMediaPath(mediaId: user.info?.profilePicPath ?? "")], "showProgressText": false});
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: SizedBox(
                                      // width: theme.brightness == Brightness.dark ? 75 : 70,
                                      // height: theme.brightness == Brightness.dark ? 75 : 70,
                                      width: headerIconSize,
                                      height: headerIconSize,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [

                                          if((user.info?.profilePicPath ?? "").isNotEmpty) ... {

                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: CustomUserAvatarWidget(size: headerIconSize - 6, showBorder: theme.brightness == Brightness.dark ? true : false, fit: BoxFit.cover,
                                                imageUrl: AppConstants.imageMediaPath(mediaId: user.info?.profilePicPath ?? ''), placeHolderName: user.name ?? user.username
                                              ),
                                            )

                                          }else ... {
                                            CustomUserAvatarWidget(size: headerIconSize - 6, showBorder: theme.brightness == Brightness.dark ? true : false, fit: BoxFit.cover, placeHolderName: user.name ?? user.username,)
                                          }
                                        ],
                                      ),
                                    ),
                                  )
                              )
                          ),

                          Positioned(
                              top: headerBackgroundHeight,
                              left: 15,
                              child: SeparatedRow(
                             separatorBuilder: (BuildContext context, int index) {
                               return const SizedBox(width: 10,);
                             },
                             children: [
                               UserProfileActionWidget(size: actionIconSize, icon: FontAwesomeIcons.solidMessage, onTap: () {
                                 context.pushToChatPreview(widget.user );
                               },),
                               UserProfileActionWidget(size: actionIconSize, icon: FontAwesomeIcons.solidFlag, onTap: () {
                                 reportUserHandler(context);
                               },),
                               UserProfileActionWidget(size: actionIconSize, icon: FontAwesomeIcons.ban, onTap: () {
                                 blockUserHandler(context);
                               },),
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: AppColors.buttonBlue.withOpacity(0.1),
                                //     borderRadius: BorderRadius.circular(actionIconSize),
                                //   ),
                                //   padding: const EdgeInsets.all(12),
                                //   margin: const EdgeInsets.symmetric(vertical: 5),
                                //
                                //   child: Center(child: Icon(FeatherIcons.flag,
                                //     // color: theme.colorScheme.onBackground,
                                //     color: AppColors.buttonBlue,
                                //     size: actionIconSize * 0.4,),),
                                // ),

                             ],
                          ))

                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 5,),),

                  SliverToBoxAdapter(
                    child: AutoScrollTag(
                        key: ValueKey(aboutYouIndex),
                        controller: autoScrollController,
                        index: aboutYouIndex,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
                          child: Text("About", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
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

                                if((user.name ?? "").isNotEmpty) ... {
                                  ListTile(
                                    dense: true,
                                    title: Text("Name", style: theme.textTheme.bodyMedium,),
                                    subtitle: (user.name ?? "").isNotEmpty ? Text(user.name ?? "") : null,
                                  )
                                },

                                if((user.info?.bio ?? "").isNotEmpty) ... {
                                  ListTile(
                                    dense: true,
                                    title: Text("Bio",
                                      style: theme.textTheme.bodyMedium,),
                                    subtitle: (user.info?.bio ?? "").isNotEmpty ? Text(user.info?.bio ?? "") : null,
                                    // subtitle: const Text(),
                                  ),
                                },

                                if((user.displayAge ?? 0) > 0) ... {
                                  ListTile(
                                    dense: true,
                                    title: Text("Age", style: theme.textTheme.bodyMedium,),
                                    subtitle: ((user.displayAge ?? 0) > 0) ? Text("${user.displayAge ?? ""}") : null,
                                  )
                                },
                                if((user.info?.gender ?? "").isNotEmpty) ... {
                                  ListTile(
                                    dense: true,
                                    title: Text("Gender",
                                      style: theme.textTheme.bodyMedium,),
                                    subtitle: (user.info?.gender ?? "").isNotEmpty ? Builder(builder: (_) {
                                      final text = AppConstants.genderList.where((element) => element["key"] == (user.info?.gender ?? "")).firstOrNull?["name"];
                                      return Text(text ?? "");
                                    }) : null ,
                                    // subTitle
                                  ),
                                },

                                if((user.info?.race ?? "").isNotEmpty) ... {
                                  ListTile(
                                    dense: true,
                                    title: Text("Race",
                                      style: theme.textTheme.bodyMedium,),
                                    subtitle: (user.info?.race ?? "").isNotEmpty ? Builder(builder: (_) {
                                      final text = AppConstants.races.where((element) => element["key"] == (user.info?.race ?? "")).firstOrNull?["name"];
                                      return Text(text ?? "");
                                    }): null ,
                                    // subTitle
                                  )
                                },

                                if((user.info?.country ?? "").isNotEmpty) ... {
                                  BlocBuilder<CountriesCubit, CountriesState>(
                                    buildWhen: (_, state) {
                                      return state.status == CountryStatus.fetchAllCountriesSuccessful;
                                    },
                                    builder: (context, state) {
                                      return ListTile(
                                    dense: true,
                                    title: Text("Country",
                                      style: theme.textTheme.bodyMedium,),
                                    subtitle: (user.info?.country ?? "").isNotEmpty ? Builder(builder: (_) {
                                      final countryCode = user.info?.country;
                                      final country = state.countries.where((element) => element.countryCode == countryCode).firstOrNull;
                                      if(country == null) {
                                        return const Text("N/A");
                                      }
                                      return Text(country.countryName ?? "");
                                    }): null ,
                                    // subTitle
                                  );
  },
)
                                },

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
                                CustomChipWidget(label: "Posts", active: val == 0, onTap: () {
                                  activeTab.value = 0;
                                  tabController.animateToPage(0, duration: const Duration(milliseconds: 357), curve: Curves.linear);
                                },),
                                CustomChipWidget(label: "Bookmarks", active: val == 1, onTap: () {
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
      ),
    );
  }
}
