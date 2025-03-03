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
  final Function(double value)? onProgress;
  final double? aspectRatio;
  final BoxFit? fit;
  final Function()? onTap;
  final double? maxWidth;
  final double? maxHeight;
  final bool hls;
  final bool useCache;
  final String? cacheKey;
  final bool? showControlsOnInitialize;
  final Function({required bool hidden})? controlsVisibilityChanged;
  final Map<String, String>? headers;
  final Function(BetterPlayerController)? builder;
  final Color? backgroundColor;
  final Widget? placeholder;
  const CustomVideoPlayer({
    super.key,
    this.autoPlay = true,
    this.mute = true,
    this.loop = true,
    this.hls = false,
    this.useCache = false,
    this.cacheKey,
    this.showDefaultControls = false,
    this.enableProgressBar,
    this.showCustomVolumeButton = true,
    this.showControlsOnInitialize,
    required this.videoSource,
    this.file,
    this.networkUrl,
    this.mediaId,
    this.assetUrl,
    this.onProgress,
    this.onComplete,
    this.aspectRatio,
    this.fit,
    this.onTap,
    this.maxWidth,
    this.maxHeight,
    this.controlsVisibilityChanged,
    this.headers,
    this.builder,
    this.backgroundColor,
    this.placeholder
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
  double _aspectRatio = 9 / 16; // Default aspect ratio

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
        cacheConfiguration:  BetterPlayerCacheConfiguration(
          useCache: widget.useCache,
            key: widget.cacheKey
        ),

      );

    }else if (widget.videoSource == VideoSource.file) {

      videoSourceStatus.value = VideoSrcStatus.loading;
      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        widget.file!.path,
        cacheConfiguration: BetterPlayerCacheConfiguration(
            useCache: widget.useCache,
            key: widget.cacheKey
        ),
      );

    }else if (widget.videoSource == VideoSource.asset && !widget.assetUrl.isNullOrEmpty()) {

      videoSourceStatus.value = VideoSrcStatus.loading;
      final file  = await getFileFromAssets(widget.assetUrl ?? '');

      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        file.path,
        cacheConfiguration: BetterPlayerCacheConfiguration(
            useCache: widget.useCache,
            key: widget.cacheKey
        ),
      );
    }

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
          autoPlay: widget.autoPlay,
          looping: widget.loop,
          fit: widget.fit ?? BoxFit.cover,
          aspectRatio: _aspectRatio, // Default aspect ratio (adjust as necessary)
          eventListener: _playerEventListener,
          // fullScreenByDefault: true,
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
              loadingWidget: widget.placeholder ?? const CustomAdaptiveCircularIndicator(),

          )),
      betterPlayerDataSource: betterPlayerDataSource,

    );


  }

  void _playerEventListener(BetterPlayerEvent event) {
    // debugPrint("event: ${event.betterPlayerEventType} , data: ${event.parameters}");
    if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
      final aspectRatio = widget.aspectRatio ?? _betterPlayerController.videoPlayerController?.value.aspectRatio;

      if (aspectRatio != null && aspectRatio != _aspectRatio) {
        _aspectRatio = aspectRatio;
        _betterPlayerController.setOverriddenAspectRatio(aspectRatio);
      }

      // if(widget.fit != null){
      //   _betterPlayerController.setOverriddenFit(widget.fit!);
      // }
      videoSourceStatus.value = VideoSrcStatus.ready;
      videoPlayerInitialized.value = true;

      onWidgetBindingComplete(onComplete: () {
        widget.builder?.call(_betterPlayerController);
      });

    }
    if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
      videoSourceStatus.value = VideoSrcStatus.error;
    }

    if(event.betterPlayerEventType == BetterPlayerEventType.progress) {
      // debugPrint("event: ${event.betterPlayerEventType} , data: ${event.parameters}");
      final data = event.parameters;
      if(data == null) return;
      if(data.containsKey('progress') && data.containsKey('duration') && data["progress"] != null &&  data["duration"] != null) {
        // debugPrint("event: ${event.betterPlayerEventType} , data: ${event.parameters}");
        final progress = data["progress"] as Duration;
        final duration = data["duration"] as Duration;
        // Calculate the progress percentage
        double progressPercentage = calculateProgressPercentage(progress, duration);

        widget.onProgress?.call(progressPercentage);
        
        // debugPrint("time remaining: $differenceInSeconds");
      }
    }

  }

  double calculateProgressPercentage(Duration progress, Duration duration) {
    if (duration.inSeconds == 0) {
      return 0;
    }

    return (progress.inSeconds / duration.inSeconds) * 100;
  }

  String _formatTimeFromVid(String rawTime) {
    final t0 = rawTime.replaceAll('-', '');
    final t1 = t0.split('.')[0];
    final t2 = t1.split(':');
    final i1 = t2[0].padLeft(2, '0');
    final i2 = t2[1].padLeft(2, '0');
    final i3 = t2[2].padLeft(2, '0');
    final formatted = "$i1:$i2:$i3";
    return formatted;
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }


  Widget _videoPlaceholderWidget(BuildContext context, {String? text}) {
    final theme = Theme.of(context);
    return widget.placeholder ?? Center(
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
        decoration:  BoxDecoration(
          color: widget.backgroundColor ?? AppColors.darkColorScheme.surface,
          // color: Colors.yellow
        ),

        child: Center(
          child: ValueListenableBuilder<VideoSrcStatus>(valueListenable: videoSourceStatus, builder: (_, videoSrcStatus, ch){
            if(videoSrcStatus == VideoSrcStatus.ready){
              return ValueListenableBuilder<bool>(valueListenable: videoPlayerInitialized, builder: (ctx, videoInitialized, _) {
                final aspectRatio = widget.aspectRatio ?? _betterPlayerController.videoPlayerController!.value.aspectRatio;
                if(videoInitialized) {
                  return Align(
                    alignment: aspectRatio > 0.6 ? Alignment.center : Alignment.bottomCenter,
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: BetterPlayer(
                        controller: _betterPlayerController,
                      ),
                    ),
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
