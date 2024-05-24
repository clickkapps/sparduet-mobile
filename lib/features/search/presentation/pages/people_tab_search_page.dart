import 'package:flutter/material.dart';

class PeopleTabSearchPage extends StatefulWidget {

  final String searchText;
  const PeopleTabSearchPage({super.key, required this.searchText});

  @override
  State<PeopleTabSearchPage> createState() => _PeopleTabSearchPageState();
}

class _PeopleTabSearchPageState extends State<PeopleTabSearchPage> {

  // we use infinite scroll view here

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Infinite scroll list here"),
    );
  }
}
