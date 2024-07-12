import 'dart:io';

import 'package:avatars/avatars.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_assets.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_state.dart';
import 'package:sparkduet/utils/custom_network_image_widget.dart';

class CustomUserAvatarWidget extends StatelessWidget {

  final double size;
  final Color? color;
  final String? imageUrl;
  final int? userId;
  final bool showBorder;
  final double borderWidth;
  final BoxFit fit;
  final double borderRadius;
  final File? placeHolderFile;
  final String? placeHolderName;
  const CustomUserAvatarWidget({
  this.size = 35,
  this.color,
  this.imageUrl,
  this.showBorder = false,
  this.fit = BoxFit.cover,
  this.borderRadius = 1000,
  this.userId,
  this.placeHolderFile,
  this.placeHolderName,
  this.borderWidth = 3,
  super.key});

  Widget get  avatarPlaceholder => placeHolderFile != null ? Image.file(placeHolderFile!, width: size, fit: BoxFit.cover, height: size,)
      :(placeHolderName != null ? SizedBox(width: size, height: size, child: Avatar(name: placeHolderName.capitalize(), textStyle: TextStyle(fontSize: size * 0.4, color: Colors.white), ),) : Image.asset(AppAssets.avatar, width: size, fit: BoxFit.cover, height: size,) );
      // : ;

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final imgSize = showBorder ? (size - borderWidth) : size;

    debugPrint("customUserAvatar build");

    return BlocSelector<UserCubit, UserState, bool>(
      selector: (state) {
        return userId == null ? false : (state.onlineUserIds.where((element) => element == userId).firstOrNull != null);
      },
      builder: (context, online) {
        final showBorderEvaluated = online ? true : showBorder;
        return Container(
            decoration: BoxDecoration(
                border: showBorderEvaluated ? Border.all(color: online ? AppColors.onlineGreen : color ?? theme.colorScheme.onBackground, width: borderWidth) : null,
                borderRadius: BorderRadius.circular(borderRadius),
                color: theme.colorScheme.outline.withOpacity(0.3)
            ),
            child: imageUrl.isNullOrEmpty() ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: avatarPlaceholder) :
            SizedBox(
                width: imgSize,
                height: imgSize,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: CustomNetworkImageWidget(imageUrl: imageUrl ?? '', fit: fit, width:  imgSize, height:  imgSize,
                      errorChild: avatarPlaceholder,
                      progressChild: avatarPlaceholder,
                    )))
        );
      },
    )
    ;
  }
}
