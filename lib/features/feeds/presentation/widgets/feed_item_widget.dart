import 'package:better_player/better_player.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_actions_widget.dart';
import 'package:sparkduet/utils/custom_heart_animation_widget.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class FeedItemWidget extends StatelessWidget {

  final Function(BetterPlayerController)? videoBuilder;
  final String? videoUrl;
  final bool autoPlay;
  final Function()? onItemTapped;
  const FeedItemWidget({super.key, this.videoBuilder, this.videoUrl, this.autoPlay = false, this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return  Stack(
      children: [
        GestureDetector(
          onTap: () => onItemTapped?.call() ,
          behavior: HitTestBehavior.opaque,
          child: IgnorePointer(
            child: CustomVideoPlayer(
              networkUrl: videoUrl ?? "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/ttm9dhe1x7yr7dvfh2xn.mp4",
              autoPlay: autoPlay,
              loop: autoPlay,
              showDefaultControls: false,
              // aspectRatio: mediaQuery.size.width / mediaQuery.size.height,
              hls: false,
              fit: BoxFit.cover,
              videoSource: VideoSource.network,
              builder: videoBuilder,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(right: 10, bottom: mediaQuery.size.height * 0.15),
            child: const FeedActionsWidget(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(constraints: BoxConstraints(maxWidth: mediaQuery.size.width* 0.8),
                child: const Padding(padding: EdgeInsets.only(left: 15, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Person name,
                      Row(
                        children: [
                          CustomUserAvatarWidget(),
                          SizedBox(width: 10,),
                          Flexible(child: Text("Grace Adobea", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),)),
                          SizedBox(width: 10,),
                          Text("26", style: TextStyle(color: Colors.white),)
                        ],
                      ),
                      SizedBox(height: 5,),
                      /// description
                      Text("This is a description for the story. I don't really like men who smoke", style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4)
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Text("Video topic displayed here", style: TextStyle(color: Colors.white, fontSize: 12),),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
