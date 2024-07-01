import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_image_player.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';

class UncompletedUserPostItem extends StatelessWidget {

  final FeedModel post;
  final Function()? onTap;
  const UncompletedUserPostItem({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: IgnorePointer(
          ignoring: true,
          child: Stack(
            children: [

              if(post.mediaType == FileType.video) ... {
                CustomVideoPlayer(
                  file: File(post.mediaPath ?? ""),
                  autoPlay: false,
                  loop: false,
                  fit: BoxFit.cover,
                  useCache: false,
                  videoSource: VideoSource.file,
                  builder: (controller)  {
                    final double videoLength = (controller.videoPlayerController?.value.duration?.inSeconds ?? 0).toDouble();
                    controller.seekTo(Duration(seconds: videoLength ~/ 2));
                  },
                )
              },

              if(post.mediaType == FileType.image) ... {

                CustomImagePlayerWidget(
                  imageUrl: post.mediaPath ?? "",
                  audioUrl: AppConstants.defaultAudioLink,
                  autoPlay: false,
                  loop: false,
                  imageSource: ImageSource.file,
                  fit: BoxFit.cover,
                  animate: false,
                  audioSource: AudioSource.network,
                )
              },

              if(post.status == "loading") ... {
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Processing...", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.darkColorScheme.onBackground,fontSize: 12),),
                  ),
                ),
                // ColoredBox(color: AppColors.darkColorScheme.background.withOpacity(0.3),
                //   child: const Center(
                //     child: CustomAdaptiveCircularIndicator(),
                //   ),
                // )
              },

              if(post.status == "failed") ... {
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Retry...", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.darkColorScheme.onBackground,fontSize: 12),),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final authUser = context.read<AuthCubit>().state.authUser;
                    //! Retry post
                    context.read<FeedsCubit>().postFeed(
                        tempPostId: post.tempId,
                        file: File(post.mediaPath ?? ""),
                        mediaType: post.mediaType ?? FileType.video,
                        purpose: post.purpose,
                        description: post.description,
                        commentsDisabled: post.commentsDisabledAt != null,
                        flipFile: post.flipFile ?? false,
                        user: authUser
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: ColoredBox(color: AppColors.darkColorScheme.background.withOpacity(0.3),
                    child: Center(
                      child: Icon(Icons.refresh, color: AppColors.darkColorScheme.onBackground, size: 20,),
                    ),
                  ),
                )
              }

            ],
          ),
        ),
      ),
    );
  }
}
