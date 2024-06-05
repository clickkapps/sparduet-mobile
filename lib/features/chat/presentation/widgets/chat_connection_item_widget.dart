import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/chat/data/models/chat_model.dart';
import 'package:sparkduet/utils/custom_badge_icon.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class ChatConnectionItemWidget extends StatelessWidget {

  final ChatModel chat;
  const ChatConnectionItemWidget({super.key, required this.chat});

  void _showContextMenu(BuildContext context) {
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = context.read<AuthCubit>().state.authUser!;
    final otherParticipant = chat.participants!.where((element) => element.id != currentUser.id).first;
    final thisParticipant = chat.participants!.where((element) => element.id == currentUser.id).first;


    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(AppRoutes.chatPreview, extra: {
          "user": otherParticipant,
          "chatConnection": chat
        });
      },

      child: DecoratedBox(
        decoration: BoxDecoration(
            color: theme.colorScheme.surface
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            children: [
              CustomUserAvatarWidget(size: 55, showBorder: false, borderWidth: 1, imageUrl: otherParticipant.image),
              const SizedBox(width: 10,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(otherParticipant.name ?? '', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),),

                  if(chat.lastMessage  != null) ... {
                    if(chat.lastMessage?.deleted ?? false) ... {
                      Row(
                        children: [
                          Icon(Icons.block, size: 13, color: theme.textTheme.titleSmall?.color,),
                          const SizedBox(width: 3,),
                          Text("Message deleted", style: theme.textTheme.titleSmall?.copyWith(fontSize: 12), maxLines: 1, ),
                        ],
                      )
                    }else ... {
                      // Text(, style: theme.textTheme.titleSmall?.copyWith(fontSize: 12), maxLines: 1, ),
                      Text(chat.lastMessage?.message ?? '', style: theme.textTheme.bodySmall,),
                    }
                  }

                ],
              )),
              const SizedBox(width: 10,),
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Text(getFormattedDateWithIntl(DateTime.now(), format: "h:mm a"), style: theme.textTheme.bodySmall?.copyWith(),),
              //     const SizedBox(height: 5,),
              //     const CustomBadgeIcon(badgeCount: 2)
              //   ],
              // )
              SeparatedColumn(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 3,);
                },
                children: [
                  if(chat.lastMessage?.createdAt != null) ... {
                    Text(getFormattedDateWithIntl(chat.lastMessage!.createdAt!, format: "h:mm a"), style: theme.textTheme.bodySmall?.copyWith(),),
                  },

                  if(thisParticipant.unreadMessages > 0)... {
                    CustomBadgeIcon(badgeCount: thisParticipant.unreadMessages)
                    // Container(
                    //   width: 20,
                    //   height: 20,
                    //   decoration: BoxDecoration(
                    //       color: const Color(0xffB20000),
                    //       borderRadius: BorderRadius.circular(20)
                    //   ),
                    //   child:  Center(child: Text("${}", style: theme.textTheme.bodySmall?.copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),),
                    // )
                  }

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
