import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../types/dtos/app_style.dart';
import '../../types/dtos/hachlata.dart';

class HachlataWidget extends ConsumerStatefulWidget {
  final Hachlata hachlata;
  final AppStyle style;

  const HachlataWidget({
    Key? key,
    required this.hachlata,
    required this.style,
  }) : super(key: key);

  @override
  ConsumerState<HachlataWidget> createState() => _HachlataWidgetState();
}

class _HachlataWidgetState extends ConsumerState<HachlataWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.style.secondaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: widget.style.tertiaryColor.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hachlata.name,
            style: TextStyle(
              fontSize: widget.style.titleFontSize,
              fontWeight: FontWeight.bold,
              color: widget.style.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.hachlata.description ?? 'No description available',
            style: TextStyle(
              fontSize: widget.style.bodyFontSize,
              color: widget.style.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
