import 'package:flutter/cupertino.dart';

class ListItem {
  final String id;
  final String title;
  final String? subTitle;
  final IconData? icon;

  const ListItem({required this.id, required this.title, this.subTitle, this.icon});
}