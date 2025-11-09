import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../input/input_field.dart';

class CustomButton extends ConsumerWidget {
  final String title;
  final VoidCallback onPressed;
  final double? height;
  final double? width;

  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ref.read(styleProvider);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 50.0,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: style.primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: style.secondaryColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: style.secondaryColor.withOpacity(1),
              blurRadius: 0,
              offset: Offset(4, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: style.themeWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
