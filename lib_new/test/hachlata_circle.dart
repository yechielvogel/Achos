import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/style.dart';
import '../types/dtos/categories.dart';
import '../types/dtos/hachlata.dart';

class HachlataCircle extends ConsumerStatefulWidget {
  final Category category;
  final Hachlata hachlata;
  final VoidCallback? onComplete;
  final bool completed;
  final double scale;
  final bool allowInteraction;

  const HachlataCircle({
    super.key,
    required this.hachlata,
    required this.category,
    this.onComplete,
    required this.completed,
    required this.allowInteraction,
    this.scale = 1.0,
  });

  @override
  ConsumerState<HachlataCircle> createState() => _HachlataCircleState();
}

class _HachlataCircleState extends ConsumerState<HachlataCircle> {
  final List<Offset?> _points = [];
  late bool _isComplete;

  @override
  void initState() {
    super.initState();
    _isComplete = widget.completed;

    if (_isComplete) {
      _fillRemaining();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tileSize = 100.0 * widget.scale;

    final style = ref.watch(appStyleProvider);

    return Transform.scale(
      scale: widget.scale,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          return true;
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (_) {
            Scrollable.of(context)?.position.isScrollingNotifier.value = false;
          },
          onPanUpdate: (details) {
            if (_isComplete) return;
            if (!widget.allowInteraction) return;

            final rb = context.findRenderObject() as RenderBox;
            final pos = rb.globalToLocal(details.globalPosition);

            setState(() => _points.add(pos));

            double fillEstimate = _estimateFillLevel();
            if (fillEstimate > 0.8) {
              setState(() {
                _isComplete = true;
                _fillRemaining();
              });
              HapticFeedback.mediumImpact();

              if (widget.onComplete != null) {
                widget.onComplete!();
              }
            }
          },
          onPanEnd: (_) {
            if (_isComplete) return;

            double fillEstimate = _estimateFillLevel();
            if (fillEstimate > 0.8) {
              setState(() {
                _isComplete = true;
                _fillRemaining();
              });
              HapticFeedback.mediumImpact();

              if (widget.onComplete != null) {
                widget.onComplete!();
              }
            }
          },
          child: SizedBox(
            width: tileSize,
            height: tileSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  foregroundPainter: HachlataPainter(
                    _points,
                    widget.category.color.isNotEmpty
                        ? Color(int.parse(widget.category.color))
                        : style.buttonBackgroundColor,
                    scale: widget.scale,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isComplete
                          ? Color(int.parse(widget.category.color))
                          : style.buttonBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: style.buttonBorderColor,
                          blurRadius: 0,
                          offset: const Offset(3, 5),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.hachlata.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: style.themeBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _estimateFillLevel() {
    if (_points.isEmpty) return 0;

    final radius = 50.0 * widget.scale; // Scaled radius
    final circleArea = pi * radius * radius; // Area of the circle
    final uniquePoints = _points.whereType<Offset>().toSet().length.toDouble();

    return (uniquePoints / (circleArea / 8)).clamp(0.0, 1.0);
  }

  void _fillRemaining() {
    final radius = 50.0 * widget.scale; // Radius of the circle based on scale
    final center = Offset(radius, radius); // Center of the circle
    final step =
        2 * pi / 360; // Step size for iterating over the circle (1 degree)

    // Add points to fill the entire circle area
    for (double r = 0; r <= radius; r += 1) {
      // Increment by 1 for smoother fill
      for (double angle = 0; angle < 2 * pi; angle += step) {
        final x = center.dx + r * cos(angle);
        final y = center.dy + r * sin(angle);
        _points.add(Offset(x, y));
      }
    }
  }
}

class HachlataPainter extends CustomPainter {
  final List<Offset?> points;
  final Color fillColor;
  final double scale;

  HachlataPainter(this.points, this.fillColor, {this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fillColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20 * scale;

    final radius = size.width / 2;
    canvas.clipPath(
      Path()
        ..addOval(
            Rect.fromCircle(center: Offset(radius, radius), radius: radius)),
    );

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      if (p1 != null && p2 != null) {
        canvas.drawLine(p1, p2, paint);
        if (i % 5 == 0) {
          HapticFeedback.lightImpact();
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
