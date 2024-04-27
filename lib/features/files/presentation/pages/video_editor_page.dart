import 'dart:io';
import 'package:flutter/material.dart';
import 'package:imgly_sdk/imgly_sdk.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:video_editor_sdk/video_editor_sdk.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class VideoEditorPage extends StatefulWidget {

  const VideoEditorPage({super.key});

  @override
  State<VideoEditorPage> createState() => _VideoEditorPageState();
}

class _VideoEditorPageState extends State<VideoEditorPage> {

  File? selectedVideo;

  void pickAndTrimVideo(BuildContext context) {
    context.pickFilesFromGallery(requestType: RequestType.video, onSuccess: (List<File>? videoFiles) async {
      if((videoFiles ?? []).isEmpty) {
        return;
      }
      final videoPath = videoFiles?.first.path;
      if (videoPath == null) return;

      try{

        // Create [ExportOptions] to customize the export.
        final exportOptions = ExportOptions(
          // The name of the exported file.
          // Create [ImageOptions] to customize the export for a photo.
            image: ImageOptions(
              // The image export type determines the type in which the image should be exported.
              // In this example, the image should be exported to a file to ease further processing.
                exportType: ImageExportType.fileUrl
            )
        );
        // Create [TrimOptions].
        // The duration limits of these configuration options are
        // also respected by the composition tool.
        final trimOptions = TrimOptions(
          // By default the editor does not limit the maximum video duration.
          // For this example the duration is set, e.g. for a social
          // media application where the posts are not allowed to be
          // shorter than 2 seconds.
            minimumDuration: 10,

            // By default the editor does not have a maximum duration.
            // For this example the duration is set, e.g. for a social
            // media application where the posts are not allowed to be
            // longer than 5 seconds.
            maximumDuration: 30,

            // By default the editor trims the video automatically if it is
            // longer than the specified maximum duration. For this example the user
            // is prompted to review and adjust the automatically trimmed video.
            forceMode: ForceTrimMode.ifNeeded,


        );

        // Create a [Configuration] instance.
        final configuration = Configuration(export: exportOptions,trim: trimOptions);

        // Open the photo editor and handle the export as well as any occurring errors.
        final result = await VESDK.openEditor(Video(videoPath), configuration: configuration);

        if (result != null) {
          // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
          debugPrint("exported image path ${result.video}");
          final editedVideoFile = File(result.video.replaceAll('file://', ''));
          // if(context.mounted) {
          //   final trimmedVideoFile = await context.pushScreen(TrimVideoPage(videoFile: editedVideoFile)) as File?;
          //   if(trimmedVideoFile == null) {
          //     return;
          //   }
          //   selectedVideo = trimmedVideoFile;
          // }
        }
      }catch(error) {
        // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
        debugPrint(error.toString());
      }

    }, maxAssets: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextButton(onPressed: () => pickAndTrimVideo(context), child: const Text("Pick Video from gallery"))
          ],
        ),
      ),
    );
  }
}
