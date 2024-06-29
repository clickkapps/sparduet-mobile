import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/censored_feed_checker_widget.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/subscriptions/presentation/ui_mixin/subsription_page_mixin.dart';
import 'package:sparkduet/features/users/presentation/pages/post_liked_users_page.dart';
import 'package:sparkduet/utils/custom_network_image_widget.dart';

class CompletedUserPostItem extends StatelessWidget with SubscriptionPageMixin {

  final FeedModel post;
  final Function()? onTap;
  final Function()? onLongPress;
  const CompletedUserPostItem({super.key, required this.post, this.onTap, this.onLongPress});

  void likedPostUsersHandler(BuildContext context) {

    if(!context.read<SubscriptionCubit>().state.subscribed) {
      showSubscriptionPaywall(context, openAsModal: true);
      return;
    }

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
                child: PostLikedUsersPage(controller: controller, postId: post.id,)
            );
          }
      ),
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  @override
  Widget build(BuildContext context) {

    final authenticatedUser = context.read<AuthCubit>().state.authUser;
    // debugPrint("CustomLog mediaPath: $networkPath");
    final thumbnailPath = AppConstants.thumbnailMediaPath(mediaId: post.mediaPath ?? "");
    return CensoredFeedCheckerWidget(feed: post, child: GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child:post.mediaType == FileType.video ? CustomNetworkImageWidget(imageUrl: thumbnailPath, fit: BoxFit.cover,)
                  : CustomNetworkImageWidget(imageUrl: AppConstants.imageMediaPath(mediaId: post.mediaPath ?? ""), fit: BoxFit.cover,),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(post.description ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.darkColorScheme.onBackground,fontSize: 12),),
              ),
            ),
            if(post.user?.id == authenticatedUser?.id && (post.totalLikes ?? 0) > 0) ... {
              Align(
                alignment: Alignment.topLeft,
                child:  GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => likedPostUsersHandler(context),
                  child: Padding(padding: const EdgeInsets.all(5),
                    child: DecoratedBox(decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50)
                    ), child:  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(convertToCompactFigure((post.totalLikes ?? 0).toInt()), style: const TextStyle(color: Colors.white, fontSize: 12),),
                            const SizedBox(width: 5,),
                            const Icon(Icons.favorite, size: 14, color: Colors.white,)
                          ],
                        )
                    ),),
                  ),
                ),
              )
            }

          ],
        ),
      ),
    ));
  }
}
