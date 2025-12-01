import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../types/dtos/hachlata.dart';

class HachlataCircle extends StatefulWidget {
  final Hachlata hachlata;

  const HachlataCircle({super.key, required this.hachlata});

  @override
  State<HachlataCircle> createState() => _HachlataCircleState();
}

class _HachlataCircleState extends State<HachlataCircle> {
  final List<Offset?> _points = [];
  bool _isComplete = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (_isComplete) return;

        final rb = context.findRenderObject() as RenderBox;
        final pos = rb.globalToLocal(details.globalPosition);

        setState(() => _points.add(pos));
      },
      onPanEnd: (_) {
        double fillEstimate = _estimateFillLevel();
        if (fillEstimate > 0.99) {
          setState(() => _isComplete = true);
          HapticFeedback.mediumImpact();
        }
      },
      child: CustomPaint(
        foregroundPainter: HachlataPainter(_points), // <-- FIXED
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isComplete ? Colors.greenAccent : Colors.grey.shade300,
            boxShadow: [
              if (_isComplete)
                const BoxShadow(
                  color: Colors.green,
                  blurRadius: 10,
                  spreadRadius: 1,
                )
            ],
          ),
          child: Center(
            child: Text(
              widget.hachlata.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _isComplete ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
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
}

class HachlataPainter extends CustomPainter {
  final List<Offset?> points;

  HachlataPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20;

    // Clip to the circle
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
