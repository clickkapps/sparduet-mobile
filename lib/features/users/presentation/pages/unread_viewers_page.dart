import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/search/data/store/search_cubit.dart';
import 'package:sparkduet/features/subscriptions/data/store/enum.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/subscriptions/presentation/ui_mixin/subsription_page_mixin.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/features/users/presentation/widgets/user_list_item_widget.dart';
import 'package:sparkduet/utils/custom_infinite_list_view_widget.dart';

class UnreadViewersPage extends StatefulWidget {

  final ScrollController? controller;
  const UnreadViewersPage({super.key, this.controller});

  @override
  State<UnreadViewersPage> createState() => _UnreadViewersPageState();
}

class _UnreadViewersPageState extends State<UnreadViewersPage> with SubscriptionPageMixin{

  // we use infinite scroll view here
  late UserCubit cubit;
  PagingController<int, dynamic>? pagingController;

  @override
  void initState() {
    cubit = context.read<UserCubit>();
    super.initState();
  }

  @override
  void dispose() {
    pagingController?.dispose();
    super.dispose();
  }

  Future<(String?, List<UserModel>?)> fetchData(int pageKey) async {
    return cubit.fetchUnreadProfileViewers(pageKey: pageKey);
  }

  // void usersCubitStateListener(_, UserListState event) {
  //   if(event.status == UserStatus.refreshFeedsListCompleted) {
  //     pagingController?.itemList = event.users;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: NestedScrollView(
        controller: widget.controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {

        return [
          SliverAppBar(
            elevation: 0,
            centerTitle: false,
            // automaticallyImplyLeading: false,
            leading: const CloseButton(),
            title: Text("Profile viewers", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),),
          )
        ];

      }, body: CustomInfiniteListViewWidget<UserModel>(itemBuilder: (item, index) {
        final userItem = item as UserModel;
        return UserListItemWidget(user: userItem, showMessageButton: true,);
      }, fetchData: fetchData,
        pageViewBuilder: (controller) => pagingController = controller,
        padding: const EdgeInsets.symmetric(vertical: 20),
        separatorBuilder: (_, __) {
          return const SizedBox(height: 1,);
        },
      ),),
    );
  }
}
