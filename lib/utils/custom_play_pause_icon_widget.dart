import 'package:better_player/better_player.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/widgets/rotating_entrances/rotate_in.dart';
import 'package:sparkduet/core/app_colors.dart';

class CustomPlayPauseIconWidget extends StatelessWidget {

  final BetterPlayerEventType eventType;

  const CustomPlayPauseIconWidget({super.key, required this.eventType});

  @override
  Widget build(BuildContext context) {
    return RotateIn(
      preferences: const AnimationPreferences(
          duration: Duration(milliseconds: 500)
      ),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.black.withOpacity(0.3)
        ),
        child: Center(child: Icon(eventType == BetterPlayerEventType.play ? FeatherIcons.play : FeatherIcons.pause, color: Colors.white, size: 30,),),
      ),
    );;
  }
}
