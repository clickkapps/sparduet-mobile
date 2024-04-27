import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';
import 'package:imgly_sdk/imgly_sdk.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PhotoEditorPage extends StatefulWidget {

  const PhotoEditorPage({super.key});

  @override
  State<PhotoEditorPage> createState() => _PhotoEditorPageState();

}

class _PhotoEditorPageState extends State<PhotoEditorPage> {

  File? selectedImage;

  void editPhoto(BuildContext context) {
    context.pickFilesFromGallery(requestType: RequestType.image, onSuccess: (List<File>? imageFiles) async {
        if((imageFiles ?? []).isEmpty) {
          return;
        }
        final imagePath = imageFiles?.first.path;
        if (imagePath == null) return;

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
              final result = await PESDK.openEditor(image: imagePath, configuration: configuration);

              if (result != null) {
                // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
                debugPrint("exported image path ${result.image}");
                setState(() {
                  selectedImage = File(result.image.replaceAll('file://', ''));
                });
              }
        }catch(error) {
            // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
            debugPrint(error.toString());
        }

    }, maxAssets: 1);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
           children: [
             if(selectedImage != null) ... {
               Image.file(selectedImage!)
             },
             TextButton(onPressed: () => editPhoto(context), child: const Text("Edit Photo"))
           ],
        ),
      ),
    );
  }
}
