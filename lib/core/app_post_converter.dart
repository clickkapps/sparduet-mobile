import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class AppPostConverter {

  //Function to Download Audio:
  static Future<File> downloadAudio(String url, {String filename = 'background_audio.mp3'}) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$filename';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to download audio');
    }
  }

  //Function to Convert the Image to a Video with Music:

  static Future<File?> convertImageToVideoWithMusic(String imagePath, String audioUrl) async {
    final directory = await getTemporaryDirectory();
    final outputPath = '${directory.path}/output_with_music.mp4';

    // Download the audio file
    final audioFile = await downloadAudio(audioUrl);

    // Check if image and audio files exist
    if (!File(imagePath).existsSync()) {
      debugPrint('Image file not found at $imagePath');
      return null;
    }

    if (!audioFile.existsSync()) {
      debugPrint('Audio file not found at ${audioFile.path}');
      return null;
    }

    // The FFmpeg command to convert an image to a video with audio, limited to 30 seconds
    // final String command = '-y -i $imagePath -i ${audioFile.path} -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p $outputPath';
    // The FFmpeg command to convert an image to a video with audio, limited to 30 seconds
    debugPrint('customLog:FFmpeg imagePath: $imagePath');
    debugPrint('customLog:FFmpeg audioPath: ${audioFile.path}');
    debugPrint('customLog:FFmpeg outputPath: $outputPath');
    final String command = '-loop 1 -i $imagePath -i ${audioFile.path} -c:v mpeg4 -t 30 -pix_fmt yuv420p -vf scale=1280:720 -shortest $outputPath';

    // Run the FFmpeg command
    final session = await FFmpegKit.execute(command);
    // Attach log listeners
    FFmpegKitConfig.enableLogCallback((log) {
      debugPrint('customLog:FFmpeg Log: ${log.getMessage()}');
    });
    FFmpegKitConfig.enableStatisticsCallback((statistics) {
      debugPrint('customLog:FFmpeg Statistics: frame=${statistics.getVideoFrameNumber()}, time=${statistics.getTime()}');
    });
    // Get the return code
    final returnCode = await session.getReturnCode();
    final logs = await session.getAllLogsAsString();
    final failureStackTrace = await session.getFailStackTrace();
    if(returnCode == null) {
      debugPrint('customLog:FFmpeg Video with music saved to $outputPath');
      return null;
    }

    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
      debugPrint('customLog:FFmpeg Video with music saved to $outputPath');
      return File(outputPath);
    } else if (ReturnCode.isCancel(returnCode)) {
      // CANCEL
      debugPrint('customLog:FFmpeg command was cancelled');
      return null;
    } else {
      // ERROR
      debugPrint('customLog:FFmpeg command failed with return code $returnCode');
      debugPrint('customLog:FFmpeg logs: $logs');
      if (failureStackTrace != null) {
        debugPrint('customLog:FFmpeg failure stack trace: $failureStackTrace');
      }
      return null;
    }

  }


  static Future<File?> flipVideo(File file) async {
    // final img.Image? capturedImage = img.decodeImage(await File(file.path).readAsBytes());
    // if(capturedImage == null) {
    //   return file;
    // }
    // final img.Image orientedImage = img.bakeOrientation(capturedImage);
    // return await File(file.path).writeAsBytes(img.encodeJpg(orientedImage));
    final session = await FFmpegKit.execute("-y -i ${file.path} -filter:v \"hflip\" ${file.path}_flipped.mp4");

    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {

      // SUCCESS
      // final path = await session.getOutput();
      return File("${file.path}_flipped.mp4");

    } else if (ReturnCode.isCancel(returnCode)) {

      // CANCEL
      return null;

    } else {

      // ERROR
      return null;

    }

  }

}