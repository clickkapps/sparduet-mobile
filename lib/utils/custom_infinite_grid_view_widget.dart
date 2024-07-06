import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_emtpy_content_widget.dart';
import 'package:sparkduet/utils/custom_no_connection_widget.dart';

class CustomInfiniteGridViewWidget<M> extends StatefulWidget {

  final Future<(String?, List<M>?)> Function(int pageKey) fetchData;
  final Function()? onRetryTapped;
  final ItemWidgetBuilder<M> itemBuilder;
  final Function(PagingController<int, dynamic>)? builder;
  final EdgeInsets? padding;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double? childAspectRatio;
  final String? emptyTitle;
  final String? emptySubTitle;
  final Widget? loadingIndicator;
  const CustomInfiniteGridViewWidget({super.key,
    required this.fetchData, this.onRetryTapped, required this.itemBuilder,
    this.builder, this.padding,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 1,
    this.crossAxisSpacing = 1,
    this.childAspectRatio,
    this.emptyTitle,
    this.emptySubTitle,
    this.loadingIndicator
  });

  @override
  State<CustomInfiniteGridViewWidget> createState() => _CustomInfiniteGridViewWidgetState<M>();

}

class _CustomInfiniteGridViewWidgetState<M> extends State<CustomInfiniteGridViewWidget> {

  // page key is page index. Starting from 0, 1, 2 .........
  late PagingController<int, M> pagingController = PagingController(firstPageKey: 1, invisibleItemsThreshold: 9);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) async {

      final newItems = await fetchData(pageKey);
      if(newItems == null) {
        return;
      }
      final isLastPage = newItems.isEmpty;  //correct
      // final isLastPage = newItems.length < 20; // wrong

      if(pageKey == 1) {
        widget.builder?.call(pagingController);
      }

      if (isLastPage) {
        pagingController.appendLastPage(newItems);

      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);

      }


    });
    // onWidgetBindingComplete(onComplete: () {
    //
    // }, milliseconds: 1000);
    //widget.builder?.call(pagingController);
    super.initState();
  }


  Future<List<M>?> fetchData(int pageKey) async {
    final response = await widget.fetchData(pageKey);
    if(response.$1 != null){
      if(pageKey == 1) {
        widget.builder?.call(pagingController);
      }
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
    return PagedGridView<int, M>(
      showNewPageProgressIndicatorAsGridChild: false,
      showNewPageErrorIndicatorAsGridChild: false,
      showNoMoreItemsIndicatorAsGridChild: false,
      pagingController: pagingController,
      padding: widget.padding ?? EdgeInsets.zero,
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: widget.childAspectRatio ?? 100 / 150,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisCount: widget.crossAxisCount,
      ),
      builderDelegate: PagedChildBuilderDelegate<M>(
          itemBuilder: widget.itemBuilder,
          noItemsFoundIndicatorBuilder: (_) => CustomEmptyContentWidget(title: widget.emptyTitle, subTitle:  widget.emptySubTitle),
          noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
          firstPageProgressIndicatorBuilder: (_) => widget.loadingIndicator ?? const SizedBox(height: 30, child: Center(child: CustomAdaptiveCircularIndicator(),),),
          firstPageErrorIndicatorBuilder: (_) => CustomNoConnectionWidget(title:
          "Restore connection and retry ...", onRetry: widget.onRetryTapped,
          ),
          newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
          newPageProgressIndicatorBuilder: (_) => const SizedBox(height: 30, child: Center(child: CustomAdaptiveCircularIndicator(),),),
      ),
    );
  }
}
