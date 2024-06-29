import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_colors.dart';

class AttachMessageFileButtonWidget extends StatelessWidget {

  final Function()? onTap;

  const AttachMessageFileButtonWidget({this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.buttonBlue
        ),
        width: 30,
        height: 30,
        padding: const EdgeInsets.all(5),
        child: const Icon(Icons.camera_rounded, size: 15, color: AppColors.white,),
      ),
    );
  }

}
