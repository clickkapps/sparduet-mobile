import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/search/data/store/search_cubit.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/presentation/widgets/user_list_item_widget.dart';
import 'package:sparkduet/utils/custom_infinite_list_view_widget.dart';

class PeopleTabSearchPage extends StatefulWidget {

  final String searchText;
  const PeopleTabSearchPage({super.key, required this.searchText});

  @override
  State<PeopleTabSearchPage> createState() => _PeopleTabSearchPageState();
}

class _PeopleTabSearchPageState extends State<PeopleTabSearchPage> {

  // we use infinite scroll view here
  late SearchCubit cubit;
  PagingController<int, UserModel>? pagingController;

  @override
  void initState() {
    cubit = context.read<SearchCubit>();
    super.initState();
  }

  @override
  void dispose() {
    pagingController?.dispose();
    super.dispose();
  }

  Future<(String?, List<UserModel>?)> fetchData(int pageKey) async {
    final authUser = context.read<AuthCubit>().state.authUser;
    return cubit.searchUsers(query: widget.searchText, pageKey: pageKey, authUserId: authUser?.id);
  }

  // void usersCubitStateListener(_, UserListState event) {
  //   if(event.status == UserStatus.refreshFeedsListCompleted) {
  //     pagingController?.itemList = event.users;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CustomInfiniteListViewWidget<UserModel>(itemBuilder: (item, index) {
      final userItem = item as UserModel;
      return UserListItemWidget(user: userItem);
    }, fetchData: fetchData,
      pageViewBuilder: (controller) => pagingController = controller,
      padding: const EdgeInsets.symmetric(vertical: 20),
      separatorBuilder: (_, __) {
        return const SizedBox(height: 1,);
      },
    );
  }
}
