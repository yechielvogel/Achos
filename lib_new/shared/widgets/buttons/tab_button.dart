import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/general.dart';

class CustomTabButton extends ConsumerStatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  const CustomTabButton({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  ConsumerState<CustomTabButton> createState() => _CustomTabButtonState();
}

class _CustomTabButtonState extends ConsumerState<CustomTabButton> {
  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);

    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          widget.title,
          style: TextStyle(
            color: widget.isSelected ? style.primaryColor : Colors.grey,
            fontSize: style.bodyFontSize,
            fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
