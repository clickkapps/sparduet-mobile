import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:open_store/open_store.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/app/routing/routes.dart';
import 'package:sparkduet/core/app_audio_service.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/core/app_injector.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_feeds_cubit.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/features/auth/presentation/mixin/auth_profile_mixin.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_preview_cubit.dart';
import 'package:sparkduet/features/chat/presentation/widgets/chat_icon_widget.dart';
import 'package:sparkduet/features/countries/data/store/countries_cubit.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/feed_editor_camera_page.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/introduction_widget.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';
import 'package:sparkduet/features/home/data/store/home_cubit.dart';
import 'package:sparkduet/features/home/data/store/nav_cubit.dart';
import 'package:sparkduet/features/home/data/repositories/socket_connection_repository.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_cubit.dart';
import 'package:sparkduet/features/preferences/data/store/preferences_cubit.dart';
import 'package:sparkduet/features/auth/presentation/mixin/auth_mixin.dart';
import 'package:sparkduet/features/search/data/store/search_cubit.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/users/data/models/user_disciplinary_record_model.dart';
import 'package:sparkduet/features/users/data/store/enums.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/features/users/presentation/pages/user_account_banned_page.dart';
import 'package:sparkduet/features/users/presentation/pages/user_account_notice_page.dart';
import 'package:sparkduet/features/users/presentation/pages/user_account_warned_page.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:notification_permissions/notification_permissions.dart' as n_permission;
import 'package:new_version_plus/new_version_plus.dart';
import '../../../../core/app_injector.dart' as di;

class HomePage extends StatefulWidget {

  final Widget child;
  final List<GlobalKey<NavigatorState>> navigatorKeys;
  const HomePage({super.key, required this.child, required this.navigatorKeys});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver, AuthMixin, AuthUIMixin, RouteAware  {

  int activeIndex = 0;
  late NavCubit navCubit;
  late AuthFeedsCubit authFeedsCubit;
  late AuthCubit authCubit;
  late UserCubit userCubit;
  StreamSubscription? navCubitStreamSubscription;
  StreamSubscription? authFeedsCubitStreamSubscription;
  StreamSubscription? userCubitStreamSubscription;
  StreamSubscription? authCubitStreamSubscription;
  StreamSubscription? cubeChatConnectionStateStream;
  AppLifecycleState? appState;
  final newVersion = NewVersionPlus();
  bool appInitialized = false;


  @override
  void initState() {
    navCubit = context.read<NavCubit>();
    authCubit = context.read<AuthCubit>();
    authFeedsCubit = context.read<AuthFeedsCubit>();
    userCubit = context.read<UserCubit>();
    navCubitStreamSubscription = navCubit.stream.listen((event) {
        if(event.status == NavStatus.onTabChangeRequested) {
          if(event.requestedTabIndex != null) {
            if(event.requestedTabIndex == NavPosition.profile) {
              onItemTapped(event.requestedTabIndex!, data: event.data);
              return;
            }
            if(event.requestedTabIndex == NavPosition.home) {
              onItemTapped(event.requestedTabIndex!, data: event.data);
              return;
            }
            onItemTapped(event.requestedTabIndex!);
          }

        }
    });

    userCubitStreamSubscription = userCubit.stream.listen((event) {
      if(event.status == UserStatus.getDisciplinaryRecordSuccessful) {

        EasyDebounce.debounce('disciplinary-action', const Duration(milliseconds: 1000), () {
          if(event.disciplinaryRecord != null && mounted) {
            if(event.disciplinaryRecord?.disciplinaryAction == "banned") {
              showUserAccountBannedPage(context, event.disciplinaryRecord!);
            }
            if(event.disciplinaryRecord?.disciplinaryAction == "warned" && event.disciplinaryRecord?.userReadAt == null) {
              showUserAccountWarnedPage(context, event.disciplinaryRecord!);
            }
            if(event.disciplinaryRecord?.disciplinaryAction == "notice"  && event.disciplinaryRecord?.userReadAt == null) {
              showUserAccountNoticePage(context, event.disciplinaryRecord!);
            }
          }
        });


      }
    });

    authCubitStreamSubscription = authCubit.stream.listen((event) {
      if(event.status == AuthStatus.setAuthUserInfoCompleted) {
          if((event.authUser?.info?.preferredNationalities ?? "").isEmpty){
            if(mounted) {
              logout(context);
            }
          }
      }

    });

    authFeedsCubitStreamSubscription = authFeedsCubit.stream.listen((event) async {

      if(event.status == FeedStatus.postFeedSuccessful){
          // check if we should as user to update bio
          promptUserToUpdatePersonalData();
      }

      if(event.status == FeedStatus.postFeedProcessFileCompleted) {
        // final data = event.data as Map<String, dynamic>;
        // Post has just been created by he user

        final feed = event.data as FeedModel;
        if(mounted) {
          //! if the purpose of the video is introduction, and there's an existing video
          // change the data source
          if(feed.purpose == "introduction") {
            context.read<AuthCubit>().fetchAuthUserInfo();
          }
        }

        //! if the purpose of the video is introduction, fetch the updated user detail.

        if(mounted)  {
          context.showSnackBar("Your post is ready", onTap: () {
            context.read<NavCubit>().requestTabChange(NavPosition.profile, data: {"focusOnYourPosts":true});
          }, appearance: NotificationAppearance.success);
        }

      }
      if(event.status == FeedStatus.postFeedFailed) {
        if(mounted){
          context.showSnackBar(event.message, appearance: NotificationAppearance.error);
        }

      }
    });

    // fetch and update user profile info
    appState = WidgetsBinding.instance.lifecycleState;
    WidgetsBinding.instance.addObserver(this);
    onWidgetBindingComplete(onComplete: () {
      attemptInitializations();
      establishConnection();
    });
    super.initState();
  }

  @override
  void dispose() {
    navCubitStreamSubscription?.cancel();
    authFeedsCubitStreamSubscription?.cancel();
    cubeChatConnectionStateStream?.cancel();
    userCubitStreamSubscription?.cancel();
    authCubitStreamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    homePageRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // This route was pushed onto the navigator and is now topmost.
    debugPrint('HomePage: didPush');
  }

  @override
  void didPopNext() {
    // This route is again the top route.
    context.read<HomeCubit>().didPopFromNext(tabIndex: activeIndex);
    debugPrint('HomePage: didPopNext');
  }

  @override
  void didPop() {
    // This route was popped off the navigator.
    debugPrint('HomePage: didPop');
  }

  @override
  void didPushNext() {
    // Another route has been pushed above this one.
    context.read<HomeCubit>().didPushToNext(tabIndex: activeIndex);
    debugPrint('HomePage: didPushNext');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homePageRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  // this is called when app initializes and as well as when there a change in network connection
  void attemptInitializations() async {
    if(await isNetworkConnected() && mounted) {

      appInitialized = true;

      context.read<AuthCubit>().fetchAuthUserInfo();
      // AppAudioService.loadAllAudioFiles(AppConstants.audioLinks);
      context.read<CountriesCubit>().fetchAllCountries();
      context.read<SearchCubit>().fetchPopularSearchTerms();
      context.read<SearchCubit>().fetchRecentSearchTerms();
      final authUser = context.read<AuthCubit>().state.authUser;
      context.read<ChatConnectionsCubit>().setAuthenticatedUser(authUser);
      context.read<ChatPreviewCubit>().setAuthenticatedUser(authUser);
      context.read<ChatConnectionsCubit>().fetchChatConnections();
      context.read<ChatConnectionsCubit>().fetchSuggestedChatUsers();
      context.read<PreferencesCubit>().fetchUserSettings();
      promptUserToSubscribeToPushNotification(authUser?.username ?? "");
      listenForPushNotifications();
      context.read<NotificationsCubit>().countUnseenNotifications();
      context.read<UserCubit>().addOnlineUser(userId: authUser?.id); // set user as online
      context.read<UserCubit>().getDisciplinaryRecord(userId: authUser?.id);
      context.read<HomeCubit>().initializeSocketConnection().then((value) {
        context.read<UserCubit>().listenToServerNotificationUpdates(authUser: authUser);
        context.read<NotificationsCubit>().listenToServerNotificationUpdates(authUser: authUser);
        context.read<ChatConnectionsCubit>().setServerPushChannels();
        context.read<ChatConnectionsCubit>().listenToServerChatUpdates();
        context.read<ChatConnectionsCubit>().getTotalUnreadChatMessages();

      });
      context.read<SubscriptionCubit>().initializeSubscription(authUser?.publicKey ?? "").then((value) {
        context.read<SubscriptionCubit>().getSubscriptionStatus(); // set subscription status
      });
    }


  }

  void showUserAccountBannedPage(BuildContext context, UserDisciplinaryRecordModel disRecord) {
    final ch = DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.9,
        builder: (_ , controller) {
          return ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: UserAccountBannedPage(disRecord: disRecord, controller: controller,)
          );
        }
    );
    context.showCustomBottomSheet(child: ch,isDismissible: false, enableDrag: false, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  void showUserAccountWarnedPage(BuildContext context, UserDisciplinaryRecordModel disRecord) {
    final ch = DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.9,
        builder: (_ , controller) {
          return ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: UserAccountWarnedPage( disRecord: disRecord, controller: controller,)
          );
        }
    );
    context.showCustomBottomSheet(child: ch,isDismissible: false, enableDrag: false, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }
  void showUserAccountNoticePage(BuildContext context, UserDisciplinaryRecordModel disRecord) {
    final ch = DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.9,
        builder: (_ , controller) {
          return ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: UserAccountNoticePage(disRecord: disRecord, controller: controller,)
          );
        }
    );
    context.showCustomBottomSheet(child: ch,isDismissible: false, enableDrag: false, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }


  void establishConnection() async {

    // reconnect if connection is lost
    cubeChatConnectionStateStream = Connectivity().onConnectivityChanged.listen((connectivityType) {
      if (AppLifecycleState.resumed != appState) return;
      if(!appInitialized) {
        attemptInitializations();
      }

    });
  }

  void promptUserToSubscribeToPushNotification(String userId) async {


    // open prompt for user to enable notification
    n_permission.PermissionStatus permissionStatus = await n_permission.NotificationPermissions.getNotificationPermissionStatus();

    if( permissionStatus != n_permission.PermissionStatus.granted) {

      if(!mounted) return;

      context.showConfirmDialog(
        title: "Enable notification alerts",
        subtitle: "Sparkduet would like to send you push notifications for new activities on your account",
        confirmAction: "Accept",
        cancelAction: "Decline",
        onCancelTapped: () {
          /// User still decided to deny push notification after explanation
          //! prompt user to update app even if push notifcation is cancelled
          promptUserToUpdateApp();
        },
        onConfirmTapped: () async {

          // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
          await OneSignal.Notifications.requestPermission(true);

        },

      );

    }else {
      registerUserForPushNotification(userId);
    }

  }

  void promptUserToUpdatePersonalData() async{
    final prompt = await context.read<AuthCubit>().shouldPromptAuthUserToUpdateBasicInfo();
    if(prompt && mounted) {
      showAuthProfileUpdateModal(context, showName: true, showAge: true, showBio: true, showGender: true, showRace: true, title: "Let's update your bio now").then((value) {
        context.read<AuthCubit>().setPromptBasicInfoCompleted();
      });
    }
  }

  /// Listen for push notifications section -----
  void listenForPushNotifications() {

    // When the app is already opened
    OneSignal.Notifications.addForegroundWillDisplayListener(foregroundWillDisplayListener);

    // When the app is opened from external push notification alert
    OneSignal.Notifications.addClickListener(pushNotificationTappedListener);


    OneSignal.User.pushSubscription.addObserver((state) {
      if(mounted) {
        debugPrint("customLog -> Onesignal: pushSubscription-> ${state.current.jsonRepresentation()}");
        // context.showSnackBar("pushNotificationTappedListener called");
        if(state.current.optedIn) {
          final currentUser = context.read<AuthCubit>().state.authUser;
          if(currentUser?.username != null) {
            registerUserForPushNotification(currentUser!.username!);
          }
        }
      }

    });

  }

  void registerUserForPushNotification(String userId) async {

    debugPrint("customLog: userId for push notification: $userId");
    if(userId.isNotEmpty) {
      await OneSignal.login(userId);
    }
    promptUserToUpdateApp();

  }

  ///! push
  //! Onesignal notification listeners
  // When the app is already opened
  foregroundWillDisplayListener(OSNotificationWillDisplayEvent event) {

    final data = event.notification.additionalData;

    // don't show chat push notification if user is already in the app
    if((data?.containsKey("pushType") ?? false) && data!['pushType'] == "chat") {
      event.preventDefault();
    }

    debugPrint('customLog -> Onesignal: NOTIFICATION Received in foreground: $event');

    EasyDebounce.debounce(
        'foregroundWillDisplayListener-home',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 1000),    // <-- The debounce duration
            () {

          /// preventDefault to not display the notification
          // if((data?.containsKey("type") ?? false) && (data!['type'] as String).contains("interest")) {
          //   if(data.containsKey("id")){
          //     final id = data["id"] as String;
          //     // fetch interest and navigate user to interest preview
          //   }
          // }
          //     context.push(AppRoutes.)


        }            // <-- The target method
    );


  }

  //  When the app is opened from external push notification alert
  pushNotificationTappedListener(OSNotificationClickEvent event) async {
    debugPrint('customLog -> Onesignal: NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');

    EasyDebounce.debounce(
        'pushNotificationTappedListener-home',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 1000),    // <-- The debounce duration
            () async {

          final data = event.notification.additionalData;

          if((data?.containsKey("pushType") ?? false) && data!['pushType'] == "chat") {

            final currentUser = context.read<AuthCubit>().state.authUser;
            if(currentUser == null) {return;}
            // go to chat preview page
            final chatIdString = data["chatConnectionId"] as String;
            final chatId = int.tryParse(chatIdString);
            if(chatId == null) { return; }
            final chatConnection = await context.read<ChatConnectionsCubit>().getChatConnectionById(chatConnectionId: chatId.toInt());
            if(chatConnection == null) {return;}
            final otherParticipant = chatConnection.participants?.where((participant) => participant.id != currentUser.id).firstOrNull;
            if(otherParticipant == null) {return;}

            if(mounted) {
              context.pushToChatPreview({
                "user": otherParticipant,
                "connection": chatConnection
              });
            }

          }else {
            // currently all notification are related to auth user profile, this will cange
            // in the future. profile_views
            onWidgetBindingComplete(onComplete: () {
              if((data?.containsKey("pushType") ?? false) && data!['pushType'] == "profile_views") {
                context.read<NavCubit>().requestTabChange(NavPosition.profile);//
              }

              if((data?.containsKey("pushType") ?? false) && data!['pushType'] == "story_likes") {
                context.read<NavCubit>().requestTabChange(NavPosition.profile);//
              }

            });
          }

        }            // <-- The target method
    );




  }

  Future<void> promptUserToUpdateApp() async {
    try{
      final versionStatus = await newVersion.getVersionStatus();
      debugPrint("versionStatus?.canUpdate ${versionStatus?.canUpdate}"); // (true)
      debugPrint("versionStatus?.localVersion ${versionStatus?.localVersion}"); // // (1.2.1)
      debugPrint("versionStatus?.storeVersion ${versionStatus?.storeVersion}"); // (1.2.3)
      debugPrint("versionStatus?.appStoreLink ${versionStatus?.appStoreLink}"); // (https://itunes.apple.com/us/app/google/id284815942?mt=8)

      //&& versionStatus.canUpdate
      if(versionStatus != null && versionStatus.canUpdate) {

        final remoteConfig = FirebaseRemoteConfig.instance;
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          // minimumFetchInterval: kReleaseMode ? const Duration(hours: 1) : const Duration(seconds: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ));

        var storeVersionAndroid = versionStatus.storeVersion;
        var storeVersionIOS = versionStatus.storeVersion;
        var  releaseNotesAndroid ="Get the latest version of the app";
        var releaseNotesIOS = "Get the latest version of the app";
        var forceUpdateAndroid = false;
        var forceUpdateIOS = false;

        await remoteConfig.setDefaults( {
          "storeVersionAndroid": storeVersionAndroid,
          "storeVersionIOS": storeVersionIOS,
          "releaseNotesAndroid": releaseNotesAndroid,
          "releaseNotesIOS": releaseNotesIOS,
          "forceUpdateAndroid": forceUpdateAndroid,
          "forceUpdateIOS": forceUpdateIOS
        });

        await remoteConfig.ensureInitialized();
        await remoteConfig.fetchAndActivate();

        if(!mounted){
          return;
        }

        storeVersionAndroid = remoteConfig.getString("storeVersionAndroid");
        storeVersionIOS = remoteConfig.getString("storeVersionIOS");
        releaseNotesAndroid = remoteConfig.getString("releaseNotesAndroid");
        releaseNotesIOS = remoteConfig.getString("releaseNotesIOS");
        forceUpdateAndroid = remoteConfig.getBool("forceUpdateAndroid");
        forceUpdateIOS = remoteConfig.getBool("forceUpdateIOS");

        if(Platform.isAndroid) {

          if(storeVersionAndroid == versionStatus.storeVersion) {
            // remote config for the latest update and description
            context.showConfirmDialog(title: 'Update available',
              subtitle: releaseNotesAndroid,
              showCancelButton: forceUpdateAndroid ? false : true,
              isDismissible: forceUpdateAndroid ? false : true,
              showCloseButton: forceUpdateAndroid ? false : true,
              confirmAction: "Update",
              onConfirmTapped: () async {

                _openStore();

              },
            );
          }

        }else if(Platform.isIOS) {

          if(storeVersionIOS == versionStatus.storeVersion) {

            // remote config for the latest update and description
            context.showConfirmDialog(title: 'Update available',
              subtitle: releaseNotesIOS,
              isDismissible: forceUpdateIOS ? false : true,
              showCancelButton: forceUpdateIOS ? false : true,
              showCloseButton: forceUpdateIOS ? false : true,
              confirmAction: "Update",
              onConfirmTapped: () async {

                _openStore();

              },
            );

          }


        }


      }
      else{
        promptUserToUpdatePersonalData();
      }
    }catch(e) {
      promptUserToUpdatePersonalData();
    }

  }
  void _openStore(){
    OpenStore.instance.open(
      appStoreId: '6473719700', // AppStore id of your app for iOS
      androidAppBundleId: 'com.sparkduet.android', // Android app bundle package name
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appState = state;

    if (AppLifecycleState.paused == state) {
      final authUser = context.read<AuthCubit>().state.authUser;
      debugPrint("didChangeAppLifecycleState: paused");
      if(authUser != null) {
        context.read<UserCubit>().removeOnlineUser(userId: authUser.id);
      }

    } else if (AppLifecycleState.resumed == state) {
      debugPrint("didChangeAppLifecycleState: resumed");
      // just for an example user was saved in the local storage
      final authUser = context.read<AuthCubit>().state.authUser;
      if(authUser != null) {

        context.read<UserCubit>().addOnlineUser(userId: authUser.id);
        /// anytime we resume get user subscription status
        context.read<SubscriptionCubit>().initializeSubscription(authUser.publicKey ?? "").then((value) {
          context.read<SubscriptionCubit>().getSubscriptionStatus(); // set subscription status
        });

      }


    }
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


  void initiatePost(BuildContext context) async {
    const newIndex = 2;
    // videoControllers[activeFeedIndex]?.pause();
    // final theme = Theme.of(context);
    // check if this is user's first feed. Then show introductory video page
    // context.pushScreen(const IntroductionPage());
    // Else show the list of options user can talk about
    final authUser = context.read<AuthCubit>().state.authUser;
    if(authUser?.introductoryPost != null) {
      // activeIndex = newIndex;
      // context.read<NavCubit>().onTabChange(newIndex);
      await openFeedCamera(context);
      // an existing active index has been tapped again
      // if(context.mounted) {
      //   final previousTab = context.read<NavCubit>().state.previousIndex;
      //   context.read<NavCubit>().onTabChange(previousTab);
      // }
      return;
    }

    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: IntroductionWidget(onAccept: (purpose) async{
          context.popScreen();
          await openFeedCamera(context, purpose: purpose);
          // if(context.mounted) {
          //   final previousTab = context.read<NavCubit>().state.previousIndex;
          //   context.read<NavCubit>().onTabChange(previousTab);
          // }

        },),
      )
    );

    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), backgroundColor: Colors.transparent, enableBottomPadding: false).then((value) {
      // final previousTab = context.read<NavCubit>().state.previousIndex;
      // context.read<NavCubit>().onTabChange(previousTab);
    });

  }
  

  /// Switch between pages when user taps on any of the bottom navigation bar menus
  void onItemTapped(int newIndex, {dynamic data}) {

    if(!context.mounted) {
      return;
    }

    // Pop all inner pages in the current tab
    widget.navigatorKeys[activeIndex].currentState?.popUntil((route) => route.isFirst);
    Navigator.of(context).popUntil((Route<dynamic> route) {return route.isFirst;});

    if(newIndex == 2) {
      initiatePost(context);
      return;
    }

    // an existing active index has been tapped again
    context.read<NavCubit>().onTabChange(newIndex);

    bool emitOnActiveIndexTapped = true;

    if(data != null && data is Map<String, dynamic> && data.containsKey("emitOnActiveIndexTapped")) {
      emitOnActiveIndexTapped = (data['emitOnActiveIndexTapped'] as bool);
    }

    if(newIndex == activeIndex && emitOnActiveIndexTapped) {
      context.read<NavCubit>().onActiveIndexTapped(newIndex);
      return;
    }


    activeIndex = newIndex;
    switch (newIndex) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.inbox);
        break;
      case 3:
        context.go(AppRoutes.authProfile, extra: data);
      case 4:
        context.go(AppRoutes.preferences);
        break;
      default:
        context.go(AppRoutes.home);
        break;
    }



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
                       icon: const ChatIconWidget(),
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
