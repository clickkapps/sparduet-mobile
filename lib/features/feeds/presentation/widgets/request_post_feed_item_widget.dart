import 'package:audioplayers/audioplayers.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_purpose.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/feed_editor_camera_page.dart';
import 'package:sparkduet/network/api_config.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';

class RequestPostFeedItem extends StatefulWidget {

  final int feedId;
  final Function(BetterPlayerController?, AudioPlayer?)? builder;
  final Function()? onTap;
  final Function()? onFeedEditorOpened;
  final Function()? onFeedEditorClosed;
  const RequestPostFeedItem({super.key, required this.feedId, this.builder, this.onTap, this.onFeedEditorOpened, this.onFeedEditorClosed});

  @override
  State<RequestPostFeedItem> createState() => _RequestPostFeedItemState();
}

class _RequestPostFeedItemState extends State<RequestPostFeedItem> {

  final audioPlayer =  AudioPlayer();

  PostFeedPurpose get getRequestPostParameters {
    String? title, subTitle, key, description;
    if (widget.feedId == -2) {
      title = "Hi✋! What are you looking for in your next relationship?";
      subTitle =
      "A quick 30-second video sharing your expectations would be helpful for potential matches";
      key = "expectations";
      description = "What I'm looking for in my next relationship";
    }
    // else if(feedId == -3) {
    //
    // }
    // else if(feedId == -4) {
    //
    // }
    // else if(feedId == -5) {
    //
    // }
    else {
      // -1
      title = "Hi✋, Let's get started";
      subTitle =
      "Introduce yourself to potential suitors. A good 30 sec video will attract the best suitors";
      key = "introduction";
      description = "Hey✋, let's connect and learn more about each other.";
    }
    return PostFeedPurpose(
        title: title,
        subTitle: subTitle,
        key: key,
        description: description
    );

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.builder?.call(null, null);
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final params = getRequestPostParameters;

    // final url = AppConstants.cloudinary?.video('ttm9dhe1x7yr7dvfh2xn')?..transformation(
    //     Transformation()
    //       ..effect(Effect.fadeIn(2000))
    //       ..effect(Effect.fadeOut(4000))
    // );

    return Stack(
      children: [
        GestureDetector(
          onTap: () {widget.onTap?.call();},
          behavior: HitTestBehavior.opaque,
          child: CustomVideoPlayer(
            videoSource: VideoSource.network,
            networkUrl: ApiConfig.videoMediaPath(mediaId: AppConstants.requestPostFeedVideoMediaId),
            builder: (controller) => widget.builder?.call(controller, audioPlayer),
            autoPlay: false,
            backgroundColor: AppColors.darkColorScheme.background,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: CustomCard(
              child: SeparatedColumn(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 10,);
                },
                children: [

                  Text(params.title ?? "", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w300, fontSize: 18),),

                  Text(params.subTitle ?? "", style: theme.textTheme.titleSmall,),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CustomButtonWidget(text: "Create post", onPressed: () async {
                      widget.onFeedEditorOpened?.call();
                      await openFeedCamera(context, purpose: params);
                      widget.onFeedEditorClosed?.call();
                    }, expand: true,),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
