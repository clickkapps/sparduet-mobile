import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/chat/data/models/chat_connection_model.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/utils/custom_badge_icon.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class ChatConnectionItemWidget extends StatelessWidget {

  final ChatConnectionModel chatConnection;
  const ChatConnectionItemWidget({super.key, required this.chatConnection});

  void _showContextMenu(BuildContext context) {
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);

    final ch = ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        color: theme.brightness == Brightness.light ? const Color(0xffF2F3F4) : const Color(0xff202021),
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: GestureDetector(
                      onTap: () {
                        context.popScreen();
                      },
                      child: ColoredBox(
                          color: theme.brightness == Brightness.light ? const Color(0xffc2c2c2) : theme.colorScheme.outline,
                          child:  SizedBox(
                              width: 30,
                              height: 30,
                              child: Center(
                                  child: Icon(Icons.close, size: 20, color: theme.colorScheme.background,)))),
                    )
                ),
              ),

              const SizedBox(height: 20,),

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: theme.brightness == Brightness.light ? theme.colorScheme.surface : theme.colorScheme.outline
                ),
                child: SeparatedColumn(
                  mainAxisSize: MainAxisSize.min,
                  separatorBuilder: (BuildContext context, int index) {
                    return CustomBorderWidget(color: theme.brightness == Brightness.light ? theme.colorScheme.outline.withOpacity(0.1) : theme.colorScheme.background.withOpacity(0.2),);
                  },
                  children: [

                    ListTile(title: Text("Delete chat", style: theme.textTheme.bodyMedium), onTap: () {
                      context.popScreen();
                      context.read<ChatConnectionsCubit>().deleteConnection(connection: chatConnection);
                    }, trailing: Icon(FeatherIcons.delete, size: 20, color:theme.colorScheme.onSurface,),),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );

    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)));
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = context.read<AuthCubit>().state.authUser!;
    final otherParticipant = chatConnection.participants!.where((element) => element.id != currentUser.id).first;
    // final thisParticipant = chatConnection.participants!.where((element) => element.id == currentUser.id).first;


    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.pushToChatPreview({
          "user": otherParticipant,
          "connection": chatConnection
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
              GestureDetector(
                onTap: () => context.pushToProfile(otherParticipant),
                  child: CustomUserAvatarWidget(size: 55, showBorder: false, borderWidth: 2, userId: otherParticipant.id, imageUrl: otherParticipant.info?.profilePicPath,)),
              const SizedBox(width: 10,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(otherParticipant.name ?? '', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),),

                  if(chatConnection.lastMessage  != null) ... {
                    if(chatConnection.lastMessage?.deletedAt != null) ... {
                      Row(
                        children: [
                          Icon(Icons.block, size: 13, color: theme.textTheme.titleSmall?.color,),
                          const SizedBox(width: 3,),
                          Text("Message deleted", style: theme.textTheme.titleSmall?.copyWith(fontSize: 12), maxLines: 1, ),
                        ],
                      )
                    }else ... {
                      // Text(, style: theme.textTheme.titleSmall?.copyWith(fontSize: 12), maxLines: 1, ),
                      Text(chatConnection.lastMessage?.text ?? '', style: theme.textTheme.bodySmall,),
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
                  if(chatConnection.lastMessage?.createdAt != null) ... {
                    Text(getFormattedDateWithIntl(chatConnection.lastMessage!.createdAt!, format: "h:mm a"), style: theme.textTheme.bodySmall?.copyWith(),),
                  },

                  // this will come from the pivot
                  if((chatConnection.unreadMessages ?? 0) > 0)... {
                    CustomBadgeIcon(badgeCount: (chatConnection.unreadMessages ?? 0).toInt())
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
