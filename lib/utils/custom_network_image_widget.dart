import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNetworkImageWidget extends StatelessWidget {

  final String imageUrl;
  final BoxFit? fit;
  final int? maxWidthDiskCache;
  final Widget? errorChild;
  final Widget? progressChild;
  final double? width;
  final double? height;
  const CustomNetworkImageWidget({
    required this.imageUrl,
    this.fit,
    this.maxWidthDiskCache,
    this.errorChild,
    this.progressChild,
    this.width,
    this.height,
    super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      fadeInCurve: Curves.easeIn,
      cacheKey: imageUrl,
      maxWidthDiskCache: maxWidthDiskCache,
      memCacheWidth: maxWidthDiskCache,
      width: width,
      height: height,
      progressIndicatorBuilder: (context, url, downloadProgress) => progressChild ??
          const Center(child: CupertinoActivityIndicator(),),
      errorWidget: (context, url, error) {
        debugPrint("Error image url = $imageUrl");
        return errorChild ?? const Center(child: Icon(Icons.error_outline),);
      },
    );
  }
}
