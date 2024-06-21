// import 'package:background_fetch/background_fetch.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sparkduet/app/app.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/users/data/models/user_info_model.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/firebase_options.dart';
import 'core/app_injector.dart' as di;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';


// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
// @pragma('vm:entry-point')
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   String taskId = task.taskId;
//   bool isTimeout = task.timeout;
//   if (isTimeout) {
//     // This task has exceeded its allowed running-time.
//     // You must stop what you're doing and immediately .finish(taskId)
//     debugPrint("[BackgroundFetch] Headless task timed-out: $taskId");
//     BackgroundFetch.finish(taskId);
//     return;
//   }
//   debugPrint('[BackgroundFetch] Headless event received.');
//   // Do your work here...
//   BackgroundFetch.finish(taskId);
// }

void main() async {

  // Ensure all dependencies are initialized
  WidgetsFlutterBinding.ensureInitialized();
  //only portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // so that the status bar will show on IOS
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);

  // All dependence injections
  // dependencies are registered lazily to boost app performance
  await di.init();

  await dotenv.load(fileName: "assets/.env");

  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.debug);
  final onesignalAppID = dotenv.env['ONESIGNAL_APP_ID'] ?? '';
  OneSignal.initialize(onesignalAppID);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver(analytics: analytics,);

  await Hive.initFlutter();
  Hive.registerAdapter(ChatConnectionModelAdapter());
  Hive.registerAdapter(ChatMessageModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(UserInfoModelAdapter());
  await Hive.openBox<ChatMessageModel>(AppConstants.kChatMessages);
  await Hive.openBox<ChatConnectionModel>(AppConstants.kChatConnections);

  runApp(const App());

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}

  // ///! 1. To activate background fetch uncomment this line,
  // /// 2. go to [stories_page] and uncomment initPlatformState()
  // /// 3. Go to privacyInfo in xcode and uncomment out dict
  // /// 4. make sure [background fetch] is checked in xcode
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}


