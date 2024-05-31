import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {

  final Function(String?)? onChanged;
  final Function(String?)? onSubmitted;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  const SearchFieldWidget({super.key,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.controller
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: CupertinoSearchTextField(
        onChanged: onChanged,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 5),
          child: Icon(FeatherIcons.search),
        ),
        // textInputAction: TextInputAction.done,
        focusNode: focusNode,
        style: TextStyle(color: theme.colorScheme.onBackground),
        // cursorColor: theme.colorScheme.onPrimary.withOpacity(0.5),
        onSubmitted: onSubmitted,
        borderRadius: BorderRadius.circular(100),
        controller: controller,
        padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 5),

      ),
    );
  }
}
