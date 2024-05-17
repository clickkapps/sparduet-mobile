import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:dartz/dartz.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';

class FileRepository {

  final NetworkProvider networkProvider;
  FileRepository({required this.networkProvider});

  Future<Either<String, List<String>>> uploadFilesToServer({required List<File> files}) async {

    // await Future.delayed(const Duration(seconds: 4), );
    // return const Right("imnnt00chidoe0appuye");

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