import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparkduet/app/app.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'core/app_injector.dart' as di;
import 'package:connectycube_sdk/connectycube_sdk.dart';
// import 'package:connectycube_sdk/connectycube_sdk.dart' as connectycube;

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

  // final cloudName = dotenv.env["CLOUDINARY_ID"] ?? '';
  // AppConstants.cloudinary = CloudinaryObject.fromCloudName(cloudName: cloudName,);

  String connectycubeappId = dotenv.env["CONNECTYCUBE_APP_ID"] ?? '';
  String connectycubeauthKey = dotenv.env["CONNECTYCUBE_AUTH_KEY"] ?? '';
  String connectycubeauthSecret = dotenv.env["CONNECTYCUBE_AUTH_SECRETE"] ?? '';
  String connectycubeApiEndpoint = dotenv.env["CONNECTYCUBE_API_ENDPOINT"] ?? '';
  String connectycubeChatEndpoint = dotenv.env["CONNECTYCUBE_CHAT_ENDPOINT"] ?? '';

  await init(connectycubeappId, connectycubeauthKey, connectycubeauthSecret);
  CubeSettings.instance.isDebugEnabled = true; // to enable ConnectyCube SDK logs;
  await CubeSettings.instance.setEndpoints(connectycubeApiEndpoint, connectycubeChatEndpoint); // to set custom endpoints

  runApp(const App());
}


