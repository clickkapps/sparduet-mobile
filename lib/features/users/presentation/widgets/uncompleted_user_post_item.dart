import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';

class UncompletedUserPostItem extends StatelessWidget {

  final FeedModel post;
  const UncompletedUserPostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          CustomVideoPlayer(
            file: File(post.mediaPath ?? ""),
            autoPlay: false,
            loop: false,
            fit: BoxFit.cover,
            videoSource: VideoSource.file,
          ),

          if(post.status == "loading") ... {
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Posting...", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.darkColorScheme.onBackground,fontSize: 12),),
              ),
            ),
            ColoredBox(color: AppColors.darkColorScheme.background.withOpacity(0.3),
              child: const Center(
                child: CustomAdaptiveCircularIndicator(),
              ),
            )
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

                //! Retry post
                context.read<FeedsCubit>().postFeed(
                    tempPostId: post.tempId,
                    file: File(post.mediaPath ?? ""),
                    mediaType: post.mediaType ?? FileType.video,
                    purpose: post.purpose,
                    description: post.description,
                    commentsDisabled: post.commentsDisabledAt != null,
                    flipFile: post.flipFile ?? false
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
    );
  }
}
