import 'package:flutter/cupertino.dart';

class ListItem {
  final String id;
  final String title;
  final String? subTitle;
  final IconData? icon;

  const ListItem({required this.id, required this.title, this.subTitle, this.icon});
}

class CurrentPageIsActiveNotifier extends ChangeNotifier {
  bool _value = true;
  bool get value => _value;

  set value(bool newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}