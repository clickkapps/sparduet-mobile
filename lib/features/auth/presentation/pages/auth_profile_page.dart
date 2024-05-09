import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pulsator/pulsator.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:sparkduet/app/app.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/users/presentation/widgets/bookmarked_posts_tab_view_widget.dart';
import 'package:sparkduet/features/users/presentation/widgets/user_posts_tab_view_widget.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_chip_widget.dart';

class AuthProfilePage extends StatefulWidget {
  const AuthProfilePage({super.key});

  @override
  State<AuthProfilePage> createState() => _AuthProfilePageState();
}

class _AuthProfilePageState extends State<AuthProfilePage> with TickerProviderStateMixin {

  late PageController tabController;
  late List<Map<String, dynamic>> tabItems;
  PagingController<int, dynamic>? userPostsPagingController;
  late AuthCubit authCubit;
  late FeedsCubit feedsCubit;
  StreamSubscription? feedCubitSubscription;
  ValueNotifier<int> activeTab = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    feedsCubit = context.read<FeedsCubit>();
    feedCubitSubscription = feedsCubit.stream.listen((event) {
        if(event.status == FeedStatus.postFeedInProgress) {
            userPostsPagingController?.itemList = event.feeds;
        }
        if(event.status == FeedStatus.postFeedFailed) {
          userPostsPagingController?.itemList = event.feeds;
        }
        if(event.status == FeedStatus.postFeedSuccessful) {
          userPostsPagingController?.itemList = event.feeds;
        }
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
  }

  @override
  void dispose() {
    tabController.dispose();
    feedCubitSubscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: NestedScrollView(headerSliverBuilder: (BuildContext context,
            bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                },
                behavior: HitTestBehavior.opaque,
                child: ColoredBox(
                  color: AppColors.darkColorScheme.surface,
                  child: AspectRatio(aspectRatio: 16 / 12,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PulseIcon(
                            icon: Icons.play_circle,
                            pulseColor: Colors.red,
                            iconColor: Colors.white,
                            iconSize: 44,
                            innerSize: 54,
                            pulseSize: 116,
                            pulseCount: 4,
                            pulseDuration: Duration(seconds: 4),
                          ),
                          Text("Tap to introduce yourself", style: TextStyle(
                              color: AppColors.darkColorScheme.onBackground),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Text("About you", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
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
                            title: Text(
                              "Name", style: theme.textTheme.bodyMedium,),
                            trailing: Icon(
                              Icons.edit, color: theme.colorScheme.onBackground,
                              size: 14,),
                          ),
                          ListTile(
                              dense: true,
                              title: Text("Email",
                                style: theme.textTheme.bodyMedium,),
                              trailing: Icon(Icons.edit,
                                color: theme.colorScheme.onBackground,
                                size: 14,)
                          ),
                          ListTile(
                              dense: true,
                              title: Text(
                                "Age", style: theme.textTheme.bodyMedium,),
                              trailing: Icon(Icons.edit,
                                color: theme.colorScheme.onBackground,
                                size: 14,)
                          ),
                          ListTile(
                              dense: true,
                              title: Text("Gender",
                                style: theme.textTheme.bodyMedium,),
                              trailing: Icon(Icons.edit,
                                color: theme.colorScheme.onBackground,
                                size: 14,)
                          ),
                        ],
                      ),),
                    ),
                  ],

                ),
              ),
            ),

            SliverToBoxAdapter(
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
                        tabController.animateToPage(0, duration: Duration.zero, curve: Curves.linear);
                      },),
                      CustomChipWidget(label: "Bookmarked posts", active: val == 1, onTap: () {
                        activeTab.value = 0;
                        tabController.animateToPage(1, duration: Duration.zero, curve: Curves.linear);
                      },),
                    ],
                  );
                }),
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
    ));
  }

}
