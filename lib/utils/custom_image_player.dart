import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sparkduet/core/app_audio_service.dart';
import 'package:sparkduet/utils/custom_network_image_widget.dart';

enum ImageSource { file, network, asset }
enum AudioSource { file, network }
class CustomImagePlayerWidget extends StatefulWidget {

  final String imageUrl;
  final String audioUrl;
  final ImageSource imageSource;
  final AudioSource audioSource;
  final BoxFit? fit;
  final bool loop;
  final bool animate;
  final Function(AssetsAudioPlayer)? builder;
  final bool autoPlay;
  const CustomImagePlayerWidget({super.key, required this.imageUrl, this.builder,
    required this.audioUrl,
    this.fit,
    this.loop = true,
    required this.audioSource,
    this.animate = true,
    this.autoPlay = false,
    required this.imageSource
  });

  @override
  State<CustomImagePlayerWidget> createState() => _CustomImagePlayerWidgetState();
}

class _CustomImagePlayerWidgetState extends State<CustomImagePlayerWidget> with SingleTickerProviderStateMixin  {

  final assetsAudioPlayer = AssetsAudioPlayer();


  @override
  void initState() {
    initializeAudio();
    super.initState();
  }

  @override
  void dispose() {

    assetsAudioPlayer.dispose();
    super.dispose();
  }

  void initializeAudio() async {


    try {

      if(widget.audioSource == AudioSource.file) {
        await assetsAudioPlayer.open(
            Audio.file(widget.audioUrl),
            autoStart: false,
            loopMode: widget.loop ? LoopMode.single : LoopMode.none
        );
      }
      else if (widget.audioSource == AudioSource.network) {

        // See if you can get the cached version
        final file = await AppAudioService.getAudioLocalFile(widget.audioUrl);
         if(file != null) {
           await assetsAudioPlayer.open(
               Audio.file(widget.audioUrl),
               autoStart: false,
               loopMode: widget.loop ? LoopMode.single : LoopMode.none
           );
         }else {
           await assetsAudioPlayer.open(
               Audio.network(widget.audioUrl),
               autoStart: false,
               loopMode: widget.loop ? LoopMode.single : LoopMode.none
           );
         }

      }

      widget.builder?.call(assetsAudioPlayer);
      if(widget.autoPlay) {
        assetsAudioPlayer.play();
      }

    } catch (t) {
      //stream unreachable
    }
  }

  Widget buildImageWithAnimation({required Widget child}) {
    return child;
    // return AnimatedBuilder(
    //   animation: animation,
    //   builder: (context, child) {
    //     return Transform.scale(
    //       scale: animation.value,
    //       child: child,
    //     );
    //   },
    // );
  }


  @override
  Widget build(BuildContext context) {
    final fit = widget.fit ?? BoxFit.cover;

    if(widget.imageSource == ImageSource.network){
      return SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: buildImageWithAnimation(child: CustomNetworkImageWidget(imageUrl: widget.imageUrl, fit: fit)),
      );
    }

    if(widget.imageSource == ImageSource.file){
      return SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: buildImageWithAnimation(child: Image.file(File(widget.imageUrl), fit: fit,))
      );
    }

    if(widget.imageSource == ImageSource.file){
      return SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: buildImageWithAnimation(child: Image.asset(widget.imageUrl, fit: fit,)),
      );
    }

    return const SizedBox.shrink();
  }
}
