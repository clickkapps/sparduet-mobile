import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sparkduet/features/users/presentation/widgets/user_list_item_widget.dart';
import 'package:sparkduet/utils/custom_infinite_list_view_widget.dart';

import '../../data/models/user_model.dart';
import '../../data/store/user_cubit.dart';

class UsersOnlinePage extends StatefulWidget {

  final ScrollController? controller;
  const UsersOnlinePage({super.key, this.controller});

  @override
  State<UsersOnlinePage> createState() => _UsersOnlinePageState();
}

class _UsersOnlinePageState extends State<UsersOnlinePage> {

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
    return cubit.fetchUsersOnline(pageKey: pageKey);
  }


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
              title: Text("People online", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),),
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
