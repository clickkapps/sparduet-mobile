import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sparkduet/features/notifications/data/models/notification_model.dart';
import 'package:sparkduet/features/notifications/data/store/notifications_cubit.dart';
import 'package:sparkduet/features/notifications/presentation/widgets/notification_item_widget.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/utils/custom_infinite_list_view_widget.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  late NotificationsCubit notificationsCubit;
  PagingController<int, NotificationModel>? pagingController;
  late SubscriptionCubit subscriptionCubit;

  @override
  void initState() {
    notificationsCubit = context.read<NotificationsCubit>();
    notificationsCubit.markNotificationAsSeen();

    super.initState();
  }

  Future<(String?, List<NotificationModel>?)> fetchData(int pageKey) async {
    return notificationsCubit.fetchNotifications(pageKey: pageKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        elevation: 0,
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: CustomInfiniteListViewWidget<NotificationModel>(itemBuilder: (item, index) {
        final notification = item as NotificationModel;
        return NotificationItemWidget(key: ValueKey(notification.id), notification: notification);
      }, fetchData: fetchData,
        pageViewBuilder: (controller) => pagingController = controller,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        separatorBuilder: (_, __) {
          return const SizedBox(height: 5,);
        },

      ),
    );
  }
}
