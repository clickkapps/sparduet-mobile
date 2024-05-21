import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:dartz/dartz.dart';
import 'package:sparkduet/features/files/data/models/mux_commons_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';
import 'package:mime/mime.dart';

class FileRepository {

  final NetworkProvider networkProvider;

  FileRepository({required this.networkProvider});

  // Error, AuthenticatedUrl, ID
  Future<(String?, String?, String?)> _getMuxAuthenticatedUrl() async {

    try{
      // Set default configs
      const path = AppApiRoutes.createMuxUploadUrl;
      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.get,
          useToken: true
      );

      if (response!.statusCode == 200) {


        if(!(response.data["status"] as bool)){
          return (response.data["message"] as String, null, null);
        }

        final extra = response.data["extra"]["data"] as Map<String, dynamic>;
        final url = extra["url"] as String?;
        final id = extra["id"] as String?;
        return (null,  url, id);

      }

      return (response.statusMessage ?? "", null, null);

    }catch(error) {
      return (error.toString(), null, null);
    }


  }

  // The right returns -> [playbackId, assetId, aspectRatio]
  Future<Either<String, (String, String, String)>> uploadVideoToServer({required File videoFile}) async {

    try{

      final muxAuthUrlData = await _getMuxAuthenticatedUrl();
      debugPrint("customLog: muxAuthUrlData: $muxAuthUrlData");
      if(muxAuthUrlData.$1 != null) {
        return Left(muxAuthUrlData.$1 ?? "");
      }

      final uploadUrl = muxAuthUrlData.$2;
      final videoId = muxAuthUrlData.$3;

      if(videoId == null) {
        return const Left("Invalid video");
      }

      // String fileName = p.basename(videoFile.path);

      final dio = Dio();

      // Check if the file exists
      if (!await videoFile.exists()) {
        throw Exception('File does not exist: ${videoFile.path}');
      }

      // Determine the MIME type of the file
      String? mimeType = lookupMimeType(videoFile.path);
      if (mimeType == null) {
        throw Exception('Could not determine MIME type for file: ${videoFile.path}');
      }

      // Create a FormData object and add the video file
      // In this case, we're directly using the PUT request as in the curl command
      Response response = await dio.put(
        uploadUrl!,
        data: videoFile.openRead(),
        options: Options(
          headers: {
            'Content-Length': await videoFile.length(), // Set content length for the upload
            'Content-Type': mimeType, // Assuming the file is a mp4 video
          },
        ),
      );

      if (response.statusCode == 200) {
        // MuxVideoDataModel? videoData = MuxVideoDataModel.fromJson(response.data);
        //
        // String? status = videoData.data?.status;
       final uploadStatus = await _checkUploadStatus(videoId: videoId);
       if(uploadStatus.$1 != "asset_created") {
         throw Exception("Unable to create asset");
       }

       final assetId = uploadStatus.$2;

       final status = await _checkVideoStatus(assetId: assetId);
       final playbackId = status.$1;
       final aspectRatio = status.$2;

        return Right((playbackId, assetId, aspectRatio));
      }

      return Left(response.statusMessage ?? "");

    }catch(e) {
      return Left(e.toString());
    }

  }

  // returns status, assetId
  Future<(String, String)> _checkUploadStatus({required String videoId}) async {
    try {
      const path = AppApiRoutes.getUploadStatus;
      Response? response = await networkProvider.call(
          path: path,
          method: RequestMethod.post,
          body: {
            "videoId": videoId
          },
          useToken: true
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return throw Exception(response.data["message"]);
        }

        final data = response.data["extra"]["data"] as Map<String, dynamic>;
        final status = data["status"] as String;
        final assetId = data["asset_id"] as String;
        return (status, assetId);

      }

      return throw Exception(response.statusMessage);

    } catch (e) {
      debugPrint('Error starting build: $e');
      throw Exception('Failed to check status');
    }

  }

  // returns status -> playbackId, aspectRatio,
  Future<(String, String)> _checkVideoStatus({required String assetId}) async {

    try {
      const path = AppApiRoutes.getVideoStatus;
      Response? response = await networkProvider.call(
          path: path,
          method: RequestMethod.post,
          body: {
            "assetId": assetId
          },
          useToken: true
      );

      if (response!.statusCode == 200) {

        if(!(response.data["status"] as bool)){
          return throw Exception(response.data["message"]);
        }

        final data = response.data["extra"]["data"] as Map<String, dynamic>;
        final status = data["status"] as String;
        if(status == "ready"){
          final playbackIds = data["playback_ids"] as List<dynamic>;
          final playbackIdMap = playbackIds.first as Map<String, dynamic>;
          final playBackId = playbackIdMap["id"] as String;
          final aspectRatio = data["aspect_ratio"] as String;
          return (playBackId, aspectRatio);
        }

        if(status == "preparing") {
          // if its still preparing wait one second and check again
          await Future.delayed(const Duration(seconds: 1));
          return _checkVideoStatus(assetId: assetId);
        }

        throw Exception("Invalid video status");

      }

      throw Exception(response.statusMessage);

    } catch (e) {
      debugPrint('Error starting build: $e');
      throw Exception('Failed to check status');
    }

  }


  Future<Either<String, List<String>>> uploadFilesToServer({required List<File> files }) async {

    try {

      const path = AppApiRoutes.uploadFiles;
      FormData formData = FormData();

      if((files).isNotEmpty){
        for (int i = 0; i < files.length; i++) {
          String fileName = p.basename(files[i].path);
          formData.files.add(MapEntry(
            'files[]',
            await MultipartFile.fromFile(
              files[i].path,
              filename: fileName,
            ),
          ));
        }
      }

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.upload,
          useToken: true,
          formData: formData
      );

      if(response!.statusCode == 200){

        if(!(response.data["status"] as bool)) {
          return Left(response.data["message"]);
        }

        final data = response.data["extra"] as List<dynamic>;
        final list = List<String>.from(data.map((x) => x as String));
        return Right(list);

      }else {
        return Left(response.statusMessage ?? "");
      }


    } catch(e) {
      return Left(e.toString());
    }

  }



///Cloudinary
// final cloudinaryUploadUrl = dotenv.env['CLOUDINARY_UPLOAD_URL'] ?? '';
// final cloudinaryUploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';
// final cloudinaryId = dotenv.env['CLOUDINARY_ID'] ?? '';


// Dio dio = Dio();
// FormData formData =  FormData.fromMap({
//   "file": [
//     for(File file in files) MultipartFile.fromFileSync(file.path, filename: p.basename(file.path))
//   ],
//   "upload_preset": cloudinaryUploadPreset,
//   "cloud_name": cloudinaryId,
// });
// try {
//
//   Response response = await dio.post(cloudinaryUploadUrl, data: formData);
//
//   final data = jsonDecode(response.toString());
//
//   debugPrint("data => $data");
//   final publicId = data['public_id'] as String;
//   final mediaId = publicId.replaceAll("sparkduet/", "");
//   return Right(mediaId);
//
// } catch (e) {
//   debugPrint(e.toString());
//   return Left(e.toString());
// }

}