import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HachlataCircle extends StatefulWidget {
  const HachlataCircle({super.key});

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
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset localPosition = renderBox.globalToLocal(details.globalPosition);
        setState(() => _points.add(localPosition));
      },
      onPanEnd: (_) async {
        // Estimate how "filled" it is (simplified for now)
        double fillEstimate = _estimateFillLevel();
        if (fillEstimate > 0.99) {
          setState(() => _isComplete = true);
          // optional haptic feedback or animation
          HapticFeedback.mediumImpact();
        }
      },
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
        child: ClipOval(
          child: CustomPaint(
            painter: HachlataPainter(_points),
          ),
        ),
      ),
    );
  }

  // crude "fill" estimate based on stroke count density
  double _estimateFillLevel() {
    if (_points.isEmpty) return 0;
    // simple heuristic: compare number of unique points to circle area
    final radius = 25.0;
    final circleArea = 3.14 * radius * radius;
    final uniquePoints = _points.whereType<Offset>().toSet().length.toDouble();
    // normalized ratio, tuned for realistic touch density
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
      ..strokeWidth = 20.0; // Increased stroke width for a thicker brush

    // Draw all strokes
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
