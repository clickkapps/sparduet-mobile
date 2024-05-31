import 'dart:io';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:better_player/better_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_actions_widget.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_image_player.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class FeedItemWidget extends StatefulWidget {

  final Function(BetterPlayerController)? videoBuilder;
  final Function(AssetsAudioPlayer)? imageBuilder;
  final FeedModel feed;
  final Function()? onItemTapped;
  final bool autoPlay;
  final bool hls;
  final bool useCache;
  const FeedItemWidget({super.key,
    this.videoBuilder, this.onItemTapped,
    required this.feed, this.autoPlay = false,
    this.hls = false,
    this.useCache = true,
    this.imageBuilder
  });

  @override
  State<FeedItemWidget> createState() => _FeedItemWidgetState();
}

class _FeedItemWidgetState extends State<FeedItemWidget> {

  String? audioPath;

  @override
  void initState() {
    if(widget.feed.mediaType == FileType.image) {
      // randomly select one track for the image for this mvp
      audioPath = getRandomString(AppConstants.audioLinks);
    }
    super.initState();
  }


  String getRandomString(List<String> strings) {
    final random = Random();
    final randomIndex = random.nextInt(strings.length);
    return strings[randomIndex];
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    return  Stack(
      children: [

        /// Video
        if(widget.feed.mediaType == FileType.video) ... {
          Builder(
              builder: (_) {
                return GestureDetector(
                  onTap: () => widget.onItemTapped?.call() ,
                  behavior: HitTestBehavior.opaque,
                  child: IgnorePointer(
                    child: CustomVideoPlayer(
                      autoPlay: widget.autoPlay,
                      loop: true,
                      showDefaultControls: false,
                      // aspectRatio: mediaQuery.size.width / mediaQuery.size.height,
                      hls: widget.hls,
                      fit: BoxFit.cover,
                      useCache: widget.useCache,
                      builder: widget.videoBuilder,
                      // The understanding here is, if tempId is not null, then the media source is file
                      networkUrl: widget.feed.tempId != null ? null : AppConstants.videoMediaPath(playbackId: widget.feed.mediaPath ?? ""),
                      file: widget.feed.tempId != null ? File(widget.feed.mediaPath ?? "") : null,
                      videoSource: widget.feed.tempId != null ? VideoSource.file : VideoSource.network, // the post will
                    ),
                  ),
                );
              }
          )
        },

        if(widget.feed.mediaType == FileType.image) ... {
          Builder(builder: (_) {
            return GestureDetector(
              onTap: () => widget.onItemTapped?.call(),
              child: SizedBox(
                width: mediaQuery.size.width,
                height: mediaQuery.size.height,
                child: CustomImagePlayerWidget(
                  imageUrl: AppConstants.imageMediaPath(mediaId: widget.feed.mediaPath ?? ""),
                  audioUrl: audioPath ?? '',
                  imageSource: ImageSource.network,
                  builder: widget.imageBuilder,
                  audioSource: AudioSource.network,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },)
        },

        /// Image

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, top: 50),
            child: FeedActionsWidget(feed: widget.feed,),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(constraints: BoxConstraints(maxWidth: mediaQuery.size.width* 0.8),
                child:  Padding(padding: const EdgeInsets.only(left: 15, bottom: 10),
                  child: SeparatedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 5,);
                    },
                    children: [
                      /// Person name,
                      GestureDetector(
                        onTap: () => context.pushToProfile(widget.feed.user),
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            CustomUserAvatarWidget(imageUrl: widget.feed.user?.info?.profilePicPath,),
                            const SizedBox(width: 10,),
                            Flexible(child: Text(widget.feed.user?.name ?? "", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),)),
                            const SizedBox(width: 10,),
                            Text("${widget.feed.user?.info?.age ?? ''}", style: const TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),

                      /// description
                      if((widget.feed.description ?? "").isNotEmpty) ... {
                        ReadMoreText(
                          widget.feed.description ?? "",
                          trimMode: TrimMode.Line,
                          trimLines: 2,
                          colorClickableText: Colors.blue,
                          trimCollapsedText: ' Show more',
                          trimExpandedText: ' Show less',
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                          moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                          lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                        )
                      },

                      if((widget.feed.id ?? 0) > 1) ... {
                        CustomButtonWidget(text: "Show interest", onPressed: () {
                          // send user clicks predefine and initial message for user.
                          // eg. Hey!. I'm interested in you. Can I get to know you
                        }, padding: const EdgeInsets.only(left: 10, right: 15, top: 7, bottom: 7),
                          appearance: ButtonAppearance.secondary,
                        )
                      }
                    ],
                  ),
                ),
              ),
              // Container(
              //   width: double.maxFinite,
              //   decoration: BoxDecoration(
              //     color: Colors.black.withOpacity(0.4)
              //   ),
              //   child: const Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              //     child: Text("Video topic displayed here", style: TextStyle(color: Colors.white, fontSize: 12),),
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }
}
