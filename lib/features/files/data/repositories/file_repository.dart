import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FileRepository {


  Future<Either<String, String>> uploadFileToCloudinary({required List<File> files}) async {

    final cloudinaryUploadUrl = dotenv.env['CLOUDINARY_UPLOAD_URL'] ?? '';
    final cloudinaryUploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';
    final cloudinaryId = dotenv.env['CLOUDINARY_ID'] ?? '';


    Dio dio = Dio();
    FormData formData =  FormData.fromMap({
      "file": [
        for(File file in files) MultipartFile.fromFileSync(file.path, filename: p.basename(file.path))
      ],
      "upload_preset": cloudinaryUploadPreset,
      "cloud_name": cloudinaryId,
    });
    try {

      Response response = await dio.post(cloudinaryUploadUrl, data: formData);

      final data = jsonDecode(response.toString());
      debugPrint("data => $data");
      final secureUrl = data['secure_url'];
      final regularUrl = data['url'];
      // final returnedUrl = data['"playback_url" -> "https://res.cloudinary.com/dhhyl4ygy/video/upload/sp_auto/v1697578636/public/b7ubzolrzgmeczk5js2c.m3u8"'];
      debugPrint(secureUrl);
      debugPrint(regularUrl);

      return Right(secureUrl);

    } catch (e) {
      debugPrint(e.toString());
      return Left(e.toString());
    }



  }

}