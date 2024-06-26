import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/notifications/data/models/notification_model.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_cubit.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_state.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/subscriptions/presentation/ui_mixin/subsription_page_mixin.dart';
import 'package:sparkduet/features/users/presentation/pages/unread_viewers_page.dart';
import 'package:sparkduet/utils/custom_card.dart';

class NotificationItemWidget extends StatelessWidget with SubscriptionPageMixin{

  final NotificationModel notification;
  const NotificationItemWidget({super.key, required this.notification});

  void onItemTapped(BuildContext context) {
    if(notification.type == "profile_views"){
      if(!context.read<SubscriptionCubit>().state.subscribed) {
        showSubscriptionPaywall(context, openAsModal: true);
        return;
      }
      // mark notification as read
      context.read<NotificationsCubit>().markNotificationAsRead(notificationId: notification.id);
      context.pushScreen(const UnreadViewersPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onItemTapped(context),
      child: BlocSelector<NotificationsCubit, NotificationsState, NotificationModel>(
        selector: (state) {
          return state.notifications.where((element) => element.id == notification.id).firstOrNull ?? notification;
        },
        builder: (context, notification) {
          return CustomCard(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.info_outline, size: 22, color: AppColors.buttonBlue,),
                  SeparatedRow(
                    mainAxisSize: MainAxisSize.min,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 10,);
                    },
                    children: [
                      if(notification.createdAt != null) ... {
                        Text(getFormattedDateTimeWithIntl(notification.createdAt!),style: theme.textTheme.bodySmall,)
                      },
                      if(notification.readAt == null) ... {
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: const ColoredBox(
                            color: AppColors.buttonBlue,
                            child: SizedBox(width: 10, height: 10,),
                          ),
                        )
                      }

                    ],
                  )
                ],
              ),
              const SizedBox(height: 10,),
              SeparatedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 5,);
                },
                children: [
                  Text(notification.title ?? "", style: theme.textTheme.titleMedium,),
                  Text(notification.message ?? "", style: theme.textTheme.bodyMedium,),
                ],
              )
            ],
          ));
        },
      )
      ,
    );
  }
}
