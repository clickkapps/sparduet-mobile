import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class AppAudioService {


  static Future<String> _getLocalFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  static Future<bool> _fileExists(String filePath) async {
    return File(filePath).exists();
  }

  static Future<void> _downloadFile(String url, String filePath) async {
    try {
      final Dio dio = Dio();
      await dio.download(url, filePath);
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  static void loadAllAudioFiles(List<String> audioUrls) async {
    for (final url in audioUrls) {
      await preloadAudio(url, p.basename(url));
    }
  }

  static Future<void> preloadAudio(String url, String fileName) async {
    final filePath = await _getLocalFilePath(fileName);
    final exists = await _fileExists(filePath);

    if (!exists) {
      await _downloadFile(url, filePath);
    }
  }

  static Future<File?> getAudioLocalFile(String url) async {
    final fileName = p.basename(url);
    final filePath = await _getLocalFilePath(fileName);
    if(! (await _fileExists(filePath))) {
      return null;
    }
    return File(filePath);
  }
}