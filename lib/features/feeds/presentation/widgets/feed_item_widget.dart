import 'dart:io';
import 'dart:math';
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:better_player/better_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_actions_widget.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_heart_animation_widget.dart';
import 'package:sparkduet/utils/custom_image_player.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class FeedItemWidget extends StatefulWidget {

  final Function(BetterPlayerController)? videoBuilder;
  final Function(void)? imageBuilder;
  final FeedModel feed;
  final Function()? onItemTapped;
  final bool autoPlay;
  final bool hls;
  final bool useCache;
  final Function(double)? onProgress;
  const FeedItemWidget({super.key,
    this.videoBuilder, this.onItemTapped,
    required this.feed, this.autoPlay = false,
    this.hls = false,
    this.useCache = false,
    this.imageBuilder,
    this.onProgress,
  });

  @override
  State<FeedItemWidget> createState() => _FeedItemWidgetState();
}

class _FeedItemWidgetState extends State<FeedItemWidget>{

  String? audioPath;
  final ValueNotifier<bool> isHeartAnimating = ValueNotifier(false);

  @override
  void initState() {
    if(widget.feed.mediaType == FileType.image) {
      // randomly select one track for the image for this mvp
      audioPath = getRandomString(AppConstants.audioLinks);
    }
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }




  String getRandomString(List<String> strings) {
    final random = Random();
    final randomIndex = random.nextInt(strings.length);
    return strings[randomIndex];
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final authenticatedUser = context.read<AuthCubit>().state.authUser;

    return  GestureDetector(
      onDoubleTap: () {


        if((widget.feed.hasLiked ?? 0) > 0) {
          // has liked
          if((widget.feed.hasLiked ?? 0) == 2){
            // you can only like 2 times
            // context.read<FeedsCubit>().togglePostLikeAction(feed: widget.feed, action: "remove");
            return;
          }
          context.read<FeedsCubit>().togglePostLikeAction(feed: widget.feed, action: "add");
          isHeartAnimating.value = true;

        }else {
          // has not liked
          context.read<FeedsCubit>().togglePostLikeAction(feed: widget.feed, action: "add");
          isHeartAnimating.value = true;
        }


      },
      child: Stack(
        children: [


          /// Video
          if(widget.feed.mediaType == FileType.video) ... {
            Builder(
                builder: (_) {
                  final networkUrl = widget.feed.tempId != null ? null : AppConstants.videoMediaPath(playbackId: widget.feed.mediaPath ?? "");
                  // return GestureDetector(
                  //   onTap: () => widget.onItemTapped?.call() ,
                  //   behavior: HitTestBehavior.opaque,
                  //   child: IgnorePointer(
                  //     child: CustomVideoPlayer(
                  //       autoPlay: widget.autoPlay,
                  //       loop: true,
                  //       showDefaultControls: false,
                  //       // aspectRatio: mediaQuery.size.width / mediaQuery.size.height,
                  //       hls: widget.hls,
                  //       fit: BoxFit.cover,
                  //       useCache: widget.useCache,
                  //       builder: widget.videoBuilder,
                  //       // The understanding here is, if tempId is not null, then the media source is file
                  //       networkUrl: networkUrl,
                  //       file: widget.feed.tempId != null ? File(widget.feed.mediaPath ?? "") : null,
                  //       videoSource: widget.feed.tempId != null ? VideoSource.file : VideoSource.network, // the post will
                  //       onProgress: widget.onProgress,
                  //     ),
                  //   ),
                  // );
                  if(kDebugMode) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text("Video is turned off in debug mode", style: TextStyle(color: Colors.white),),
                      ),
                    );
                  }else {
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
                          networkUrl: networkUrl,
                          file: widget.feed.tempId != null ? File(widget.feed.mediaPath ?? "") : null,
                          videoSource: widget.feed.tempId != null ? VideoSource.file : VideoSource.network, // the post will
                          onProgress: widget.onProgress,
                        ),
                      ),
                    );
                  }

                }
            )
          },

          /// Image
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

          IgnorePointer(
            ignoring: true,
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: AppColors.black.withOpacity(0.3),
            ),
          ),


          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, top: 50, bottom: 20),
              child: FeedActionsWidget(feed: widget.feed, onActionTapped: (value) {
                if(value == "liked") {
                  isHeartAnimating.value = true;
                }
              },),
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
                              CustomUserAvatarWidget(imageUrl: AppConstants.imageMediaPath(mediaId: widget.feed.user?.info?.profilePicPath ?? ""),),
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

                        if((widget.feed.id ?? 0) > 0 && widget.feed.user?.id != authenticatedUser?.id) ... {
                          CustomButtonWidget(text: "Show interest", onPressed: () {
                            context.push(AppRoutes.chatPreview, extra: widget.feed.user );
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
          ),

          Align(
            alignment: Alignment.center,
            child: ValueListenableBuilder<bool>(valueListenable: isHeartAnimating, builder: (_, value, __) {
              return Opacity(
                opacity: value ? 1 : 0,
                child: CustomHeartAnimationWidget(
                  isAnimating: value,
                  duration: const Duration(milliseconds: 700),
                  onEnd: () {
                    isHeartAnimating.value = false;
                  },
                  child: SeparatedRow(
                    mainAxisSize: MainAxisSize.min,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 0,);
                    },
                    children: List.generate((widget.feed.hasLiked ?? 0).toInt(), (index) => const Icon(Icons.favorite, color: Colors.red, size: 50,)),
                  ),
                ),
              );
            }),
          ),

        ],
      ),
    );
  }
}
