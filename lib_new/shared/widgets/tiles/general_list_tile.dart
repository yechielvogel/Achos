import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../input/input_field.dart';

class CustomListTile extends ConsumerStatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const CustomListTile({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  ConsumerState<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends ConsumerState<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);

    return ListTile(
      title: Text(
        widget.title,
        style: TextStyle(
          color: style.primaryColor,
          fontSize: style.bodyFontSize,
        ),
      ),
      onTap: widget.onPressed,
    );
  }
}
