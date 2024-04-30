import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:video_trimmer/video_trimmer.dart';

class FeedEditorVideoPreviewWidget extends StatefulWidget {

  final File file;
  final Function(double, double)? builder;
  final Trimmer trimmer;
  const FeedEditorVideoPreviewWidget({super.key, required this.file, this.builder, required this.trimmer});

  @override
  State<FeedEditorVideoPreviewWidget> createState() => _FeedEditorVideoPreviewWidgetState();

}

class _FeedEditorVideoPreviewWidgetState extends State<FeedEditorVideoPreviewWidget> {

  double _startValue = 0.0;
  double _endValue = 0.0;

  @override
  void initState() {
    _loadVideo();
    super.initState();
  }

  void _loadVideo() async {
    await widget.trimmer.loadVideo(videoFile: widget.file);
    widget.builder?.call(_startValue, _endValue);
    await widget.trimmer.videoPlaybackControl(
      startValue: _startValue,
      endValue: _endValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            await widget.trimmer.videoPlaybackControl(
              startValue: _startValue,
              endValue: _endValue,
            );
          },
          child: VideoViewer(trimmer: widget.trimmer),
        ),
        TrimViewer(
          trimmer: widget.trimmer,
          viewerHeight: 50.0,
          viewerWidth: MediaQuery.of(context).size.width,
          maxVideoLength:  Duration(seconds: AppConstants.maximumVideoDuration.toInt()),
          showDuration: false,
          onChangeStart: (value) {
            _startValue = value;
            widget.builder?.call(_startValue, _endValue);
          },
          onChangeEnd: (value) {
            _endValue = value;
            widget.builder?.call(_startValue, _endValue);
          },
          onChangePlaybackState: (value) {},
        ),
      ],
    );
  }
}
