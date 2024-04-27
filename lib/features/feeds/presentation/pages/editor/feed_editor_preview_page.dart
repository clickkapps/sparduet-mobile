import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_editor_image_preview_widget.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_editor_video_preview_widget.dart';
import 'package:sparkduet/features/files/mixin/file_manager_mixin.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';

class FeedEditorPreviewPage extends StatefulWidget {
  final File file;
  final RequestType requestType;
  const FeedEditorPreviewPage({super.key, required this.file, required this.requestType});

  @override
  State<FeedEditorPreviewPage> createState() => _FeedEditorPreviewPageState();
}

class _FeedEditorPreviewPageState extends State<FeedEditorPreviewPage> with FileManagerMixin {

  late File editedFile;
  BetterPlayerController? betterPlayerController;

  @override
  void initState() {
    editedFile = widget.file;
    super.initState();
  }

  void videoEditorHandler(BuildContext context) {
    editVideoFile(context, videoFile: editedFile, onSuccess: (file) {
        setState(() {
          editedFile = file;
          betterPlayerController?.setupDataSource(BetterPlayerDataSource(
            BetterPlayerDataSourceType.file,
            editedFile.path,
            cacheConfiguration: const BetterPlayerCacheConfiguration(
                useCache: true
            ),
          ));
        });
    }, onError: (error) {
      context.showSnackBar(error, appearance: NotificationAppearance.info);
    });
  }

  void photoEditorHandler(BuildContext context) {
    editImageFile(context, imageFile: editedFile, onSuccess: (file) {
      setState(() {
        editedFile = file;
      });
    }, onError: (error) {
      context.showSnackBar(error, appearance: NotificationAppearance.info);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkColorScheme.background,
      appBar: AppBar(elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.darkColorScheme.onBackground),
        actions: [
          if(widget.requestType == RequestType.video) ... {
            UnconstrainedBox(
              child: GestureDetector(
                onTap: () => videoEditorHandler(context),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    child: Row(
                      children: [
                        Text("Click here for video editor", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontSize: 12),),
                        const SizedBox(width: 10,),
                        const Icon(FeatherIcons.aperture,)
                      ],
                    ),
                  ),
                ),
              ),
            )
          },
          if(widget.requestType == RequestType.image) ... {
            UnconstrainedBox(
              child: GestureDetector(
                onTap: () => photoEditorHandler(context),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    child: Row(
                      children: [
                        Text("Click here for photo editor", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontSize: 12),),
                        const SizedBox(width: 10,),
                        const Icon(FeatherIcons.aperture,)
                      ],
                    ),
                  ),
                ),
              ),
            )
          },
        ],
      ),
      // extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.darkColorScheme.background,
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.darkColorScheme.background
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Expanded(child: CustomButtonWidget(onPressed: (){}, text: widget.requestType == RequestType.video ? 'Video info' : "Photo info", appearance: ButtonAppearance.secondary, expand: true,)),
              const SizedBox(width: 10,),
              Expanded(child: CustomButtonWidget(onPressed: (){}, text: 'Post ${ widget.requestType == RequestType.video ? "video": "photo"}', appearance: ButtonAppearance.primary, expand: true,)),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child:
            widget.requestType == RequestType.video
                ? FeedEditorVideoPreviewWidget(file: editedFile, builder: (controller) => betterPlayerController = controller,)
                : FeedEditorImagePreviewWidget(file: editedFile)
          ),

        ],
      ),
    );
  }
}
