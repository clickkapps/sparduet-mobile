import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_assets.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/utils/custom_network_image_widget.dart';

class CustomUserAvatarWidget extends StatelessWidget {

  final double size;
  final Color? color;
  final String? imageUrl;
  final bool online;
  final bool showBorder;
  final double borderWidth;
  final BoxFit fit;
  final double borderRadius;
  const CustomUserAvatarWidget({
  this.size = 35,
  this.color,
  this.imageUrl,
  this.showBorder = false,
  this.online = false,
  this.fit = BoxFit.cover,
  this.borderRadius = 1000,
    this.borderWidth = 3,
  super.key});

  Widget get  avatarPlaceholder => Image.asset(AppAssets.avatar, width: size, fit: BoxFit.cover, height: size,);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);


    return Container(
        decoration: BoxDecoration(
          border: showBorder ? Border.all(color: online ? AppColors.buttonBlue : color ?? theme.colorScheme.onBackground, width: borderWidth) : null,
          borderRadius: BorderRadius.circular(borderRadius),
          color: theme.colorScheme.outline.withOpacity(0.3)
        ),
        child: imageUrl.isNullOrEmpty() ? ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
            child: avatarPlaceholder) :
        SizedBox(
            width: size,
            height: size,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: CustomNetworkImageWidget(imageUrl: imageUrl ?? '', fit: fit,
                  errorChild: avatarPlaceholder,
                  progressChild: avatarPlaceholder,
                )))
    );
  }
}
