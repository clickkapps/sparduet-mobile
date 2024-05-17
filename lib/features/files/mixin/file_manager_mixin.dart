import 'dart:io';
import 'package:feather_icons/feather_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:imgly_sdk/imgly_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';
import 'package:sparkduet/core/app_classes.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:video_editor_sdk/video_editor_sdk.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

mixin FileManagerMixin {


  // void pickImageFile(BuildContext context, {Function(File)? onSuccess, Function(String)? onError}) {
  //
  //   context.showCustomListBottomSheet(items: <ListItem>[
  //     const ListItem(id: "camera", title: "Take a picture", icon: FeatherIcons.aperture),
  //     const ListItem(id: "gallery", title: "Select image from gallery", icon: FeatherIcons.image),
  //   ], onItemTapped: (item) {
  //     if(item.id == "camera") {
  //       // context.pickFileFromCamera(requestType: RequestType.image, onSuccess: onSuccess, onError: onError);
  //       return;
  //     }
  //
  //     if(item.id == "gallery") {
  //
  //       return;
  //     }
  //   });
  //
  // }

  // void pickVideoFile(BuildContext context, {Function(File)? onSuccess, bool shouldAutoPreview = true, Function(String)? onError}) {
  //
  //   context.showCustomListBottomSheet(items: <ListItem>[
  //     const ListItem(id: "camera", title: "Use camera to record video", icon: FeatherIcons.video),
  //     const ListItem(id: "gallery", title: "Select video from gallery", icon: FeatherIcons.image),
  //   ], onItemTapped: (item) {
  //     if(item.id == "camera") {
  //       context.pickFileFromCamera(requestType: RequestType.video, onSuccess: onSuccess, onError: onError, shouldAutoPreview: shouldAutoPreview);
  //       return;
  //     }
  //
  //     if(item.id == "gallery") {
  //       context.pickFilesFromGallery(requestType: RequestType.video, onSuccess: (files) => onSuccess?.call((files??[]).first), onError: onError);
  //       return;
  //     }
  //   });
  //
  // }

  // Video Editor
  void editVideoFile(BuildContext context, {required File videoFile, Function(File)? onSuccess, Function(String)? onError}) async {

    try{

      // Create [ExportOptions] to customize the export.
      final exportOptions = ExportOptions(
        // The name of the exported file.
        // Create [ImageOptions] to customize the export for a photo.
          video: VideoOptions(
            // The image export type determines the type in which the image should be exported.
            // In this example, the image should be exported to a file to ease further processing.
            //   exportType: ImageExportType.fileUrl

          ),

      );
      // Create [TrimOptions].
      // The duration limits of these configuration options are
      // also respected by the composition tool.
      final trimOptions = TrimOptions(
        // By default the editor does not limit the maximum video duration.
        // For this example the duration is set, e.g. for a social
        // media application where the posts are not allowed to be
        // shorter than 2 seconds.
        // minimumDuration: AppConstants.minimumVideoDuration,
        minimumDuration: 0,

        // By default the editor does not have a maximum duration.
        // For this example the duration is set, e.g. for a social
        // media application where the posts are not allowed to be
        // longer than 5 seconds.
        // maximumDuration: AppConstants.maximumVideoDuration,
        maximumDuration: 10,

        forceMode: ForceTrimMode.always

      );

      // Create a [Configuration] instance.
      final configuration = Configuration(trim: trimOptions);

      // Open the photo editor and handle the export as well as any occurring errors.
      final result = await VESDK.openEditor(Video(videoFile.path), configuration: configuration);

      if (result != null) {
        // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
        debugPrint("exported image path ${result.video}");
        final editedVideoFile = File(result.video.replaceAll('file://', ''));
        onSuccess?.call(editedVideoFile);
        return;
      }

      // onError?.call("Oops!. Unable to edit video. try again later");

    }catch(error) {
      // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
      debugPrint(error.toString());
      onError?.call(error.toString());
    }

  }

  // Photo Editor
  void editImageFile(BuildContext context, {required File imageFile, Function(File)? onSuccess, Function(String)? onError}) async {

    try{

      // Create [ExportOptions] to customize the export.
      final exportOptions = ExportOptions(
        // The name of the exported file.
        // Create [ImageOptions] to customize the export for a photo.
          image: ImageOptions(
            // The image export type determines the type in which the image should be exported.
            // In this example, the image should be exported to a file to ease further processing.
              exportType: ImageExportType.fileUrl
          ));

      // Create a [Configuration] instance.
      final configuration = Configuration(export: exportOptions);

      // Open the photo editor and handle the export as well as any occurring errors.
      final result = await PESDK.openEditor(image: imageFile.path, configuration: configuration);

      if (result != null) {
        // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
        debugPrint("exported image path ${result.image}");
        final editedImage = File(result.image.replaceAll('file://', ''));
        onSuccess?.call(editedImage);
        return;
      }

      onError?.call("Oops!. Unable to edit image. try again later");

    }catch(error) {
      // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
      debugPrint(error.toString());
      onError?.call(error.toString());
    }

  }

}