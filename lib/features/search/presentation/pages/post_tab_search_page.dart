import 'package:flutter/material.dart';

class PostTabSearchPage extends StatefulWidget {

  final String searchText;
  const PostTabSearchPage({super.key, required this.searchText});

  @override
  State<PostTabSearchPage> createState() => _PostTabSearchPageState();
}

class _PostTabSearchPageState extends State<PostTabSearchPage> {

  // we use infinite scroll view here

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.searchText),
    );
  }
}
