import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_actions_widget.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class StoryFeedItemWidget extends StatelessWidget {

  final Function(BetterPlayerController)? videoBuilder;
  final FeedModel feed;
  final Function()? onItemTapped;
  final bool autoPlay;
  final bool hls;
  final bool useCache;
  const StoryFeedItemWidget({super.key, this.videoBuilder, this.onItemTapped, required this.feed, this.autoPlay = false, this.hls = false, this.useCache = true});

  @override
  Widget build(BuildContext context) {

    final authUser = context.read<AuthCubit>().state.authUser;
    final isCreator = authUser?.id == feed.user?.id;
    final mediaQuery = MediaQuery.of(context);
    return  Stack(
      children: [

        /// Video
        Builder(
          builder: (_) {
            return GestureDetector(
              onTap: () => onItemTapped?.call() ,
              behavior: HitTestBehavior.opaque,
              child: IgnorePointer(
                child: CustomVideoPlayer(
                  autoPlay: autoPlay,
                  loop: true,
                  showDefaultControls: false,
                  // aspectRatio: mediaQuery.size.width / mediaQuery.size.height,
                  hls: hls,
                  fit: BoxFit.cover,
                  useCache: useCache,
                  builder: videoBuilder,
                  // The understanding here is, if tempId is not null, then the media source is file
                  networkUrl: feed.tempId != null ? null : AppConstants.videoMediaPath(playbackId: feed.mediaPath ?? ""),
                  file: feed.tempId != null ? File(feed.mediaPath ?? "") : null,
                  videoSource: feed.tempId != null ? VideoSource.file : VideoSource.network, // the post will
                ),
              ),
            );
          }
        ),

        /// Image

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, top: 50),
            child: FeedActionsWidget(feed: feed,),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Person name,
                      Row(
                        children: [
                          CustomUserAvatarWidget(imageUrl: feed.user?.info?.profilePicPath,),
                          const SizedBox(width: 10,),
                          Flexible(child: Text(feed.user?.name ?? "", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),)),
                          const SizedBox(width: 10,),
                          Text("${feed.user?.info?.age ?? ''}", style: const TextStyle(color: Colors.white),)
                        ],
                      ),
                      const SizedBox(height: 5,),
                      /// description
                      Text(feed.description ?? "", style: const TextStyle(color: Colors.white, fontSize: 20))
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
