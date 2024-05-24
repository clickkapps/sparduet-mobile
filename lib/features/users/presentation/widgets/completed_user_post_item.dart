import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/utils/custom_network_image_widget.dart';

class CompletedUserPostItem extends StatelessWidget {

  final FeedModel post;
  final Function()? onTap;
  const CompletedUserPostItem({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {

    // debugPrint("CustomLog mediaPath: $networkPath");
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: [
            SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child:post.mediaType == FileType.video ? CustomNetworkImageWidget(imageUrl: AppConstants.thumbnailMediaPath(mediaId: post.mediaPath ?? ""), fit: BoxFit.cover,)
                : CustomNetworkImageWidget(imageUrl: AppConstants.imageMediaPath(mediaId: post.mediaPath ?? ""), fit: BoxFit.cover,),
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
