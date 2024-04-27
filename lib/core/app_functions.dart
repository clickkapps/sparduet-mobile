import 'dart:async';
import 'dart:io';

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