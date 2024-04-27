import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';

enum VideoSource { file, network, asset }
enum VideoSrcStatus { ready, loading, error }
class CustomVideoPlayer extends StatefulWidget {

  final bool autoPlay;
  final bool mute;
  final bool loop;
  final File? file;
  final bool showDefaultControls;
  final bool showCustomVolumeButton;
  final bool? enableProgressBar;
  final VideoSource videoSource;
  final String? networkUrl;
  final String? mediaId;
  final String? assetUrl;
  final Function()? onComplete;
  final Function(int value)? onChange;
  final double? aspectRatio;
  final BoxFit? fit;
  final Function()? onTap;
  final double? maxWidth;
  final double? maxHeight;
  final bool hls;
  final bool? showControlsOnInitialize;
  final Function({required bool hidden})? controlsVisibilityChanged;
  final Map<String, String>? headers;
  final Function(BetterPlayerController)? builder;
  const CustomVideoPlayer({
    super.key,
    this.autoPlay = true,
    this.mute = true,
    this.loop = true,
    this.hls = false,
    this.showDefaultControls = false,
    this.enableProgressBar,
    this.showCustomVolumeButton = true,
    this.showControlsOnInitialize,
    required this.videoSource,
    this.file,
    this.networkUrl,
    this.mediaId,
    this.assetUrl,
    this.onChange,
    this.onComplete,
    this.aspectRatio,
    this.fit,
    this.onTap,
    this.maxWidth,
    this.maxHeight,
    this.controlsVisibilityChanged,
    this.headers,
    this.builder
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {

  // this property is here because, sometimes the video link or file may not be readily available,
  // and we might have to load link/file from the server or from our asset folder
  late ValueNotifier<VideoSrcStatus> videoSourceStatus = ValueNotifier(VideoSrcStatus.ready);
  late BetterPlayerController _betterPlayerController;
  final ValueNotifier<bool> videoPlayerInitialized = ValueNotifier(false);

  @override
  void initState() {
    _initializePlayer();
    super.initState();
  }

  void _initializePlayer() async {

    late BetterPlayerDataSource betterPlayerDataSource;
    if (widget.videoSource == VideoSource.network) {

      videoSourceStatus.value = VideoSrcStatus.loading;
      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.networkUrl!,
        videoFormat: widget.hls == true ? BetterPlayerVideoFormat.hls : null,
        headers: widget.headers,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
        ),

      );

    }else if (widget.videoSource == VideoSource.file) {

      videoSourceStatus.value = VideoSrcStatus.loading;
      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        widget.file!.path,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
            useCache: true
        ),
      );

    }else if (widget.videoSource == VideoSource.asset && !widget.assetUrl.isNullOrEmpty()) {

      videoSourceStatus.value = VideoSrcStatus.loading;
      final file  = await getFileFromAssets(widget.assetUrl ?? '');

      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        file.path,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
            useCache: true
        ),
      );
    }

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
          autoPlay: widget.autoPlay,
          looping: widget.loop,
          fit: widget.fit ?? BoxFit.fill,
          eventListener: _playerEventListener,
          controlsConfiguration: BetterPlayerControlsConfiguration(
              showControls: widget.showDefaultControls,
              enableMute: true,
              showControlsOnInitialize: widget.showControlsOnInitialize ?? false,
              enableFullscreen: false,
              enableAudioTracks: false,
              enableOverflowMenu: false,
              enablePlayPause: false,
              enableProgressBar: widget.enableProgressBar ?? false,
              enablePlaybackSpeed: true,
              enableSkips: false,
              enableProgressBarDrag: true,
              enableSubtitles: false,
              enableProgressText: false,
              enableQualities: false,
              loadingWidget: const CustomAdaptiveCircularIndicator(),

          )),

      betterPlayerDataSource: betterPlayerDataSource,

    );

  }

  void _playerEventListener(BetterPlayerEvent event) {
    // debugPrint("event: ${event.betterPlayerEventType} , data: ${event.parameters}");
    if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
      _betterPlayerController.setOverriddenAspectRatio(widget.aspectRatio ?? _betterPlayerController.videoPlayerController!.value.aspectRatio);
      widget.builder?.call(_betterPlayerController);
      // if(widget.fit != null){
      //   _betterPlayerController.setOverriddenFit(widget.fit!);
      // }
      videoSourceStatus.value = VideoSrcStatus.ready;
      videoPlayerInitialized.value = true;

    }
    if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
      videoSourceStatus.value = VideoSrcStatus.error;
    }
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }


  Widget _videoPlaceholderWidget(BuildContext context, {String? text}) {
    final theme = Theme.of(context);
    return Center(
      child: text != null ?   Text(text, style: const TextStyle(color: AppColors.white),) :
      const CustomAdaptiveCircularIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {

    final media = MediaQuery.of(context);

    // return ConstrainedBox(
    //   constraints: BoxConstraints(
    //       maxWidth : widget.maxWidth ?? media.size.width,
    //       maxHeight : widget.maxHeight ?? media.size.height
    //   ), child:
    // ,);
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.black,
        ),

        child: Center(
          child: ValueListenableBuilder<VideoSrcStatus>(valueListenable: videoSourceStatus, builder: (_, videoSrcStatus, ch){
            if(videoSrcStatus == VideoSrcStatus.ready){
              return ValueListenableBuilder<bool>(valueListenable: videoPlayerInitialized, builder: (ctx, videoInitialized, _) {
                if(videoInitialized) {
                  return BetterPlayer(
                    controller: _betterPlayerController,
                  );
                }
                return  _videoPlaceholderWidget(ctx);
              });
            }

            if(videoSrcStatus == VideoSrcStatus.error) {
              return _videoPlaceholderWidget(context, text: "Oops!. Unable to load video");
            }
            return _videoPlaceholderWidget(context);
          }),
        )

    );
  }
}
