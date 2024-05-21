import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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