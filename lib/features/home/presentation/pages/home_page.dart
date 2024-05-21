import 'dart:async';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/feed_editor_camera_page.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/introduction_widget.dart';
import 'package:sparkduet/features/home/data/enums.dart';
import 'package:sparkduet/features/home/data/nav_cubit.dart';

class HomePage extends StatefulWidget {

  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int activeIndex = 0;
  late NavCubit navCubit;
  late FeedsCubit feedsCubit;
  StreamSubscription? navCubitStreamSubscription;
  StreamSubscription? feedsCubitStreamSubscription;

  @override
  void initState() {
    navCubit = context.read<NavCubit>();
    feedsCubit = context.read<FeedsCubit>();
    navCubit.stream.listen((event) {
        if(event.status == NavStatus.onTabChangeRequested) {
            onItemTapped(event.currentTabIndex);
        }
    });
    feedsCubitStreamSubscription = feedsCubit.stream.listen((event) {
      if(event.status == FeedStatus.postFeedSuccessful) {
        final feed = event.data as FeedModel;
        // Post has just been created by he user

        //! if the purpose of the video is introduction, fetch the updated user detail.
        if(feed.purpose == "introduction") {
          if(mounted) {
            context.read<AuthCubit>().fetchAuthUserInfo();
          }
        }
      }
      if(event.status == FeedStatus.postFeedFailed) {
        context.showSnackBar(event.message, appearance: NotificationAppearance.error);
      }
    });

    // fetch and update user profile info
    context.read<AuthCubit>().fetchAuthUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    navCubitStreamSubscription?.cancel();
    feedsCubitStreamSubscription?.cancel();
    super.dispose();
  }

  ///
  int get calculateSelectedIndex {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location();
    if (location.startsWith(AppRoutes.inbox)) { return 1; }
    if (location.startsWith(AppRoutes.authProfile)) { return 3; }
    if (location.startsWith(AppRoutes.preferences)) { return 4; }
    if (location.startsWith(AppRoutes.home)) { return 0; }
    return activeIndex;
  }


  void initiatePost(BuildContext context) {
    // videoControllers[activeFeedIndex]?.pause();
    // final theme = Theme.of(context);
    // check if this is user's first feed. Then show introductory video page
    // context.pushScreen(const IntroductionPage());
    // Else show the list of options user can talk about
    final authUser = context.read<AuthCubit>().state.authUser;
    if(authUser?.introductoryPost != null) {
      openFeedCamera(context);
      return;
    }

    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: IntroductionWidget(onAccept: (purpose) async{
          context.popScreen();
          openFeedCamera(context, purpose: purpose);
        },),
      )
    );

    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), backgroundColor: Colors.transparent, enableBottomPadding: false).then((value) {

    });

  }
  

  /// Switch between pages when user taps on any of the bottom navigation bar menus
  void onItemTapped(int index) {

    // an existing active index has been tapped again
    context.read<NavCubit>().onTabChange(index);

    if(index == 2) {
      initiatePost(context);
      return;
    }

    if(index == activeIndex) {
      // homeCubit.onActiveIndexTapped(index);
      return;
    }

    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.inbox);
        break;
      case 3:
        context.go(AppRoutes.authProfile);
      case 4:
        context.go(AppRoutes.preferences);
        break;
      default:
        context.go(AppRoutes.home);
        break;
    }

    activeIndex = index;

  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: widget.child,
        bottomNavigationBar: Theme(
          data: theme.copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
             children: [
               BlocBuilder<FeedsCubit, FeedState>(
                 builder: (context, state) {
                   if(state.status == FeedStatus.postFeedInProgress) {
                     return LinearProgressIndicator(minHeight: 2, color: theme.colorScheme.primary,);
                   }
                   return const SizedBox.shrink();
                 },
               ),
               BottomNavigationBar(
                 type: BottomNavigationBarType.fixed,
                 showSelectedLabels: true,
                 showUnselectedLabels: true,
                 backgroundColor: theme.colorScheme.surface,
                 selectedFontSize: 12,
                 unselectedFontSize: 12,
                 elevation: 0,
                 items:  <BottomNavigationBarItem>[
                   BottomNavigationBarItem(
                     // icon: Icon(FeatherIcons.home, color: theme.colorScheme.onBackground, size: 20),
                     icon: Icon(FeatherIcons.home, color: theme.colorScheme.onBackground, size: 20),
                     activeIcon: Icon(FeatherIcons.home, color: theme.colorScheme.primary, size: 20),
                     label: 'Home',
                   ),
                   BottomNavigationBarItem(
                       icon: Icon(FeatherIcons.messageCircle, color: theme.colorScheme.onBackground, size: 20),
                       activeIcon: Icon(FeatherIcons.messageCircle, color: theme.colorScheme.primary, size: 20),
                       label: 'Inbox'
                   ),
                   BottomNavigationBarItem(
                       icon: UnconstrainedBox(
                         child: Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(100),
                             color: theme.colorScheme.primary,
                           ),
                           padding: const EdgeInsets.all(8),
                           child: Icon(Icons.add, color: theme.colorScheme.onPrimary, size: 25,),
                         ),
                       ),
                       label: ''
                   ),
                   BottomNavigationBarItem(
                       icon: Icon(FeatherIcons.user, color: theme.colorScheme.onBackground, size: 20),
                       activeIcon: Icon(FeatherIcons.user, color: theme.colorScheme.primary, size: 20),
                       label: 'Profile'
                   ),
                   BottomNavigationBarItem(
                       icon: Icon(FeatherIcons.moreHorizontal, color: theme.colorScheme.onBackground, size: 20),
                       activeIcon: Icon(FeatherIcons.moreHorizontal, color: theme.colorScheme.primary, size: 20),
                       label: 'More'
                   ),
                 ],
                 currentIndex: calculateSelectedIndex,
                 onTap: onItemTapped,
                 iconSize: 20,
                 selectedItemColor: theme.colorScheme.primary,
               )
             ],
          ),
        )
    );
  }
}
