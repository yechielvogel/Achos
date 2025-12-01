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

    return Container(
      decoration: BoxDecoration(
        color: style.primaryColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: style.primaryColor,
          width: 1.5,
        ),
      ),
      child: ListTile(
        title: Text(
          widget.title,
          style: TextStyle(
            color: style.backgroundColor,
            fontSize: style.bodyFontSize,
          ),
        ),
        onTap: widget.onPressed,
      ),
    );
  }
}
