import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';

class CompletedUserPostItem extends StatelessWidget {

  final FeedModel post;
  const CompletedUserPostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          CustomVideoPlayer(
            networkUrl: post.mediaPath,
            autoPlay: false,
            loop: false,
            fit: BoxFit.cover,
            videoSource: VideoSource.network,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Gist about my preview relationship", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.darkColorScheme.onBackground,fontSize: 12),),
            ),
          )
        ],
      ),
    );
  }
}
