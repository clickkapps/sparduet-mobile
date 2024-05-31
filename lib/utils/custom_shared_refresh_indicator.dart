import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as refresher;

class CustomSharedRefreshIndicator extends StatefulWidget {

  final Widget child;
  final Future<void> Function() onRefresh;
  const CustomSharedRefreshIndicator({
    required this.onRefresh,
    required this.child,
    super.key});

  @override
  State<CustomSharedRefreshIndicator> createState() => _CustomSharedRefreshIndicatorState();
}

class _CustomSharedRefreshIndicatorState extends State<CustomSharedRefreshIndicator> {

  final refresher.RefreshController _refreshController = refresher.RefreshController();

  @override
  void dispose() {
    super.dispose();
    // _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Platform.isIOS ?
    refresher.SmartRefresher(
      controller: _refreshController,
      header: refresher.ClassicHeader(
        // refreshingText: const SizedBox.shrink(),
        refreshingIcon: CupertinoActivityIndicator(color: theme.colorScheme.onBackground,),
        refreshStyle: refresher.RefreshStyle.UnFollow,
        completeDuration: const Duration(milliseconds: 0),
        completeText: '',
        completeIcon: const SizedBox.shrink(),
        refreshingText: '',
        releaseText: '',
        idleText: '',
        releaseIcon: Icon(Icons.arrow_upward, color: theme.colorScheme.onBackground,),
        idleIcon: Icon(Icons.arrow_downward, color: theme.colorScheme.onBackground,),
      ),
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        await widget.onRefresh.call();
        _refreshController.refreshCompleted();
      },
      child: widget.child,
    ) :
          RefreshIndicator(
              onRefresh: widget.onRefresh,
              color: theme.colorScheme.secondary,
              backgroundColor: theme.colorScheme.background,
              child: widget.child);

  }
}
