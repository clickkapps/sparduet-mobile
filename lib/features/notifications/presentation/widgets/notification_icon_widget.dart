import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_cubit.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_state.dart';

class NotificationIconWidget extends StatefulWidget {
  const NotificationIconWidget({super.key});

  @override
  State<NotificationIconWidget> createState() => _NotificationIconWidgetState();
}

class _NotificationIconWidgetState extends State<NotificationIconWidget> {

  late NotificationsCubit notificationsCubit;

  @override
  void initState() {
    notificationsCubit = context.read<NotificationsCubit>();
    notificationsCubit.countUnseenNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate icon size based on parent constraints
    double iconSize = MediaQuery.of(context).size.width * 0.065; // 10% of parent width

    // Ensure the icon size is not too small or too large
    if (iconSize < 24) {
      iconSize = 24;
    } else if (iconSize > 100) {
      iconSize = 100;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(FeatherIcons.bell, color: Colors.white, size: iconSize,),
        Positioned(
            right: -5, top: -3,
            child: BlocSelector<NotificationsCubit, NotificationsState, int>(
              selector: (state) {
                return state.count;
              },
              builder: (context, cnt) {
                if(cnt > 0)  {
                  return Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.buttonBlue,
                    ),
                    child: Center(
                      child: FittedBox(fit: BoxFit.scaleDown,child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("$cnt", style: const TextStyle(fontSize: 12, color: Colors.white),),
                      ),),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )),

      ],
    );
  }
}
