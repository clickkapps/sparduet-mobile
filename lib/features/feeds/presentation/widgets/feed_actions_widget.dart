import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/complains/presentation/pages/report_feed_page.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/feeds_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/filter_feeds_widget.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/utils/custom_heart_animation_widget.dart';

class FeedActionsWidget extends StatelessWidget {

  final FeedModel feed;
  const FeedActionsWidget({super.key, required this.feed});


  void filterPostsHandler(BuildContext context) {
    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.7,
          shouldCloseOnMinExtent: true,
          builder: (_ , controller) {
            return ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: FilterFeedsWidget(scrollController: controller,)
            );
          }
      ),
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  void reportPostHandler(BuildContext context) {
    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.7,
          builder: (_ , controller) {
            return ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: ReportFeedPage(controller: controller, feed: feed,)
            );
          }
      ),
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false).then((value) => context.read<ThemeCubit>().setSystemUIOverlaysToDark());
  }


  @override
  Widget build(BuildContext context) {

    final authUser = context.read<AuthCubit>().state.authUser;
    final isCreator = authUser?.id == feed.user?.id;
    // const isCreator = false;

    return SeparatedColumn(
      mainAxisSize: MainAxisSize.min,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20,);
      },
      children: [


        GestureDetector(
          onTap: () {
            filterPostsHandler(context);
          },
          behavior: HitTestBehavior.opaque,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomHeartAnimationWidget(
                  isAnimating: false,
                  alwayAnimate: true,
                  child: Icon(FeatherIcons.sliders, size: 25, color: Colors.white,)
              ),
              SizedBox(width: 5,),
              Text("Filter posts", style: TextStyle(color: Colors.white, fontSize:11),),
            ],
          ),
        ),

        if(!isCreator) ... {
          Builder(builder: (_) {
            final hasBookmarked = feed.hasBookmarked ?? false;
            return GestureDetector(
              onTap: () {
                context.read<FeedsCubit>().togglePostBookmarkAction(feed: feed);
              },
              behavior: HitTestBehavior.opaque,
              child:  SeparatedColumn(
                mainAxisSize: MainAxisSize.min,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 5,);
                },
                children: [
                  CustomHeartAnimationWidget(
                      isAnimating: hasBookmarked,
                      alwayAnimate: true,
                      child: Icon(Icons.bookmark, size: 30, color: (feed.hasBookmarked ?? false) ? Colors.amber : Colors.white,)
                  ),
                  if((feed.totalBookmarks ?? 0) > 0) ... {
                    Text("${feed.totalBookmarks ?? 0}", style: const TextStyle(color: Colors.white, fontSize:11),),
                  }
                ],
              ),
            );
          },)
        },

        if(!isCreator) ... {
          GestureDetector(
            onTap: () => reportPostHandler(context),
            behavior: HitTestBehavior.opaque,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomHeartAnimationWidget(
                    isAnimating: false,
                    alwayAnimate: true,
                    child: Icon(Icons.health_and_safety, size: 30, color: Colors.white,)
                ),
                SizedBox(width: 5,),
                Text("Report post", style: TextStyle(color: Colors.white, fontSize:11),),
              ],
            ),
          ),
        },

        ///! Comments will be introduced if heavily requested
        /// Disabled to promote the chat feature instead
        // GestureDetector(
        //   onTap: () {
        //     context.showSnackBar("coming soon");
        //   },
        //   behavior: HitTestBehavior.opaque,
        //   child:  Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       const CustomHeartAnimationWidget(
        //           isAnimating: false,
        //           alwayAnimate: true,
        //           child: Icon(Icons.message, size: 27, color: Colors.white,)
        //       ),
        //       const SizedBox(width: 5,),
        //       if((feed.totalComments ?? 0) > 0) ... {
        //         Text("${feed.totalComments ?? 0}", style: const TextStyle(color: Colors.white, fontSize:11),),
        //       }
        //     ],
        //   ),
        // ),

        if(!isCreator) ... {
          GestureDetector(
            onTap: () {
              context.showSnackBar("coming soon");
            },
            behavior: HitTestBehavior.opaque,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomHeartAnimationWidget(
                    isAnimating: false,
                    alwayAnimate: true,
                    child: Icon(FontAwesomeIcons.solidComments, size: 27, color: AppColors.buttonBlue,)
                ),
                SizedBox(width: 5,),
                Text("Chat", style: TextStyle(color: AppColors.buttonBlue, fontSize:11),),
              ],
            ),
          ),
        },

        /// Like
        GestureDetector(
          onTap: () {
            context.read<FeedsCubit>().togglePostLikeAction(feed: feed, action: (feed.hasLiked ?? 0) > 0 ? "remove" : "add");
          },
          behavior: HitTestBehavior.opaque,
          child: SeparatedColumn(
            mainAxisSize: MainAxisSize.min,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 5,);
            },
            children: [
              CustomHeartAnimationWidget(
                  isAnimating: feed.hasLiked == 1,// only animate for the first like
                  alwayAnimate: true,
                  child: (feed.hasLiked ?? 0) > 0 ? const Icon(Icons.favorite, size: 32, color: Colors.red,) : const Icon(Icons.favorite, size: 32, color: Colors.white,)
              ),
              if((feed.totalLikes ?? 0) > 0) ... {
                Text("${feed.totalLikes}", style: TextStyle(color:  (feed.hasLiked ?? 0) > 0 ? Colors.red : Colors.white, fontSize: 12),),
              }
            ],
          ),
        ),
      ],
    );
  }

}

