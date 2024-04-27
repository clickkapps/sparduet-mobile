import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';

class FeedEditorVideoPreviewWidget extends StatefulWidget {

  final File file;
  final Function(BetterPlayerController)? builder;
  const FeedEditorVideoPreviewWidget({super.key, required this.file, this.builder});

  @override
  State<FeedEditorVideoPreviewWidget> createState() => _FeedEditorVideoPreviewWidgetState();

}

class _FeedEditorVideoPreviewWidgetState extends State<FeedEditorVideoPreviewWidget> {

  BetterPlayerController? betterPlayerController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if(betterPlayerController?.isPlaying() ?? false) {
              betterPlayerController?.pause();
            }else{
              betterPlayerController?.play();
            }
          },
          behavior: HitTestBehavior.opaque,
          child: IgnorePointer(
            child: CustomVideoPlayer(
              autoPlay: true,
              loop: true,
              showDefaultControls: false,
              // aspectRatio: mediaQuery.size.width / mediaQuery.size.height,
              hls: false,
              fit: BoxFit.cover,
              videoSource: VideoSource.file,
              file: widget.file,
              builder: (controller) {
                widget.builder?.call(controller);
                return betterPlayerController = controller;
              },
            ),
          ),
        )
      ],
    );
  }
}
