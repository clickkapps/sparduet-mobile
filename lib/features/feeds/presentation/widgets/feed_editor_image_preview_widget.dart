import 'dart:io';
import 'package:flutter/material.dart';


class FeedEditorImagePreviewWidget extends StatelessWidget {

  final File file;
  const FeedEditorImagePreviewWidget({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(width: double.maxFinite,
        child: Image.file(file, fit: BoxFit.cover,),
      ),
    );
  }
}
