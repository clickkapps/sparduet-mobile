import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/presentation/widgets/user_profile_action_widget.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class UserListItemWidget extends StatelessWidget {

  final UserModel user;
  final bool showMessageButton;
  const UserListItemWidget({super.key, required this.user, this.showMessageButton = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        context.pushToProfile(user);
      },
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: theme.colorScheme.surface
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            children: [
              CustomUserAvatarWidget(size: 55, showBorder: false, borderWidth: 1, imageUrl: AppConstants.imageMediaPath(mediaId: user.info?.profilePicPath ?? '') ),
              const SizedBox(width: 10,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name ?? "", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),),
                  if((user.info?.bio ?? "").isNotEmpty)... {
                    Text(user.info?.bio ?? "", style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis,),
                  }
                ],
              )),
              const SizedBox(width: 10,),
              if(showMessageButton) ... {
                UserProfileActionWidget(size: 40, icon: FontAwesomeIcons.solidMessage, onTap: () {
                  context.pushToChatPreview(user);
                },)
              }
            ],
          ),
        ),
      ),
    );
  }
}
