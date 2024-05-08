import 'dart:async';
import 'dart:io';
import 'package:feather_icons/feather_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_purpose.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/feed_editor_preview_page.dart';
import 'package:sparkduet/features/files/mixin/file_manager_mixin.dart';
import 'package:sparkduet/features/files/presentation/pages/video_trimmer_page.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_heart_animation_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

enum CameraState {initial, recording, paused}
Future<String?> openFeedCamera(BuildContext context, {PostFeedPurpose? purpose}) async {
  final currentTheme = Theme.of(context);
  final List<CameraDescription> cameras = await availableCameras();
  if(cameras.isEmpty) {
    return  "No cameras detected on your device";
  }
  if(context.mounted) {
    return context.push(AppRoutes.camera, extra: {"cameras": cameras, "feedPurpose": purpose}).then((value) {
        if(currentTheme.brightness == Brightness.light) {
          context.read<ThemeCubit>().setSystemUIOverlaysToLight();
        }
    });
  }
  return null;
}

class FeedEditorCameraPage extends StatefulWidget {

  final List<CameraDescription> cameras;
  final PostFeedPurpose? purpose;

  const FeedEditorCameraPage({super.key, required this.cameras, this.purpose});

  @override
  State<FeedEditorCameraPage> createState() => _FeedEditorCameraPageState();
}

class _FeedEditorCameraPageState extends State<FeedEditorCameraPage> with FileManagerMixin{

  AssetEntity? firstGalleryItem;
  final ValueNotifier<bool> galleryItemLoading = ValueNotifier(false);
  late CameraController controller;
  final ValueNotifier<bool> initialized = ValueNotifier(false);
  final ValueNotifier<String?> error = ValueNotifier(null);
  final ValueNotifier<bool> flashOn = ValueNotifier(false);
  final ValueNotifier<int> description = ValueNotifier(0);
  final ValueNotifier<int> duration = ValueNotifier(AppConstants.maximumVideoDuration.toInt());
  final ValueNotifier<int> preRecordingTimerDurationStartValue = ValueNotifier(0);
  final ValueNotifier<bool> isTimerAnimating = ValueNotifier(false);
  final ValueNotifier<bool> isPreTimerAnimating = ValueNotifier(false);
  CameraState cameraState = CameraState.initial;
  RequestType cameraType = RequestType.video;
  final videoInfo = FlutterVideoInfo();
  Timer? _timer;
  bool timerIsRunning = false;
  late ValueNotifier<int> timeRemaining;
  late ThemeData appTheme;

  Timer? _preRecordingTimer;
  bool preRecordingTimerIsRunning = false;
  late ValueNotifier<int> preRecordingTimerRemaining;


  @override
  void initState() {
    timeRemaining = ValueNotifier(duration.value);
    preRecordingTimerRemaining = ValueNotifier(preRecordingTimerDurationStartValue.value);
    controller = CameraController(widget.cameras[description.value], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {return;}
      initialized.value = true;
      pickFirstAssetFromGallery(RequestType.video);
    }).catchError((Object e) {
      error.value = "Oops! unable to start camera";
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
    onWidgetBindingComplete(onComplete: () {
      appTheme = Theme.of(context);
      context.read<ThemeCubit>().setSystemUIOverlaysToDark();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _timer?.cancel();
    _preRecordingTimer?.cancel();
    super.dispose();
  }

  ///! PRE- Recording Timer functions

  void startPreTimer(Function() onComplete) {
    if(!preRecordingTimerIsRunning) {
      _resumePreTimer();
      _createPreTimer(onComplete);
    }
  }
  void pausePreTimer() {
    preRecordingTimerIsRunning = false;
    _preRecordingTimer?.cancel();
  }

  void stopPreTimer() {
    pausePreTimer();
    preRecordingTimerRemaining.value = preRecordingTimerDurationStartValue.value;
  }

  //Not called directly
  void _createPreTimer(Function() onComplete) {
    _preRecordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {

      if(!preRecordingTimerIsRunning) {
        return;
      }

      if (preRecordingTimerRemaining.value > 0) {
        preRecordingTimerRemaining.value = preRecordingTimerRemaining.value - 1;
        debugPrint("customLog: preRecordingTimerRemaining: ${preRecordingTimerRemaining.value}");
        isPreTimerAnimating.value = true;
      } else {
        // Countdown is complete, you can perform any action here
        stopPreTimer();

        ///! timer ended. do something here
        onComplete.call();
      }
    });
  }

  //Not called directly
  void _resumePreTimer() {
    preRecordingTimerIsRunning = true;
  }

  ///! End of PRE- Recording Timer functions

  ///! Recording Timer functions
  void startTimer() {
    if(!timerIsRunning) {
      _resumeTimer();
      _createTimer();
    }
  }
  void pauseTimer() {
    timerIsRunning = false;
    _timer?.cancel();
  }

  void stopTimer() {
    pauseTimer();
    timeRemaining.value = duration.value;
  }

  //Not called directly
  void _createTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      if(!timerIsRunning) {
        return;
      }

      if (timeRemaining.value > 0) {
        timeRemaining.value = timeRemaining.value - 1;
      } else {
        // Countdown is complete, you can perform any action here
        stopTimer();

        ///! timer ended. do somthing here
        stopAndPreviewRecording();
      }
    });
  }

  //Not called directly
  void _resumeTimer() {
    timerIsRunning = true;
  }
  /// End or recording timer functions


  Widget cameraWidget(context, {Widget? child}) {
    final camera = controller.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(controller,),
      ),
    );

  }

  // start recording
  void startVideoRecording() {

    try {

       controller.startVideoRecording().then((value) {
        setState(() {
          startTimer();
          cameraState = CameraState.recording;
        });
      });
    } on CameraException catch (e) {
      if(mounted) {
        context.showSnackBar(e.toString(), appearance: NotificationAppearance.info);
      }
      return;
    }
  }

  void stopVideoRecording({Function(File)? onSuccess}) async {

    try {
      controller.stopVideoRecording().then((value) {
        onSuccess?.call(File(value.path));
        setState(() {
          stopTimer();
          cameraState = CameraState.initial;
        });
      });

    } on CameraException catch (e) {
      if(mounted) {
        context.showSnackBar(e.toString(), appearance: NotificationAppearance.info);
      }
      return;
    }
  }

  void pauseVideoRecording()  {
    try {
       controller.pauseVideoRecording().then((value) {
         setState(() {
           pauseTimer();
           cameraState = CameraState.paused;
         });
       });
    } on CameraException catch (e) {
      if(mounted) {
        context.showSnackBar(e.toString(), appearance: NotificationAppearance.info);
      }
      return;
    }
  }

  void resumeVideoRecording() {

    try {
      controller.resumeVideoRecording().then((value) {
        setState(() {
          startTimer();
          cameraState = CameraState.recording;
        });
      });
    } on CameraException catch (e) {
      if(mounted) {
        context.showSnackBar(e.toString(), appearance: NotificationAppearance.info);
      }
      return;
    }
  }

  void stopAndPreviewRecording() async {
    stopVideoRecording(onSuccess: (file) {
      if(mounted) {
        context.pushScreen(FeedEditorPreviewPage(file: file, fileType: FileType.video, appTheme: appTheme,));
      }
    });
  }

  void capturePhoto({Function(File)? onSuccess}) async {

    try {
      controller.takePicture().then((value) {
        onSuccess?.call(File(value.path));
        setState(() {
          stopTimer();
          cameraState = CameraState.initial;
        });
      });

    } on CameraException catch (e) {
      if(mounted) {
        context.showSnackBar(e.toString(), appearance: NotificationAppearance.info);
      }
      return;
    }
  }

  void takePhotoAndPreview() async {
    capturePhoto(onSuccess: (file) {
      context.pushScreen(FeedEditorPreviewPage(file: file, fileType: FileType.image, appTheme: appTheme,));
    });

  }

  /// For displaying first gallery item on the camera
  void pickFirstAssetFromGallery (RequestType requestType) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth || ps.hasAccess) {
      // Granted
      // You can to get assets here.
      final albums = await PhotoManager.getAssetPathList(
          type: requestType
      );
      if(albums.isNotEmpty) {
        final selectedAlbum = albums[0];
        // Now that we got the album, fetch all the assets it contains
        final recentAssets = await selectedAlbum.getAssetListRange(
          start: 0, // start at index 0
          end: 1, // we need only one asset
        );
        if(recentAssets.isNotEmpty) {
            setState(() {
              firstGalleryItem = recentAssets.first;
            });
        }
      }

      // Update the state and notify UI
      // albumName.value = selectedAlbum.name;
    }
  }

  /// When file is selected from the gallery
  void onFileSelectedFromGalleryHandler(BuildContext context, {required File file, required FileType fileType}) async {

      context.pushScreen(FeedEditorPreviewPage(file: file, fileType: fileType, feedPurpose: widget.purpose, appTheme: appTheme,));

  }

  /// Build camera UI
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.darkColorScheme.background,
      body: ValueListenableBuilder<String?>(valueListenable: error, builder: (BuildContext context, String? value, Widget? child) {
        if(value != null) {
          return Center(
            child: Text(value),
          );
        }
        return ValueListenableBuilder<bool>(valueListenable: initialized, builder: (_, val, __) {
          if(!val) {
            return const Center(
              child: CustomAdaptiveCircularIndicator(),
            );
          }
          return Stack(
             children: [
               cameraWidget(context,),
               SafeArea(
                 top: true,
                 child: Stack(
                   children: [

                     if(cameraState != CameraState.recording) ... {
                       CloseButton(color: AppColors.darkColorScheme.onBackground,),
                     },
                     if(cameraState == CameraState.initial) ... {
                       Positioned(
                         left: 0, right: 10,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             cameraType == RequestType.image ? Chip(label: Text("Photo", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),),
                               backgroundColor: AppColors.darkColorScheme.background,
                             ) : GestureDetector(onTap: () {
                              setState(() {
                                cameraType = RequestType.image;
                                preRecordingTimerDurationStartValue.value = 0;
                                preRecordingTimerRemaining.value = preRecordingTimerDurationStartValue.value;
                                pickFirstAssetFromGallery(RequestType.image);
                              });
                             }, child: Text("Photo", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),)),

                             const SizedBox(width: 10,),

                             cameraType == RequestType.video ? Chip(label: Text("Video", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),),
                               backgroundColor: AppColors.darkColorScheme.background,
                             ) : GestureDetector(onTap: () {
                               setState(() {
                                 cameraType = RequestType.video;
                                 preRecordingTimerDurationStartValue.value = 3;
                                 preRecordingTimerRemaining.value = preRecordingTimerDurationStartValue.value;
                                 pickFirstAssetFromGallery(RequestType.video);
                               });
                             }, child: Text("Video", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),)),

                           ],
                         ),
                       )
                     },
                     if(cameraState != CameraState.recording) ... {
                       Positioned(right: 10,

                         child: SeparatedColumn(
                           mainAxisSize: MainAxisSize.min,
                           separatorBuilder: (BuildContext context, int index) {
                             return const SizedBox(height: 10,);
                           },
                           children: [
                             ValueListenableBuilder<int>(valueListenable: description, builder: (_, desc, __) {
                               return ValueListenableBuilder<bool>(valueListenable: flashOn, builder: (_, val, __) {
                                 if(desc > 0) {
                                   return const SizedBox.shrink();
                                 }
                                 return Column(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     IconButton(onPressed: () {
                                       if(val) {
                                         controller.setFlashMode(FlashMode.off);
                                       }else{
                                         controller.setFlashMode(FlashMode.torch);
                                       }
                                       flashOn.value = !flashOn.value;
                                     }, icon: Icon(val ? Icons.flash_on_rounded : Icons.flash_off, color: AppColors.darkColorScheme.onBackground, size: 22,),),
                                     Text(val ? "   Flash On" : "  Flash off", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontSize: 12),),
                                   ],);
                               });
                             }),

                             if(preRecordingTimerRemaining.value == preRecordingTimerDurationStartValue.value) ... {
                               ValueListenableBuilder<int>(valueListenable: preRecordingTimerDurationStartValue, builder: (_, val, __) {
                                 return Column(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     IconButton(onPressed: () {
                                       // timer.value = val == 0 ? timer.value +
                                       if(val == 0) {
                                         preRecordingTimerDurationStartValue.value = 3;
                                         preRecordingTimerRemaining.value = preRecordingTimerDurationStartValue.value;
                                       }
                                       if(val == 3) {
                                         preRecordingTimerDurationStartValue.value = 5;
                                         preRecordingTimerRemaining.value = preRecordingTimerDurationStartValue.value;
                                       }
                                       if(val == 5) {
                                         preRecordingTimerDurationStartValue.value = 9;
                                         preRecordingTimerRemaining.value = preRecordingTimerDurationStartValue.value;
                                       }
                                       if(val == 9) {
                                         preRecordingTimerDurationStartValue.value = 0;
                                         preRecordingTimerRemaining.value = preRecordingTimerDurationStartValue.value;
                                       }
                                       isTimerAnimating.value = true;
                                     }, icon: Icon( val == 0 ? Icons.timer_off_rounded : Icons.timer_rounded , color:  AppColors.darkColorScheme.onBackground, size: 22,),),
                                     Text(val == 0 ? "  Timer off" : " Timer ${val}sec", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontSize: 12),),
                                   ],
                                 );
                               }),
                             },

                             if(widget.cameras.length > 1) ... {
                               Column(
                                 children: [
                                   IconButton(onPressed: () {
                                     if(description.value > 0) {
                                       description.value = 0;
                                     }
                                     // turn to front camera
                                     else if(widget.cameras.length > 1) {
                                       description.value = 1;
                                     }
                                     controller.setDescription(widget.cameras[description.value]);
                                   }, icon: Icon( Icons.rotate_left_outlined , color:  AppColors.darkColorScheme.onBackground, size: 24,),),
                                   Text("Flip camera", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontSize: 12),),
                                 ],
                               )
                             }
                           ],
                         ),),
                     },

                     /// video type &&  initial  state
                     if(cameraType == RequestType.video && cameraState == CameraState.initial) ... {
                       Align(
                         alignment: Alignment.bottomCenter,
                         child: Padding(
                           padding: const EdgeInsets.only(bottom: 20.0),
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: [
                               /// Durations --
                               ValueListenableBuilder<int>(valueListenable: duration, builder: (_, val, __) {
                                 return SingleChildScrollView(
                                   scrollDirection: Axis.horizontal,
                                   padding: const EdgeInsets.symmetric(horizontal: 20),
                                   child: SeparatedRow(
                                     separatorBuilder: (BuildContext context, int index) {
                                       return const SizedBox(width: 20,);
                                     },
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       //! 10 seconds
                                       val == const Duration(seconds: 10).inSeconds ? Chip(label: Text("${const Duration(seconds: 10).inSeconds}sec", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),),
                                         backgroundColor: AppColors.darkColorScheme.background,
                                       ) : GestureDetector(onTap: () {
                                         duration.value = 10;
                                         timeRemaining.value = duration.value;
                                       }, child: Text("${const Duration(seconds: 10).inSeconds}sec", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),)),

                                       //! 15 seconds
                                       val == const Duration(seconds: 15).inSeconds ? Chip(label: Text("${const Duration(seconds: 15).inSeconds}sec", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),),
                                         backgroundColor: AppColors.darkColorScheme.background,
                                       ) : GestureDetector(onTap: () {
                                         duration.value = 15;
                                         timeRemaining.value = duration.value;
                                       },child: Text("${const Duration(seconds: 15).inSeconds}sec", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),)),

                                       //! 30 seconds
                                       val == const Duration(seconds: 20).inSeconds ? Chip(label: Text("${const Duration(seconds: 20).inSeconds}sec", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),),
                                         backgroundColor: AppColors.darkColorScheme.background,
                                       ) : GestureDetector(onTap: () {
                                         duration.value = 20;
                                         timeRemaining.value = duration.value;
                                       }, child: Text("${const Duration(seconds: 20).inSeconds}sec", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),)),

                                       //! 45 seconds
                                       val == const Duration(seconds: 25).inSeconds ? Chip(label: Text("${const Duration(seconds: 25).inSeconds}sec", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),),
                                         backgroundColor: AppColors.darkColorScheme.background,
                                       ) : GestureDetector(onTap: () {
                                         duration.value = 25;
                                         timeRemaining.value = duration.value;
                                       },child: Text("${const Duration(seconds: 25).inSeconds}sec", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),)),

                                       //! 1 min
                                       //! 10 seconds
                                       val == const Duration(seconds: 30).inSeconds ? Chip(label: Text("${const Duration(seconds: 30).inSeconds}sec", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),),
                                         backgroundColor: AppColors.darkColorScheme.background,
                                       ) : GestureDetector(onTap: () {
                                         duration.value = 30;
                                         timeRemaining.value = duration.value;
                                       }, child: Text("${const Duration(seconds: 30).inSeconds}sec", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold),)),


                                     ],
                                   ),
                                 );
                               }),
                               const SizedBox(height: 20,),
                               //! Idle state
                               Container(
                                 padding: const EdgeInsets.symmetric(
                                     horizontal: 20
                                 ),
                                 width: double.maxFinite,
                                 child: Row(
                                   // mainAxisAlignment: MainAxisAlignment.center,
                                   mainAxisSize: MainAxisSize.max,
                                   children: [

                                     /// Gallery
                                     Expanded(child:
                                     GestureDetector(
                                       onTap: () async {
                                         context.pickFileFromGallery(fileType: FileType.video, onSuccess: (file) {
                                           onFileSelectedFromGalleryHandler(context, file: file, fileType: FileType.video);
                                         }, onError: (error) {
                                           // context.showSnackBar(error, appearance: NotificationAppearance.info);
                                         });

                                       },
                                       child: Column(
                                         mainAxisSize: MainAxisSize.min,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Container(width: 50, height: 50,
                                             decoration: BoxDecoration(
                                                 color: AppColors.darkColorScheme.outlineVariant,
                                                 borderRadius: BorderRadius.circular(8)
                                             ),
                                             child: firstGalleryItem != null ? ClipRRect(
                                               borderRadius: BorderRadius.circular(8),
                                               child: AssetEntityImage(
                                                 firstGalleryItem!,
                                                 isOriginal: false, // Defaults to `true`.
                                                 thumbnailSize: const ThumbnailSize.square(45), // Preferred value.
                                                 thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
                                                 // width: double.maxFinite,
                                                 // height: double.maxFinite,
                                                 fit: BoxFit.cover,
                                               ),
                                             ): Icon(FeatherIcons.image, color: AppColors.darkColorScheme.onBackground,),
                                           ),
                                           const SizedBox(height: 5,),
                                           Text("Gallery", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontSize: 12), textAlign: TextAlign.center,)
                                         ],
                                       ),
                                     )
                                     ),

                                     /// Shutter
                                     GestureDetector(
                                       onTap: () {
                                            if(preRecordingTimerDurationStartValue.value > 0) {
                                              startPreTimer(() {
                                                startVideoRecording();
                                              });
                                            }else {
                                              startVideoRecording();
                                            }
                                       },
                                       child: DecoratedBox(
                                         decoration: BoxDecoration(
                                             color: AppColors.darkColorScheme.background.withOpacity(0.3),
                                             borderRadius: BorderRadius.circular(100)
                                         ),
                                         // width: 100,
                                         // height: 100,
                                         child: CircularPercentIndicator(
                                           key: const ValueKey("initial-state"),
                                           radius: 45,
                                           lineWidth: 4.0,
                                           percent: 100 / 100,
                                           // percent: timerState.timeRemaining.toDouble(),
                                           center: Container(
                                             // width: 50,
                                             // height: 50,
                                             margin: const EdgeInsets.all(15),
                                             decoration: BoxDecoration(
                                                 borderRadius: BorderRadius.circular(50),
                                                 color: Colors.white
                                             ),
                                           ),
                                           circularStrokeCap: CircularStrokeCap.round,
                                           progressColor: AppColors.darkColorScheme.onBackground,
                                           backgroundColor: Colors.transparent,
                                         ),
                                       ),
                                     ),

                                     const Expanded(child: SizedBox.shrink())
                                   ],
                                 ),
                               )
                             ],
                           ),
                         ),
                       )
                     },

                     /// video type &&  recording state
                     if(cameraType == RequestType.video && cameraState == CameraState.recording) ... {
                       Align(
                         alignment: Alignment.bottomCenter,
                         child: Padding(
                           padding: const EdgeInsets.only(bottom: 20.0),
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: [

                               ValueListenableBuilder<int>(valueListenable: timeRemaining, builder: (_, val, __) {
                                 return Text(formatDuration(Duration(seconds: val)), style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold), textAlign: TextAlign.center,);
                               }),

                               const SizedBox(height: 20,),

                               //! recording state
                               Container(
                                 padding: const EdgeInsets.symmetric(
                                     horizontal: 20
                                 ),
                                 width: double.maxFinite,
                                 child: Row(
                                   // mainAxisAlignment: MainAxisAlignment.center,
                                   mainAxisSize: MainAxisSize.max,
                                   children: [

                                     ///
                                     const Expanded(child: SizedBox.shrink()),

                                     /// Shutter
                                     GestureDetector(
                                       onTap: () {
                                         pauseVideoRecording();
                                       },
                                       child: DecoratedBox(
                                         decoration: BoxDecoration(
                                             color: AppColors.darkColorScheme.background.withOpacity(0.3),
                                             borderRadius: BorderRadius.circular(100)
                                         ),
                                         // width: 100,
                                         // height: 100,
                                         child: ValueListenableBuilder<int>(valueListenable: timeRemaining, builder: (_, val, __) {
                                           return CircularPercentIndicator(
                                             key: const ValueKey("recording-state"),
                                             radius: 50,
                                             lineWidth: 4.0,
                                             animation: true,
                                             animateFromLastPercent: true,
                                             percent: (duration.value - val) / duration.value,
                                             animationDuration: 1000,
                                             // percent: timerState.timeRemaining.toDouble(),
                                             center: ClipRRect(
                                               borderRadius: BorderRadius.circular(100),
                                               child: ColoredBox(
                                                 color: AppColors.darkColorScheme.outline.withOpacity(0.5),
                                                 child: Center(
                                                   child: Container(
                                                     // width: 50,
                                                     // height: 50,
                                                     margin: const EdgeInsets.all(30),
                                                     decoration: BoxDecoration(
                                                         borderRadius: BorderRadius.circular(50),
                                                         color: Colors.red
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             circularStrokeCap: CircularStrokeCap.round,
                                             progressColor: Colors.redAccent,
                                             backgroundColor: Colors.transparent,
                                           );
                                         }),
                                       ),
                                     ),

                                     Expanded(child: IconButton(onPressed: (){

                                       // stop and preview
                                       stopAndPreviewRecording();

                                     }, icon: const Icon(Icons.check_circle, color: Colors.white, size: 28,)))
                                   ],
                                 ),
                               )
                             ],
                           ),
                         ),
                       )
                     },

                     /// video type && paused state
                     if(cameraType == RequestType.video && cameraState == CameraState.paused) ... {
                       Align(
                         alignment: Alignment.bottomCenter,
                         child: Padding(
                           padding: const EdgeInsets.only(bottom: 20.0),
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: [

                               Text(formatDuration(Duration(seconds: timeRemaining.value)), style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

                               const SizedBox(height: 20,),

                               //! Paused state
                               Container(
                                 padding: const EdgeInsets.symmetric(
                                     horizontal: 20
                                 ),
                                 width: double.maxFinite,
                                 child: Row(
                                   // mainAxisAlignment: MainAxisAlignment.center,
                                   mainAxisSize: MainAxisSize.max,
                                   children: [

                                     /// Stop
                                     Expanded(child: IconButton(onPressed: (){
                                       stopVideoRecording();
                                     }, icon: const Icon(Icons.delete_forever, color: Colors.white, size: 28,))),

                                     /// Shutter
                                     GestureDetector(
                                       onTap: () {
                                         if(preRecordingTimerDurationStartValue.value > 0) {
                                           startPreTimer(() {
                                             resumeVideoRecording();
                                           });
                                         }else {
                                           resumeVideoRecording();
                                         }
                                       },
                                       child: DecoratedBox(
                                         decoration: BoxDecoration(
                                             color: AppColors.darkColorScheme.background.withOpacity(0.3),
                                             borderRadius: BorderRadius.circular(100)
                                         ),
                                         // width: 100,
                                         // height: 100,
                                         child: CircularPercentIndicator(
                                           key: const ValueKey("paused-state"),
                                           radius: 50,
                                           lineWidth: 4.0,
                                           animateFromLastPercent: true,
                                           percent: ((duration.value - timeRemaining.value) / duration.value),
                                           // percent: timerState.timeRemaining.toDouble(),
                                           center: ClipRRect(
                                             borderRadius: BorderRadius.circular(100),
                                             child: ColoredBox(
                                               color: AppColors.darkColorScheme.outline.withOpacity(0.5),
                                               child: Center(
                                                 child: Container(
                                                   // width: 50,
                                                   // height: 50,
                                                   margin: const EdgeInsets.all(15),
                                                   decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.circular(50),
                                                       color: Colors.red
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ),
                                           circularStrokeCap: CircularStrokeCap.round,
                                           progressColor: Colors.redAccent,
                                           backgroundColor: theme.colorScheme.surface,
                                         ),
                                       ),
                                     ),

                                     Expanded(child: IconButton(onPressed: (){
                                          // stop and preview
                                       stopAndPreviewRecording();
                                     }, icon: const Icon(Icons.check_circle, color: Colors.white, size: 28,))
                                     )
                                   ],
                                 ),
                               )
                             ],
                           ),
                         ),
                       )
                     },

                     /// photo type &&
                     if(cameraType == RequestType.image) ... {
                       Align(
                         alignment: Alignment.bottomCenter,
                         child: Container(
                           padding: const EdgeInsets.only(
                               left: 20, right: 20, bottom: 20
                           ),
                           width: double.maxFinite,
                           child: Row(
                             // mainAxisAlignment: MainAxisAlignment.center,
                             mainAxisSize: MainAxisSize.max,
                             children: [

                               /// Gallery
                               Expanded(child:
                               GestureDetector(
                                 onTap: () {
                                   context.pickFileFromGallery(fileType: FileType.image, onSuccess: (file) {
                                     onFileSelectedFromGalleryHandler(context, file: file, fileType: FileType.image);
                                   }, onError: (error) {
                                     // context.showSnackBar(error, appearance: NotificationAppearance.info);
                                   });
                                 },
                                 child: Column(
                                   mainAxisSize: MainAxisSize.min,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Container(width: 50, height: 50,
                                       decoration: BoxDecoration(
                                           color: AppColors.darkColorScheme.outlineVariant,
                                           borderRadius: BorderRadius.circular(8)
                                       ),
                                       child: firstGalleryItem != null ? ClipRRect(
                                         borderRadius: BorderRadius.circular(8),
                                         child: AssetEntityImage(
                                           firstGalleryItem!,
                                           isOriginal: false, // Defaults to `true`.
                                           thumbnailSize: const ThumbnailSize.square(45), // Preferred value.
                                           thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
                                           // width: double.maxFinite,
                                           // height: double.maxFinite,
                                           fit: BoxFit.cover,
                                         ),
                                       ): Icon(FeatherIcons.image, color: AppColors.darkColorScheme.onBackground,),
                                     ),
                                     const SizedBox(height: 5,),
                                     Text("Gallery", style: TextStyle(color: AppColors.darkColorScheme.onBackground, fontSize: 12),)
                                   ],
                                 ),
                               )
                               ),

                               /// Shutter
                               GestureDetector(
                                 onTap: () {
                                   if(preRecordingTimerDurationStartValue.value > 0) {
                                     startPreTimer(() {
                                       takePhotoAndPreview();
                                     });
                                   }else {
                                     takePhotoAndPreview();
                                   }
                                 },
                                 child: DecoratedBox(
                                   decoration: BoxDecoration(
                                       color: AppColors.darkColorScheme.background.withOpacity(0.3),
                                       borderRadius: BorderRadius.circular(100)
                                   ),
                                   // width: 100,
                                   // height: 100,
                                   child: CircularPercentIndicator(
                                     key: const ValueKey("photo-state"),
                                     radius: 45,
                                     lineWidth: 4.0,
                                     percent: 100 / 100,
                                     // percent: timerState.timeRemaining.toDouble(),
                                     center: Container(
                                       // width: 50,
                                       // height: 50,
                                       margin: const EdgeInsets.all(10),
                                       decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(50),
                                           color: Colors.white
                                       ),
                                     ),
                                     circularStrokeCap: CircularStrokeCap.round,
                                     progressColor: AppColors.darkColorScheme.onBackground,
                                     backgroundColor: Colors.transparent,
                                   ),
                                 ),
                               ),

                               const Expanded(child: SizedBox.shrink())
                             ],
                           ),
                         ),
                       )
                     },

                     Align(
                       alignment: Alignment.center,
                       child: ValueListenableBuilder<bool>(valueListenable: isTimerAnimating, builder: (_, value, __) {
                         return Opacity(
                           opacity: value ? 1 : 0,
                           child: CustomHeartAnimationWidget(
                             isAnimating: value,
                             duration: const Duration(milliseconds: 700),
                             onEnd: () {
                               isTimerAnimating.value = false;
                             },
                             child: Text(preRecordingTimerDurationStartValue.value == 0 ? "Timer off" : "Timer ${preRecordingTimerDurationStartValue.value}sec", style: theme.textTheme.titleLarge?.copyWith(fontSize: 50, color: AppColors.darkColorScheme.onBackground),),
                           ),
                         );
                       }),
                     ),

                     // Pre timer count
                     Align(
                       alignment: Alignment.center,
                       child: ValueListenableBuilder<bool>(valueListenable: isPreTimerAnimating, builder: (_, value, __) {
                         return Opacity(
                           opacity: value ? 1 : 0,
                           child: CustomHeartAnimationWidget(
                             isAnimating: value,
                             duration: const Duration(milliseconds: 200),
                             delay: const Duration(milliseconds: 200),
                             onEnd: () {
                               isPreTimerAnimating.value = false;
                               debugPrint("customLog: onEnd called");
                             },
                             child: Text("${preRecordingTimerRemaining.value + 1}", style: theme.textTheme.titleLarge?.copyWith(fontSize: 50, color: AppColors.darkColorScheme.onBackground),),
                           ),
                         );
                       }),
                     )

                   ],
                 ),
               )
             ],
          );
        });
      },),
    );
  }
}
