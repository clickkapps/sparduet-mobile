import 'dart:async';
import 'dart:io';
import 'package:feather_icons/feather_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_feeds_cubit.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_purpose.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/crop_page.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/export_result.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/export_service.dart';
// import 'package:sparkduet/features/feeds/presentation/widgets/feed_editor_image_preview_widget.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_editor_video_preview_widget.dart';
import 'package:sparkduet/features/files/mixin/file_manager_mixin.dart';
import 'package:sparkduet/features/home/data/store/nav_cubit.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';
import 'package:video_editor/video_editor.dart';
// import 'package:video_trimmer/video_trimmer.dart';
// import 'package:video_trimmer/video_trimmer.dart';

class FeedEditorPreviewPage extends StatefulWidget {
  final File file;
  final FileType fileType;
  final PostFeedPurpose? feedPurpose;
  final ThemeData appTheme;
  final bool frontCameraVideo;
  const FeedEditorPreviewPage({super.key, required this.file, required this.fileType, this.feedPurpose, required this.appTheme, this.frontCameraVideo = false});

  @override
  State<FeedEditorPreviewPage> createState() => _FeedEditorPreviewPageState();
}

class _FeedEditorPreviewPageState extends State<FeedEditorPreviewPage> with FileManagerMixin {

  late File editedFile;
  final descriptionTextEditingController = TextEditingController();
  ValueNotifier<bool> enableComments = ValueNotifier(true);
  ValueNotifier<bool> trimVideoInProgress = ValueNotifier(false);
  // Trimmer trimmer = Trimmer();
  // double? _startVideoDuration;
  // double? _endVideoDuration;
  // bool additionalInfoSeen = false;
  late StreamSubscription streamSubscription;
  late FeedsCubit feedsCubit;
  final FocusNode messageFocusNode = FocusNode();


  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;
  late final VideoEditorController videoEditorController;


  @override
  void initState() {
    editedFile = widget.file;
    if(widget.feedPurpose != null) {
      descriptionTextEditingController.text = widget.feedPurpose?.description ?? "";
    }
    feedsCubit = context.read<AuthFeedsCubit>();
    streamSubscription = feedsCubit.stream.listen((event) {
      if(event.status == FeedStatus.postFeedSuccessful) {

      }
      if(event.status == FeedStatus.postFeedFailed) {
        // context.showSnackBar(event.message, appearance: NotificationAppearance.error);
      }
    });
    videoEditorController = VideoEditorController.file(
      editedFile,
      minDuration: Duration(seconds: AppConstants.minimumVideoDuration.toInt()),
      maxDuration: Duration(seconds: AppConstants.maximumVideoDuration.toInt()),
    );

    videoEditorController
        .initialize()
        .then((_) {
          setState(() {});
        })
        .catchError((error) {
      // handle minumum duration bigger than video duration error
      Navigator.pop(context);
    }, test: (e) {
      return e is VideoMinDurationError;
    });

    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    _exportingProgress.dispose();
    _isExporting.dispose();
    videoEditorController.dispose();
    ExportService.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

  void _trimEditedVideo(Function(File?)? onComplete) async {
    _exportingProgress.value = 0;
    _isExporting.value = true;

    final config = VideoFFmpegVideoEditorConfig(
      videoEditorController,
      // format: VideoExportFormat.gif,
      // commandBuilder: (config, videoPath, outputPath) {
      //   final List<String> filters = config.getExportFilters();
      //   filters.add('hflip'); // add horizontal flip

      //   return '-i $videoPath ${config.filtersCmd(filters)} -preset ultrafast $outputPath';
      // },
    );

    await ExportService.runFFmpegCommand(
      await config.getExecuteConfig(),
      onProgress: (stats) {
        _exportingProgress.value = config.getFFmpegProgress(stats.getTime().toInt());
      },
      onError: (e, s) {
        context.showSnackBar("Error on export video :(");
        onComplete?.call(null);
      },
      onCompleted: (file) {
        _isExporting.value = false;
        if (!mounted) return;

        // showDialog(
        //   context: context,
        //   builder: (_) => VideoResultPopup(video: file),
        // );
        onComplete?.call(file);
      },
    );
  }

  void showVideoInfoHandler(BuildContext context) {
    final theme = Theme.of(context);
    if(widget.appTheme.brightness == Brightness.light) {
      context.read<ThemeCubit>().setSystemUIOverlaysToLight();
    }
    // additionalInfoSeen = true;
    // trimmer.videoPlayerController?.pause();
    videoEditorController.video.pause();
    final ch = Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(color: Colors.transparent), // Transparent container to detect taps
        ),
        DraggableScrollableSheet(
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
                              // Text("Post settings", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),),
                              // const SizedBox(height: 30,),
                              CustomCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    // ValueListenableBuilder<bool>(valueListenable: enableComments, builder: (_, val, __) {
                                    //   return Row(
                                    //     children: [
                                    //       Expanded(child: Text(val ? "Comments enabled" : "Comments disabled", style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),)),
                                    //       SizedBox(
                                    //         width: 40,
                                    //         child: FittedBox(
                                    //           fit: BoxFit.contain,
                                    //           child: CupertinoSwitch(
                                    //             value: val,
                                    //             onChanged: (bool value) {
                                    //               enableComments.value = value;
                                    //             },
                                    //           ),
                                    //         ),
                                    //       )
                                    //     ],
                                    //   );
                                    // }),

                                    // const SizedBox(height: 30,),

                                    CustomTextFieldWidget(
                                      controller: descriptionTextEditingController,
                                      focusNode: messageFocusNode,
                                      label: "Write something about the post (optional)",
                                      // labelFontWeight: FontWeight.bold,
                                      maxLines: null,
                                      minLines: 4,
                                      placeHolder: "eg. I'm the sweetest person ever",
                                    ),
                                    const SizedBox(height: 10,),

                                    ValueListenableBuilder(valueListenable: trimVideoInProgress, builder: (_, trimVideoInProgress, ___) {
                                      return CustomButtonWidget(
                                        loading: trimVideoInProgress,
                                        text: 'Post ${ widget.fileType == FileType.video ? "video": "photo"}', onPressed: () => validateAndPostFeedHandler(context), expand: true,
                                      );
                                    })
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
      ],
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false).then((value) {
      if(context.mounted) {
        context.read<ThemeCubit>().setSystemUIOverlaysToDark();
      }
      if(mounted) {
        // trimmer.videoPlayerController?.play();
        videoEditorController.video.pause();
      }
    });
  }


  void _photoEditorHandler(BuildContext context) {
    editImageFile(context, imageFile: editedFile, onSuccess: (file) {
      setState(() {
        editedFile = file;
      });
    }, onError: (error) {
      context.showSnackBar(error, appearance: NotificationAppearance.info);
    });
  }

  // void trimVideoHandler(Function(File)? onSuccess) {
  //   // if(_startVideoDuration != null && _endVideoDuration != null) {
  //   //   trimmer.saveTrimmedVideo(startValue: _startVideoDuration!,
  //   //       endValue: _endVideoDuration!,
  //   //       onSave: (String? outputPath) {
  //   //         if (outputPath != null) {
  //   //           onSuccess?.call(File(outputPath));
  //   //         }else {
  //   //           context.showSnackBar("Sorry!, This video couldn't be trimmed.");
  //   //         }
  //   //       });
  //   // }
  // }

  void validateAndPostFeedHandler(BuildContext ctx) async {

    messageFocusNode.unfocus();

    if(!(await isNetworkConnected()) && mounted) {
      context.showSnackBar("Kindly check your network connection and try again");
      return;
    }

    // if(!additionalInfoSeen) {
    //   showVideoInfoHandler(context);
    //   return;
    // }

    if(containsPhoneNumber(descriptionTextEditingController.text.trim())) {
      context.showSnackBar("Phone numbers are not allowed here");
      return;
    }

    if(widget.fileType == FileType.video) {
      // get the trimmed video. We always do this cus the user can always change the start and end duration even if the video is less than 30secs
      trimVideoInProgress.value = true;
      _trimEditedVideo((file) {
        trimVideoInProgress.value = false;
        if(file != null) {
          submitFeed(file: file, fileType: FileType.video);
        }

      });
    }else {
      // for image, just submit
      submitFeed(file: editedFile, fileType: FileType.image);
    }


  }

  ///! Post / Sumbit Feed
  submitFeed({required File file, required FileType fileType}) async {

    if(!(await isNetworkConnected()) && mounted) {
    context.showSnackBar("Kindly check your network connection and try again");
    return;
    }

    final authUser = context.read<AuthCubit>().state.authUser;
    context.read<AuthFeedsCubit>().postFeed(file: file, mediaType: fileType, description: descriptionTextEditingController.text.trim(), purpose: widget.feedPurpose?.key, flipFile: widget.frontCameraVideo, user: authUser);
    if(widget.appTheme.brightness == Brightness.light) {
      context.read<ThemeCubit>().setSystemUIOverlaysToLight();
    }
    // context.go(AppRoutes.authProfile, extra: {"focusOnYourPosts":true});
    context.read<NavCubit>().requestTabChange(NavPosition.home, data: {"emitOnActiveIndexTapped": false});//
  }

  Widget actionsWidget(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.darkColorScheme.surface
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(flex: 1,child: CustomButtonWidget(
                  onPressed: () {
                    context.popScreen();
              }, text: 'Cancel', appearance: ButtonAppearance.primary, expand: true,
              ),),
              const SizedBox(width: 10,),
              Expanded(flex: 2,child: CustomButtonWidget(onPressed: () {
                // additionalInfoSeen = true;
                showVideoInfoHandler(context);
              }, text: "Add info and post", appearance: ButtonAppearance.secondary, expand: true,),),
              // const SizedBox(width: 10,),
            ],
          ),
        ),
      ),
    );
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
          // if(widget.fileType == FileType.image) ... {
          //   UnconstrainedBox(
          //     child: GestureDetector(
          //       behavior: HitTestBehavior.opaque,
          //       onTap: () => photoEditorHandler(context),
          //       child: Padding(
          //         padding: const EdgeInsets.only(right: 20),
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          //           child: Row(
          //             children: [
          //               Text("Open photo editor", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontSize: 12),),
          //               const SizedBox(width: 10,),
          //               const Icon(FeatherIcons.aperture,)
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   )
          // },
          // IconButton(
          //   onPressed: () =>
          //       videoEditorController.rotate90Degrees(RotateDirection.left),
          //   icon: const Icon(Icons.rotate_left, color: Colors.white,),
          //   tooltip: 'Rotate unclockwise',
          // ),
          // IconButton(
          //   onPressed: () =>
          //       videoEditorController.rotate90Degrees(RotateDirection.right),
          //   icon: const Icon(Icons.rotate_right),
          //   tooltip: 'Rotate clockwise',
          // ),
          // IconButton(
          //   onPressed: () => Navigator.push(
          //     context,
          //     MaterialPageRoute<void>(
          //       builder: (context) => CropPage(controller: videoEditorController),
          //     ),
          //   ),
          //   icon: const Icon(Icons.crop),
          //   tooltip: 'Open crop screen',
          // ),
          // const SizedBox(width: 10,)
        ],
      ),
      // extendBodyBehindAppBar: true,
      body: widget.fileType == FileType.image ? Column(
        children: [
          Expanded(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(width: double.maxFinite,
                  child: Image.file(editedFile, fit: BoxFit.cover,),
                ),
              )
          ),
          actionsWidget(context)
        ],
      ) : videoEditorController.initialized ?
      // Stack(
      //   children: [
      //       /// Display image or video -------------------------------
      //       widget.fileType == FileType.video
      //       ? FeedEditorVideoPreviewWidget(file: editedFile, frontCameraVideo: widget.frontCameraVideo,) : FeedEditorImagePreviewWidget(file: editedFile),
      //     // Align(
      //     //   alignment: Alignment.bottomCenter,
      //     //   child: Container(
      //     //     decoration: BoxDecoration(
      //     //         color: AppColors.darkColorScheme.surface
      //     //     ),
      //     //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //     //     child: SafeArea(
      //     //       child: Row(
      //     //         children: [
      //     //           Expanded(child: CustomButtonWidget(onPressed: () => showVideoInfoHandler(context), text: "Add info", appearance: ButtonAppearance.secondary, expand: true,)),
      //     //           const SizedBox(width: 10,),
      //     //           Expanded(child: CustomButtonWidget(
      //     //             onPressed: () => validateAndPostFeedHandler(context), text: 'Post ${ widget.fileType == FileType.video ? "video": "photo"}', appearance: ButtonAppearance.primary, expand: true,
      //     //           )
      //     //           ),
      //     //         ],
      //     //       ),
      //     //     ),
      //     //   ),
      //     // )
      //   ],
      // )
      Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          physics:
                          const NeverScrollableScrollPhysics(),
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CropGridViewer.preview(
                                    controller: videoEditorController),
                                AnimatedBuilder(
                                  animation: videoEditorController.video,
                                  builder: (_, __) => AnimatedOpacity(
                                    opacity:
                                    videoEditorController.isPlaying ? 0 : 1,
                                    duration: kThemeAnimationDuration,
                                    child: GestureDetector(
                                      onTap: videoEditorController.video.play,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration:
                                        const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            CoverViewer(controller: videoEditorController)
                          ],
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _isExporting,
                        builder: (_, bool export, Widget? child) =>
                            AnimatedSize(
                              duration: kThemeAnimationDuration,
                              child: export ? child : null,
                            ),
                        child: AlertDialog(
                          title: ValueListenableBuilder(
                            valueListenable: _exportingProgress,
                            builder: (_, double value, __) => Text(
                              "Exporting video ${(value * 100).ceil()}%",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment:
            MainAxisAlignment.start,
            children: _trimSlider(),
          ),
          actionsWidget(context)
        ],
      )
          : const Center(child: CustomAdaptiveCircularIndicator(),),
    );
  }


  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0')
  ].join(":");

  List<Widget> _trimSlider() {
    return [
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: TrimSlider(
          controller: videoEditorController,
          height: height,
          horizontalMargin: height / 4,
          hasHaptic: true,
          maxViewportRatio: 1.5,
          // child: TrimTimeline(
          //   controller: videoEditorController,
          //   padding: const EdgeInsets.only(top: 10),
          // ),
        ),
      )
    ];
  }

}
