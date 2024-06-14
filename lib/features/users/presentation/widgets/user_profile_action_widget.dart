import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_colors.dart';

class UserProfileActionWidget extends StatelessWidget {

  final double size;
  final IconData icon;
  final Function()? onTap;
  const UserProfileActionWidget({super.key, required this.size, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.buttonBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(size),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),

      child: Center(child: Icon(icon,
        // color: theme.colorScheme.onBackground,
        color: AppColors.buttonBlue,
        size: size * 0.4,),),
    );
  }
}
