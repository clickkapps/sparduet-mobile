// import 'dart:io';
// import 'package:go_router/go_router.dart';
// import 'package:sparkduet/core/app_colors.dart';
// import 'package:sparkduet/core/app_constants.dart';
// import 'package:sparkduet/packages/video_trimmer_lib/video_trimmer.dart';
// import 'package:sparkduet/utils/custom_button_widget.dart';
// // import 'package:video_trimmer/video_trimmer.dart';
// import 'package:flutter/material.dart';
//
// class VideoTrimmerPage extends StatefulWidget {
//
//   final File file;
//   const VideoTrimmerPage({super.key, required this.file});
//
//   @override
//   State<VideoTrimmerPage> createState() => _VideoTrimmerPageState();
// }
//
// class _VideoTrimmerPageState extends State<VideoTrimmerPage> {
//
//   final Trimmer _trimmer = Trimmer();
//   double _startValue = 0.0;
//   double _endValue = 0.0;
//   final ValueNotifier<bool> saving = ValueNotifier(false);
//
//   @override
//   void initState() {
//     super.initState();
//     _loadVideo();
//   }
//
//   void _saveVideo(BuildContext context) async {
//
//     _trimmer.saveTrimmedVideo(startValue: _startValue, endValue: _endValue, onSave: (String? outputPath) {
//           if(outputPath != null) {
//             context.pop(File(outputPath));
//           }else {
//             context.pop();
//           }
//
//     });
//
//   }
//
//   void _loadVideo() async {
//     await _trimmer.loadVideo(videoFile: widget.file);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.darkColorScheme.background,
//       appBar: AppBar(
//         title: const Text("Trim video", style: TextStyle(fontSize: 14),),
//         elevation: 0,
//         iconTheme: IconThemeData(color: AppColors.darkColorScheme.onBackground),
//         backgroundColor: Colors.transparent,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: TrimViewer(
//             trimmer: _trimmer,
//             viewerHeight: 50.0,
//             viewerWidth: MediaQuery.of(context).size.width,
//             maxVideoLength:  Duration(seconds: AppConstants.maximumVideoDuration.toInt()),
//             showDuration: false,
//             onChangeStart: (value) => _startValue = value,
//             onChangeEnd: (value) => _endValue = value,
//             onChangePlaybackState: (value) {},
//           ),
//         ),
//       ),
//       extendBodyBehindAppBar: false,
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.buttonBlue,
//         onPressed: () {
//           _saveVideo(context);
//         },
//         child: Icon(Icons.check, color: AppColors.darkColorScheme.onBackground,),
//       ),
//       // bottomNavigationBar: BottomAppBar(
//       //   color: AppColors.darkColorScheme.background,
//       //   child: Container(
//       //     decoration: BoxDecoration(
//       //         color: AppColors.darkColorScheme.background
//       //     ),
//       //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       //     child: Row(
//       //       children: [
//       //         Expanded(child: CustomButtonWidget(onPressed: (){
//       //
//       //         }, text: "Done", appearance: ButtonAppearance.secondary, expand: true,)),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//       body: GestureDetector(
//         onTap: () async {
//           await _trimmer.videoPlaybackControl(
//             startValue: _startValue,
//             endValue: _endValue,
//           );
//         },
//         child: VideoViewer(trimmer: _trimmer,),
//       ) ,
//     );
//   }
// }
