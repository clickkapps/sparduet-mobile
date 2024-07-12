import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/crop_page.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/export_result.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/export_service.dart';
import 'package:sparkduet/utils/custom_play_pause_icon_widget.dart';
// import 'package:video_trimmer/video_trimmer.dart';
import 'dart:math' as math;

import 'package:video_editor/video_editor.dart';

// import 'package:video_trimmer/video_trimmer.dart';

// class FeedEditorVideoPreviewWidget extends StatefulWidget {
//
//   final File file;
//   final Function(double, double)? builder;
//   // final Trimmer trimmer;
//   final bool frontCameraVideo;
//   const FeedEditorVideoPreviewWidget({super.key, required this.file, this.builder, required this.trimmer, this.frontCameraVideo = false});
//
//   @override
//   State<FeedEditorVideoPreviewWidget> createState() => _FeedEditorVideoPreviewWidgetState();
//
// }
//
// class _FeedEditorVideoPreviewWidgetState extends State<FeedEditorVideoPreviewWidget> {
//
//   double _startValue = 0.0;
//   double _endValue = 0.0;
//   bool _isPlaying = false;
//   late VideoEditorController _controller;
//
//   @override
//   void initState() {
//     _loadVideo();
//     super.initState();
//   }
//
//   void _loadVideo() async {
//
//     _controller = VideoEditorController.file(widget.file)
//       ..initialize().then((_) {
//         setState(() {}); // Refresh the UI when initialization is complete
//       });
//
//     // await widget.trimmer.loadVideo(videoFile: widget.file);
//     // widget.trimmer.videoPlayerController?.setLooping(true);
//     //
//     // final playBackState = await widget.trimmer.videoPlaybackControl(
//     //   startValue: _startValue,
//     //   endValue: _endValue,
//     // );
//     //
//     // setState(() {
//     //   _isPlaying = playBackState;
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trim Video'),
//       ),
//       body: _controller.initialized
//           ? Column(
//         children: [
//           Expanded(
//             child: VideoEditor(
//               controller: _controller,
//               trimStyle: TrimSliderStyle(
//                 background: Colors.black.withOpacity(0.2),
//                 positionLineColor: Colors.white,
//                 positionLineWidth: 3,
//                 borderRadius: 5.0,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await _controller.exportTrimmedVideo();
//               // Handle the trimmed video file here
//             },
//             child: Text('Trim'),
//           ),
//         ],
//       )
//           : Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//     // return Stack(
//     //   children: [
//     //     GestureDetector(
//     //       onTap: () async {
//     //         await widget.trimmer.videoPlaybackControl(
//     //           startValue: _startValue,
//     //           endValue: _endValue,
//     //         );
//     //       },
//     //       // child: VideoViewer(trimmer: widget.trimmer),
//     //       child: widget.frontCameraVideo ? Transform(
//     //         alignment: Alignment.center,
//     //         transform: Matrix4.rotationY(math.pi),
//     //         child: VideoViewer(trimmer: widget.trimmer)
//     //       ): VideoViewer(trimmer: widget.trimmer, ),
//     //     ),
//     //     if(!_isPlaying) ... {
//     //       const Center(
//     //         child: CustomPlayPauseIconWidget(eventType: BetterPlayerEventType.play,),
//     //       )
//     //     },
//     //     TrimViewer(
//     //       trimmer: widget.trimmer,
//     //       viewerHeight: 50.0,
//     //       viewerWidth: MediaQuery.of(context).size.width,
//     //       maxVideoLength:  Duration(seconds: AppConstants.maximumVideoDuration.toInt()),
//     //       showDuration: false,
//     //       onChangeStart: (value) {
//     //         _startValue = value;
//     //         widget.builder?.call(_startValue, _endValue);
//     //       },
//     //       onChangeEnd: (value) {
//     //         _endValue = value;
//     //         widget.builder?.call(_startValue, _endValue);
//     //       },
//     //       onChangePlaybackState: (value) {
//     //         setState(() => _isPlaying = value);
//     //       },
//     //     ),
//     //   ],
//     // );
//   }
// }

//-------------------//
//VIDEO EDITOR SCREEN//
//-------------------//
class FeedEditorVideoPreviewWidget extends StatefulWidget {
  final bool frontCameraVideo;
  final File file;

  const FeedEditorVideoPreviewWidget({super.key, required this.file, required this.frontCameraVideo});



  @override
  State<FeedEditorVideoPreviewWidget> createState() => _FeedEditorVideoPreviewWidgetState();
}

class _FeedEditorVideoPreviewWidgetState extends State<FeedEditorVideoPreviewWidget> {




  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() async {

    super.dispose();
  }




  // void _exportCover() async {
  //   final config = CoverFFmpegVideoEditorConfig(_controller);
  //   final execute = await config.getExecuteConfig();
  //   if (execute == null) {
  //     _showErrorSnackBar("Error on cover exportation initialization.");
  //     return;
  //   }
  //
  //   await ExportService.runFFmpegCommand(
  //     execute,
  //     onError: (e, s) => _showErrorSnackBar("Error on cover exportation :("),
  //     onCompleted: (cover) {
  //       if (!mounted) return;
  //
  //       showDialog(
  //         context: context,
  //         builder: (_) => CoverResultPopup(cover: cover),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: false,
      // onWillPop: () async => false,
      child: Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          actions: [

          ],
        ),
        // body: _controller.initialized
        //     ? SafeArea(
        //   child: Stack(
        //     children: [
        //       Column(
        //         children: [
        //           Expanded(
        //             child: DefaultTabController(
        //               length: 2,
        //               child: Column(
        //                 children: [
        //                   Expanded(
        //                     child: TabBarView(
        //                       physics:
        //                       const NeverScrollableScrollPhysics(),
        //                       children: [
        //                         Stack(
        //                           alignment: Alignment.center,
        //                           children: [
        //                             CropGridViewer.preview(
        //                                 controller: _controller),
        //                             AnimatedBuilder(
        //                               animation: _controller.video,
        //                               builder: (_, __) => AnimatedOpacity(
        //                                 opacity:
        //                                 _controller.isPlaying ? 0 : 1,
        //                                 duration: kThemeAnimationDuration,
        //                                 child: GestureDetector(
        //                                   onTap: _controller.video.play,
        //                                   child: Container(
        //                                     width: 40,
        //                                     height: 40,
        //                                     decoration:
        //                                     const BoxDecoration(
        //                                       color: Colors.white,
        //                                       shape: BoxShape.circle,
        //                                     ),
        //                                     child: const Icon(
        //                                       Icons.play_arrow,
        //                                       color: Colors.black,
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                         CoverViewer(controller: _controller)
        //                       ],
        //                     ),
        //                   ),
        //                   Container(
        //                     height: 200,
        //                     margin: const EdgeInsets.only(top: 10),
        //                     child: Column(
        //                       mainAxisAlignment:
        //                       MainAxisAlignment.center,
        //                       children: _trimSlider(),
        //                     ),
        //                   ),
        //                   ValueListenableBuilder(
        //                     valueListenable: _isExporting,
        //                     builder: (_, bool export, Widget? child) =>
        //                         AnimatedSize(
        //                           duration: kThemeAnimationDuration,
        //                           child: export ? child : null,
        //                         ),
        //                     child: AlertDialog(
        //                       title: ValueListenableBuilder(
        //                         valueListenable: _exportingProgress,
        //                         builder: (_, double value, __) => Text(
        //                           "Exporting video ${(value * 100).ceil()}%",
        //                           style: const TextStyle(fontSize: 12),
        //                         ),
        //                       ),
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //           )
        //         ],
        //       )
        //     ],
        //   ),
        // )
        //     : const Center(child: CircularProgressIndicator()),
      ),
    );
  }



  // Widget _coverSelection() {
  //   return SingleChildScrollView(
  //     child: Center(
  //       child: Container(
  //         margin: const EdgeInsets.all(15),
  //         child: CoverSelection(
  //           controller: _controller,
  //           size: height + 10,
  //           quantity: 8,
  //           selectedCoverBuilder: (cover, size) {
  //             return Stack(
  //               alignment: Alignment.center,
  //               children: [
  //                 cover,
  //                 Icon(
  //                   Icons.check_circle,
  //                   color: const CoverSelectionStyle().selectedBorderColor,
  //                 )
  //               ],
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
