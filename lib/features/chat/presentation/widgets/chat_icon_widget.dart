import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_cubit.dart';
import 'package:sparkduet/features/chat/data/store/chat_connections_state.dart';

class ChatIconWidget extends StatefulWidget {

  const ChatIconWidget({super.key});

  @override
  State<ChatIconWidget> createState() => _ChatIconWidgetState();
}

class _ChatIconWidgetState extends State<ChatIconWidget> {

  late ChatConnectionsCubit chatConnectionsCubit;
  @override
  void initState() {
    chatConnectionsCubit = context.read<ChatConnectionsCubit>();
    // chatConnectionsCubit.listenToUnreadChatForNotificationDisplay();
    super.initState();
  }

  @override
  void dispose() {
    // chatConnectionsCubit.cancelUnreadChatForNotificationDisplayListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<ChatConnectionsCubit, ChatConnectionState, int>(
      selector: (state) {
        return state.unreadMessages;
      },
      builder: (context, unreadMessages) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(FeatherIcons.messageCircle, color: theme.colorScheme.onBackground, size: 20),
            if(unreadMessages > 0) ... {
              Positioned(right: -5, top: -3,child: Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.buttonBlue,
                ),
                child: Center(
                  child: FittedBox(fit: BoxFit.scaleDown,child: Text("$unreadMessages", style: const TextStyle(fontSize: 12, color: Colors.white),),),
                ),
              ),)
            }

          ],
        );
      },
    )
    ;
  }
}
