import 'package:better_player/better_player.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_animator/widgets/rotating_entrances/rotate_in.dart';
import 'package:sparkduet/core/app_colors.dart';

class CustomPlayPauseIconWidget extends StatelessWidget {

  final BetterPlayerEventType eventType;

  const CustomPlayPauseIconWidget({super.key, required this.eventType});

  @override
  Widget build(BuildContext context) {
    return BounceIn(
      preferences: const AnimationPreferences(
          duration: Duration(milliseconds: 500)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(500),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              color: Colors.black.withOpacity(0.3)

          ),
          child: Center(child: Icon(eventType == BetterPlayerEventType.play ? FeatherIcons.pause : FeatherIcons.play, color: Colors.white, size: 30,),),
        ),
      ),
    );;
  }
}
