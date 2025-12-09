import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/general.dart';

class CustomButton extends ConsumerWidget {
  final String title;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final bool? isOutline;

  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.height,
    this.width,
    this.isOutline,
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
          color: isOutline == true
              ? style.backgroundColor
              : style.buttonBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: style.buttonBorderColor, width: 1),
          boxShadow: isOutline == true
              ? []
              : [
                  BoxShadow(
                    color: style.buttonBorderColor,
                    blurRadius: 0,
                    offset: Offset(5, 5),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: style.themeBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
