import 'package:flutter/material.dart';

class CustomBadgeIcon extends StatelessWidget {

  final int badgeCount;
  const CustomBadgeIcon({super.key, required this.badgeCount});

  @override
  Widget build(BuildContext context) {
    if(badgeCount < 1) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: const Color(0xffB20000),
          borderRadius: BorderRadius.circular(20)
      ),
      child:  Center(child: Text("$badgeCount", style: theme.textTheme.bodySmall?.copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),),
    );
  }
}
