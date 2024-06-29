import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_emtpy_content_widget.dart';
import 'package:sparkduet/utils/custom_no_connection_widget.dart';
import 'package:sparkduet/utils/custom_shared_refresh_indicator.dart';

/// <Cubit, State, Model>
class CustomInfiniteListViewWidget<M> extends StatefulWidget {

  final Widget Function(dynamic, int) itemBuilder;
  final Function(PagingController<int, dynamic>)? pageViewBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final Widget? noItemsFoundIndicator;
  final EdgeInsets? padding;
  final Future<(String?, List<dynamic>?)> Function(int) fetchData;
  const CustomInfiniteListViewWidget({super.key, required this.itemBuilder, required this.fetchData,
    required this.pageViewBuilder, this.padding,
    this.separatorBuilder,
    this.noItemsFoundIndicator
  });

  @override
  State<CustomInfiniteListViewWidget> createState() => _CustomInfiniteListViewWidgetState<M>();
}

class _CustomInfiniteListViewWidgetState<M> extends State<CustomInfiniteListViewWidget> with AutomaticKeepAliveClientMixin {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, M> pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {

    pagingController.addPageRequestListener((pageKey) async {

      final newItems = await fetchData(pageKey);
      if(newItems == null) {
        pagingController.appendLastPage([]);
        return;
      }
      final isLastPage = newItems.isEmpty;
      // newItems.length < AppConstants.listPageSize // we don't add this condition because sometimes we can filter the results locally and it will affect this condition
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }

    });
    widget.pageViewBuilder?.call(pagingController);
    super.initState();
  }


  Future<List<M>?> fetchData(int pageKey) async {
    final response = await widget.fetchData(pageKey);
    if(response.$1 != null){
      pagingController.error = response.$1;
      return null;
    }
    final newItems = response.$2 as List<M>?;
    return newItems;
  }

  Future<void> onRefreshHandler() async {
    final newItems = await fetchData(1);
    if(newItems == null) { return; }
    pagingController.value = PagingState(nextPageKey: 2, itemList: newItems);
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);

    // final theme = Theme.of(context);
    return CustomSharedRefreshIndicator(
      onRefresh: onRefreshHandler,
      child: PagedListView<int, M>.separated(
        padding: widget.padding ??  const EdgeInsets.only(top: 20, left: 0, right: 0),
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<M>(
          itemBuilder: (ctx, item, index) => widget.itemBuilder(item, index),
          firstPageProgressIndicatorBuilder: (_) => const Center(child: CustomAdaptiveCircularIndicator(),),
          newPageProgressIndicatorBuilder: (_) => const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: SizedBox(
                height: 100, width: double.maxFinite,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CustomAdaptiveCircularIndicator(),
                ),
              )),
          noItemsFoundIndicatorBuilder: (_) => widget.noItemsFoundIndicator ?? const CustomEmptyContentWidget(),
          noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
          firstPageErrorIndicatorBuilder: (_) => const CustomNoConnectionWidget(title:
          "Restore connection and swipe to refresh ...",
          ),
          newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
        ),
        separatorBuilder: widget.separatorBuilder ?? (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
