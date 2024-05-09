import 'dart:io';
import 'package:feather_icons/feather_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_purpose.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_editor_image_preview_widget.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_editor_video_preview_widget.dart';
import 'package:sparkduet/features/files/data/store/enums.dart';
import 'package:sparkduet/features/files/mixin/file_manager_mixin.dart';
import 'package:sparkduet/features/home/data/nav_cubit.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';
import 'package:video_trimmer/video_trimmer.dart';

class FeedEditorPreviewPage extends StatefulWidget {
  final File file;
  final FileType fileType;
  final PostFeedPurpose? feedPurpose;
  final ThemeData appTheme;
  const FeedEditorPreviewPage({super.key, required this.file, required this.fileType, this.feedPurpose, required this.appTheme});

  @override
  State<FeedEditorPreviewPage> createState() => _FeedEditorPreviewPageState();
}

class _FeedEditorPreviewPageState extends State<FeedEditorPreviewPage> with FileManagerMixin {

  late File editedFile;
  final descriptionTextEditingController = TextEditingController();
  ValueNotifier<bool> enableComments = ValueNotifier(true);
  Trimmer trimmer = Trimmer();
  double? _startVideoDuration;
  double? _endVideoDuration;
  bool additionalInfoSeen = false;


  @override
  void initState() {
    editedFile = widget.file;
    if(widget.feedPurpose != null) {
      descriptionTextEditingController.text = widget.feedPurpose?.description ?? "";
    }
    super.initState();
  }

  void showVideoInfoHandler(BuildContext context) {
    final theme = Theme.of(context);
    if(widget.appTheme.brightness == Brightness.light) {
      context.read<ThemeCubit>().setSystemUIOverlaysToLight();
    }
    additionalInfoSeen = true;
    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.7,
          minChildSize: 0.6,
          builder: (_ , controller) {
            return ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: ColoredBox(
                    color: theme.colorScheme.background,
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Post settings", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),),
                            const SizedBox(height: 30,),
                            CustomCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  ValueListenableBuilder<bool>(valueListenable: enableComments, builder: (_, val, __) {
                                    return Row(
                                      children: [
                                        Expanded(child: Text(val ? "Comments enabled" : "Comments disabled", style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),)),
                                        SizedBox(
                                          width: 40,
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: CupertinoSwitch(
                                              value: val,
                                              onChanged: (bool value) {
                                                enableComments.value = value;
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }),

                                  const SizedBox(height: 30,),

                                  CustomTextFieldWidget(
                                    controller: descriptionTextEditingController,
                                    label: "Write something about the post (optional)",
                                    // labelFontWeight: FontWeight.bold,
                                    maxLines: null,
                                    minLines: 4,
                                    placeHolder: "eg. I'm the sweetest person ever",
                                  ),
                                  const SizedBox(height: 10,),
                                  CustomButtonWidget(text: 'Post ${ widget.fileType == FileType.video ? "video": "photo"}', onPressed: () => validateAndPostFeedHandler(context), expand: true,)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                )
            );
          }
      ),
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false).then((value) => context.read<ThemeCubit>().setSystemUIOverlaysToDark());
  }

  void videoEditorHandler(BuildContext context) {

    trimVideoHandler((trimmedFile) {
      editVideoFile(context, videoFile: trimmedFile, onSuccess: (file) async {
        setState(() {
          editedFile = file;
        });
        // // _trimmer.videoPlayerController?.dataSource;
        // trimmer = Trimmer();
        await trimmer.loadVideo(videoFile: editedFile);
        await trimmer.videoPlaybackControl(
          startValue: _startVideoDuration!,
          endValue: _endVideoDuration!,
        );
      }, onError: (error) {
        context.showSnackBar(error, appearance: NotificationAppearance.info);
      });
    });
    // editVideoFile(context, videoFile: editedFile, onSuccess: (file) async {
    //   setState(() {
    //     editedFile = file;
    //   });
    //   // // _trimmer.videoPlayerController?.dataSource;
    //   // trimmer = Trimmer();
    //   await trimmer.loadVideo(videoFile: editedFile);
    //   await trimmer.videoPlaybackControl(
    //     startValue: _startVideoDuration!,
    //     endValue: _endVideoDuration!,
    //   );
    // }, onError: (error) {
    //   context.showSnackBar(error, appearance: NotificationAppearance.info);
    // });
    // trimVideoHandler((trimmedFile) {
    //
    // });

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

  void trimVideoHandler(Function(File)? onSuccess) {
    if(_startVideoDuration != null && _endVideoDuration != null) {
      trimmer.saveTrimmedVideo(startValue: _startVideoDuration!,
          endValue: _endVideoDuration!,
          onSave: (String? outputPath) {
            if (outputPath != null) {
              onSuccess?.call(File(outputPath));
            }
          });
    }
  }

  void validateAndPostFeedHandler(BuildContext ctx) {

    if(!additionalInfoSeen) {
      showVideoInfoHandler(context);
      return;
    }

    if(widget.fileType == FileType.video) {
      // get the trimmed video. We always do this cus the user can always change the start and end duration even if the video is less than 30secs
      trimVideoHandler((file) {
        submitFeed(file: file, fileType: FileType.video);
      });
    }else {
      // for image, just submit
      submitFeed(file: editedFile, fileType: FileType.image);
    }


  }

  ///! Post / Sumbit Feed
  submitFeed({required File file, required FileType fileType}) {
    context.read<FeedsCubit>().postFeed(file: file, mediaType: fileType, description: descriptionTextEditingController.text.trim(), purpose: widget.feedPurpose?.key);
    if(widget.appTheme.brightness == Brightness.light) {
      context.read<ThemeCubit>().setSystemUIOverlaysToLight();
    }
    context.read<NavCubit>().requestTabChange(NavPosition.profile);//
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkColorScheme.surface,
      appBar: AppBar(elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.darkColorScheme.onBackground),
        actions: [
          // if(widget.fileType == FileType.video) ... {
          //   UnconstrainedBox(
          //     child: GestureDetector(
          //       onTap: () => videoEditorHandler(context),
          //       behavior: HitTestBehavior.opaque,
          //       child: Padding(
          //         padding: const EdgeInsets.only(right: 10.0),
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          //           child: Row(
          //             children: [
          //               Text("Open video editor", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontSize: 12),),
          //               const SizedBox(width: 10,),
          //               const Icon(FeatherIcons.aperture,)
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   )
          // },
          if(widget.fileType == FileType.image) ... {
            UnconstrainedBox(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => photoEditorHandler(context),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    child: Row(
                      children: [
                        Text("Open photo editor", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontSize: 12),),
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
      body: Stack(
        children: [
            /// Display image or video -------------------------------
            widget.fileType == FileType.video
            ? FeedEditorVideoPreviewWidget(trimmer: trimmer,file: editedFile, builder: (start, end) {
              _startVideoDuration = start;
              _endVideoDuration = end;
            },) : FeedEditorImagePreviewWidget(file: editedFile),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.darkColorScheme.surface
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(child: CustomButtonWidget(onPressed: () => showVideoInfoHandler(context), text: "Add info", appearance: ButtonAppearance.secondary, expand: true,)),
                  const SizedBox(width: 10,),
                  Expanded(child: CustomButtonWidget(onPressed: () => validateAndPostFeedHandler(context), text: 'Post ${ widget.fileType == FileType.video ? "video": "photo"}', appearance: ButtonAppearance.primary, expand: true,)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
