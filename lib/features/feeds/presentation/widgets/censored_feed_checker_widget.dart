import 'dart:ui';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';

class CensoredFeedCheckerWidget extends StatelessWidget {
  final FeedModel? feed;
  final Widget child;
  const CensoredFeedCheckerWidget({super.key, required this.feed, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if(feed?.disciplinaryAction == "censored") {
      return IgnorePointer(
        ignoring: false,
        child: Stack(
          children: [
            child,
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    alignment: Alignment.center,
                    child:  Column(
                      mainAxisSize: MainAxisSize.min,
                       children: [
                         const Icon(FeatherIcons.eyeOff, color: Colors.white, ),
                          Text(
                           'Censored',
                           style: theme.textTheme.bodyMedium?.copyWith(
                             color: Colors.white,
                             fontWeight: FontWeight.bold,
                           ),
                         )
                       ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    // working on deleted_at and feed.disciplinaryAction == "censored"
    return child;
  }
}
