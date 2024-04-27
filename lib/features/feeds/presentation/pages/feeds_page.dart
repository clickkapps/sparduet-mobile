import 'package:better_player/better_player.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/feed_cubit.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/presentation/pages/editor/feed_editor_camera_page.dart';
import 'package:sparkduet/features/feeds/presentation/pages/introduction_page.dart';
import 'package:sparkduet/features/feeds/presentation/pages/post_feed_form_page.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/feed_item_widget.dart';
import 'package:sparkduet/features/files/data/store/enums.dart';
import 'package:sparkduet/features/files/mixin/file_manager_mixin.dart';
import 'package:sparkduet/features/theme/data/store/enums.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({super.key});

  @override
  State<FeedsPage> createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> with FileManagerMixin {

  late FeedCubit feedCubit;
  late ThemeCubit _themeCubit;
  int activeFeedIndex = 0;
  final Map<int, BetterPlayerController?> videoControllers = {};
  
  @override
  void initState() {
    _themeCubit = context.read<ThemeCubit>();
    feedCubit = context.read<FeedCubit>();
    onWidgetBindingComplete(onComplete: () {
      _setLight();
    });
    super.initState();
  }

  _setLight() {
    _themeCubit.setLightMode();
    _themeCubit.setSystemUIOverlaysToLight();
  }

  void feedCubitListener(BuildContext ctx, FeedState event) {

  }

  void pickPostFile(BuildContext context) async {

    videoControllers[activeFeedIndex]?.pause();
    final error = await openFeedCamera(context);
    if(error != null && context.mounted) {
      context.showSnackBar(error, appearance: NotificationAppearance.info);
    }
    // pickVideoFile(context, onSuccess: (file) {
    //   // send file for editing
    //   editVideoFile(context, videoFile: file, onSuccess: (file) {
    //     // post file
    //     // simultaneously send user to a screen to fill up post settings (comments on or off, post description)
    //     context.pushScreen(PostFeedFormPage(file: file, mediaType: MediaType.video,));
    //
    //   }, onError: (error) {
    //     // context.showSnackBar(error, appearance: NotificationAppearance.error);
    //     _setLight();
    //   });
    //
    // }, onError: (error) {
    //   // context.showSnackBar(error, appearance: NotificationAppearance.error);
    //   _setLight();
    // }, shouldAutoPreview: false);
  }

  // upload new feed
  void initiatePost(BuildContext context) {
    videoControllers[activeFeedIndex]?.pause();
    // final theme = Theme.of(context);
    // check if this is user's first feed. Then show introductory video page
    // context.pushScreen(const IntroductionPage());
    // Else show the list of options user can talk about
    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.35,
          maxChildSize: 0.35,
          minChildSize: 0.35,
          builder: (_ , controller) {
            return  ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: IntroductionPage(onAccept: () {
                context.popScreen();
                pickPostFile(context);
              },),
            );
          }
      ),
    );

    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), backgroundColor: Colors.transparent, enableBottomPadding: false).then((value) => videoControllers[activeFeedIndex]?.play());

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        initiatePost(context);
      }, backgroundColor: theme.colorScheme.primary, child: Icon(Icons.add, color: theme.colorScheme.onPrimary,),),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("❤️ Sparks ❤️", style: TextStyle(color: Colors.white,
            // fontSize: 16
        ),),
        actions:  [
          // IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.sliders, color: Colors.white,)),
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.search, color: Colors.white,)),
          const SizedBox(width: 18,)
        ],
      ),
      extendBodyBehindAppBar: true,
      body: BlocListener<FeedCubit, FeedState>(
        listener: feedCubitListener,
        child: Column(
              children: [
                Expanded(child:
                    PreloadPageView.builder(
                        itemCount: 3,
                        itemBuilder: (_, i) {

                          String videoUrl = "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/poqdyuhljyrrdpfhsgkg.mp4";
                          if(i == 1) {
                            videoUrl = "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/lz1yljhou0hyuagg7ocf.mp4";
                          }
                          if(i == 2) {
                            videoUrl = "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/rnhmececivadz5jjkzlf.mp4";
                          }
                          return FeedItemWidget(videoBuilder: (controller) {
                            videoControllers[i] = controller;
                          }, videoUrl: videoUrl, autoPlay:  i == activeFeedIndex, onItemTapped: () {
                            if(videoControllers[i] == null){
                              return;
                            }
                            if(videoControllers[i]?.isPlaying() ?? false) {
                              videoControllers[i]?.pause();
                            }else {
                              videoControllers[i]?.play();
                            }
                          },);
                        },
                        onPageChanged: (int position) {
                          activeFeedIndex = position;
                          videoControllers[activeFeedIndex]?.play();
                        },
                        preloadPagesCount: 3,
                        scrollDirection: Axis.vertical,
                        controller: PreloadPageController(),
                  )
                ),

                /// Loading
                // LinearProgressIndicator(color: theme.colorScheme.primary, minHeight: 2,)
              ],
            ),
      ),
    );
  }
}
