import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/style.dart';
import '../types/dtos/hachlata.dart';

class HachlataCircle extends ConsumerStatefulWidget {
  final Hachlata hachlata;
  final VoidCallback? onComplete;
  final bool completed;

  const HachlataCircle({
    super.key,
    required this.hachlata,
    this.onComplete,
    required this.completed,
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
    final style = ref.watch(appStyleProvider);

    return GestureDetector(
      onPanUpdate: (details) {
        if (_isComplete) return;

        final rb = context.findRenderObject() as RenderBox;
        final pos = rb.globalToLocal(details.globalPosition);

        setState(() => _points.add(pos));
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
        width: 100,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              foregroundPainter: HachlataPainter(_points, style.accentColor),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isComplete
                      ? style.accentColor
                      : style.buttonBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: style.buttonBorderColor,
                      blurRadius: 0,
                      offset: const Offset(5, 10),
                    ),
                  ],
                  // border: Border.all(
                  //   color: style.buttonBorderColor,
                  //   width: 2,
                  // ),
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
    );
  }

  double _estimateFillLevel() {
    if (_points.isEmpty) return 0;

    const radius = 25.0;
    final circleArea = 3.14 * radius * radius;
    final uniquePoints = _points.whereType<Offset>().toSet().length.toDouble();

    return (uniquePoints / (circleArea / 8)).clamp(0.0, 1.0);
  }

  void _fillRemaining() {
    const radius = 25.0;
    final center = Offset(radius, radius);
    final step = 2 * 3.14 / 360;

    for (double angle = 0; angle < 2 * 3.14; angle += step) {
      final x = center.dx + radius * 0.9 * cos(angle);
      final y = center.dy + radius * 0.9 * sin(angle);
      _points.add(Offset(x, y));
    }
  }
}

class HachlataPainter extends CustomPainter {
  final List<Offset?> points;
  final Color fillColor;

  HachlataPainter(this.points, this.fillColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fillColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20;

    canvas.clipPath(
      Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      if (p1 != null && p2 != null) {
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
