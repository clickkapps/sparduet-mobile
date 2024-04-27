import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';

class HomePage extends StatefulWidget {

  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int activeIndex = 0;

  ///
  int get calculateSelectedIndex {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location();
    if (location.startsWith(AppRoutes.inbox)) { return 1; }
    if (location.startsWith(AppRoutes.authProfile)) { return 2; }
    if (location.startsWith(AppRoutes.preferences)) { return 3; }
    if (location.startsWith(AppRoutes.home)) { return 0; }
    return activeIndex;
  }

  _setDark() {
    final themeCubit = context.read<ThemeCubit>();
    themeCubit.setDarkMode();
    themeCubit.setSystemUIOverlaysToDark();
  }

  _setLight() {
    final themeCubit = context.read<ThemeCubit>();
    themeCubit.setLightMode();
    themeCubit.setSystemUIOverlaysToLight();
  }

  /// Switch between pages when user taps on any of the bottom navigation bar menus
  void onItemTapped(int index) {

    // an existing active index has been tapped again
    if(index == activeIndex) {
      // homeCubit.onActiveIndexTapped(index);
      return;
    }

    // if(index == 0) {
    //   _setDark();
    // }else {
    //   _setLight();
    // }

    activeIndex = index;
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.inbox);
        break;
      case 2:
        context.go(AppRoutes.authProfile);
      case 3:
        context.go(AppRoutes.preferences);
        break;
      default:
        context.go(AppRoutes.home);
        break;
    }

  }


  @override
  void initState() {

    super.initState();
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
          child: BottomNavigationBar(
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
          ),
        )
    );
  }
}
