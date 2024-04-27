import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/features/feeds/data/store/feed_cubit.dart';
import 'package:sparkduet/features/files/data/store/enums.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';
import 'package:uuid/uuid.dart';

class PostFeedFormPage extends StatefulWidget {

  final File file;
  final MediaType mediaType;
  const PostFeedFormPage({super.key, required this.file, required this.mediaType});

  @override
  State<PostFeedFormPage> createState() => _PostFeedFormPageState();

}

class _PostFeedFormPageState extends State<PostFeedFormPage> {

  late FeedCubit feedCubit;
  late String postId;

  @override
  void initState() {
    const uuid = Uuid();
    postId = uuid.v1();
    feedCubit = context.read<FeedCubit>();
    feedCubit.postFilePart(id: postId, file: widget.file, mediaType: widget.mediaType);
    super.initState();
  }

  final descriptionTextEditingController= TextEditingController();
  ValueNotifier<bool> enableComments = ValueNotifier(true);
  ValueNotifier<bool> volumeOn = ValueNotifier(true);
  BetterPlayerController? videoController;

  void postFeedHandler(BuildContext ctx) {
    // the api is ready so connect the post to it
    feedCubit.postPayloadPart(id: postId);
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {
            if(videoController?.isPlaying() ?? true) {
              videoController?.pause();
              volumeOn.value = false;
            }else {
              videoController?.play();
              volumeOn.value = true;
            }

          }, icon: ValueListenableBuilder<bool>(valueListenable: volumeOn, builder: (_, val, __) {
            return  Icon(val ? FeatherIcons.volume2 : FeatherIcons.volumeX);
          }))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [

          CustomVideoPlayer(
            file: widget.file,
            autoPlay: true,
            loop: true,
            aspectRatio: mediaQuery.size.width / mediaQuery.size.height,
            hls: false,
            mute: true,
            fit: BoxFit.cover,
            videoSource: VideoSource.file,
            builder: (controller) {
              videoController = controller;
            },
          ),

          DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.9,
              minChildSize: 0.2,
              shouldCloseOnMinExtent: false,
              builder: (_ , controller) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: ColoredBox(
                    color: theme.colorScheme.background,
                      child: SingleChildScrollView(
                        controller: controller,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Post settings", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              CustomCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    ValueListenableBuilder<bool>(valueListenable: enableComments, builder: (_, val, __) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text("Comments state", style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.bold),),
                                               Text(val ? "Comments are currently enabled" : "Comments disabled", style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),),
                                             ],
                                          ),
                                          SizedBox(
                                            width: 40,
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: CupertinoSwitch(
                                                value: val,
                                                onChanged: (bool value) {
                                                  enableComments.value = value;
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }),

                                    const SizedBox(height: 30,),

                                    CustomTextFieldWidget(
                                      controller: descriptionTextEditingController,
                                      label: "Write something about the post (optional)",
                                      labelFontWeight: FontWeight.bold,
                                      maxLines: null,
                                      minLines: 4,
                                      placeHolder: "eg. I'm the sweetest person ever",
                                    ),
                                    const SizedBox(height: 10,),
                                    CustomButtonWidget(text: "Submit post", onPressed: () => postFeedHandler(context),)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  )
                );
              }
          )

        ],
      ),
    );
  }
}
