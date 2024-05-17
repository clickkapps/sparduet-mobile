import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/utils/custom_chip_widget.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';

class CompletedUserPostItem extends StatelessWidget {

  final FeedModel post;
  final Function()? onTap;
  const CompletedUserPostItem({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    final networkPath = AppConstants.videoMediaPath(mediaId: post.mediaPath);
    // debugPrint("CustomLog mediaPath: $networkPath");
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            CustomVideoPlayer(
              networkUrl: networkPath,
              autoPlay: false,
              loop: false,
              fit: BoxFit.cover,
              videoSource: VideoSource.network,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(post.description ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.darkColorScheme.onBackground,fontSize: 12),),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child:  Padding(padding: const EdgeInsets.all(5),
                child: DecoratedBox(decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50)
                ), child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text('2k views', style: TextStyle(color: Colors.white, fontSize: 12),),
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
