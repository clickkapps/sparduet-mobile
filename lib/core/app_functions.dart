import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';

/// Use this method to execute code that requires context in init state
onWidgetBindingComplete(
    {required Function() onComplete, int milliseconds = 200}) {
  WidgetsBinding.instance.addPostFrameCallback(
          (_) => Timer(Duration(milliseconds: milliseconds), onComplete));
}

Future<File> getFileFromAssets(String path) async {
  final byteData = await rootBundle.load(path);

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

String getFormattedDateWithIntl(DateTime date, {String format = 'MMM yyyy'}) {
  var formatBuild = DateFormat(format);
  var dateString = formatBuild.format(date);
  return dateString;
}

String getFormattedDateTimeWithIntl(DateTime date) {
  final daySuffix = getDaySuffix(date.day);
  final formattedDate = DateFormat("d'$daySuffix' MMMM yyyy h:mm a").format(date);
  return formattedDate;
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String formatDuration(Duration duration) {
  // Calculate total seconds
  int totalSeconds = duration.inSeconds;

  // Calculate minutes and remaining seconds
  int minutes = (totalSeconds ~/ 60) % 60;
  int seconds = totalSeconds % 60;

  // Format minutes and seconds with leading zeros
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = seconds.toString().padLeft(2, '0');

  // Return formatted string
  return '$formattedMinutes:$formattedSeconds';
}

/// Flips and overrides provided image.
File flipImage(String path) {
// Read the image from file.
final inputImageFile = File(path);
final bytes = inputImageFile.readAsBytesSync();
var image = img.decodeImage(Uint8List.fromList(bytes))!;

// Flip the image.
image = img.flip(image, direction: img.FlipDirection.horizontal);

// Save the flipped image.
File(path).writeAsBytesSync(Uint8List.fromList(img.encodeJpg(image)));
// 'Flipped image saved to: $path'.logD;
return File(path);
}


Future<void> disableFullScreen() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
}

Future<void> enableFullScreen() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
}

Future<bool> isNetworkConnected () async {

  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network.
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a wifi network.
    return true;
  } else if (connectivityResult == ConnectivityResult.ethernet) {
    // I am connected to a ethernet network.
    return true;
  } else if (connectivityResult == ConnectivityResult.vpn) {
    // I am connected to a vpn network.
    // Note for iOS and macOS:
    // There is no separate network interface type for [vpn].
    // It returns [other] on any device (also simulator)
    return true;
  } else if (connectivityResult == ConnectivityResult.bluetooth) {
    // I am connected to a bluetooth.
    return false;
  } else if (connectivityResult == ConnectivityResult.other) {
    // I am connected to a network which is not in the above mentioned networks.
    return true;
  } else if (connectivityResult == ConnectivityResult.none) {
    // I am not connected to any network.
    return false;
  }

  return false;
}

bool isContainingAnyLink(String? text) {
  RegExp exp = RegExp(r"(?:(?:(?:ftp|http)[s]*:\/\/|www\.)[^\.]+\.[^ \n]+)");
  Iterable<RegExpMatch> matches = exp.allMatches(text ?? '');
  return matches.isNotEmpty ? true : false;
}

bool isPhoneNumber(String? text) {
  RegExp exp = RegExp(r'[+0]\d+[\d-]+\d');
  Iterable<RegExpMatch> matches = exp.allMatches(text ?? '');
  return matches.isNotEmpty ? true : false;
}

bool isEmail(String? text) {
  RegExp exp = RegExp(r'[^@\s]+@([^@\s]+\.)+[^@\W]+');
  Iterable<RegExpMatch> matches = exp.allMatches(text ?? '');
  return matches.isNotEmpty ? true : false;
}

void copyTextToClipBoard(BuildContext context, String text, {String? toastMessage}) {
  Clipboard.setData(ClipboardData(text: text));
  context.showSnackBar(toastMessage ?? 'Copied!', appearance: NotificationAppearance.info);
}

bool containsPhoneNumber(String text) {
  return containsDigitPhoneNumber(text) || containsWordPhoneNumber(text);
}

bool containsDigitPhoneNumber(String text) {
  // Regular expression to match phone numbers
  final regex = RegExp(
    r'(\+?\d[\d\s-]{8,}\d)|(^0\d{9,}$)',
    caseSensitive: false,
  );

  // Find all matches
  final matches = regex.allMatches(text);

  // Check each match to see if it starts with '0' or '+' and has at least 10 digits
  for (final match in matches) {
    String matchText = match.group(0) ?? '';
    String digitsOnly = matchText.replaceAll(RegExp(r'\D'), ''); // Remove non-digit characters
    if ((matchText.startsWith('0') || matchText.startsWith('+')) && digitsOnly.length >= 10) {
      return true; // Return true if a valid phone number is found
    }
  }

  return false; // Return false if no valid phone number is found
}

bool containsWordPhoneNumber(String text) {
  final regex = RegExp(
    r'(zero|one|two|three|four|five|six|seven|eight|nine)',
    caseSensitive: false,
  );

  // Find all matches and count them
  final matches = regex.allMatches(text).length;

  // A single number word is usually fine, but multiple could indicate a phone number
  return matches > 2; // Adjust this threshold as needed
}

/// convert figures in 1000s into k
String convertToCompactFigure(int n) {
  if (n < 1000) {
    return n.toString();
  } else if (n < 1000000) {
    if (n % 1000 == 0) {
      return "${(n ~/ 1000)}k"; // Using integer division to ensure no decimals
    } else {
      return "${(n / 1000).toStringAsFixed(1)}k";
    }
  } else {
    return "${(n / 1000000).toStringAsFixed(1)}M";
  }
}

// Map<String, dynamic> convertMap(Map<Object?, Object?> inputMap) {
//   Map<String, dynamic> outputMap = {};
//
//   inputMap.forEach((key, value) {
//     if (key is String) {
//       outputMap[key] = value;
//     } else {
//       // Handle non-string keys if necessary
//       // For example, you can convert them to string using key.toString()
//       outputMap[key.toString()] = value;
//     }
//   });
//
//   return outputMap;
// }

Map<String, dynamic> convertMap(Map<Object?, Object?> input) {
  Map<String, dynamic> result = {};

  input.forEach((key, value) {
    if (key is String) {
      if (value is Map<Object?, Object?>) {
        result[key] = convertMap(value); // Recursive call for inner maps
      } else {
        result[key] = value;
      }
    }
  });

  return result;
}

List<int> convertToIntList(List<Object?> objectList) {
  List<int> intList = [];

  for (var item in objectList) {
    if (item is int) {
      intList.add(item);
    } else if (item is String) {
      int? parsedInt = int.tryParse(item);
      if (parsedInt != null) {
        intList.add(parsedInt);
      }
    } else if (item is double) {
      intList.add(item.toInt());
    }
    // Handle other types as necessary
  }

  return intList;
}

String? convertObjectToString(Object? object) {
  if (object == null) {
    return null;
  } else if (object is String) {
    return object;
  } else {
    return object.toString();
  }
}

Future<bool> isRunningOnEmulator() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isEmulator = false;

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    isEmulator = !androidInfo.isPhysicalDevice;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    isEmulator = !iosInfo.isPhysicalDevice;
  }

  return isEmulator;
}
