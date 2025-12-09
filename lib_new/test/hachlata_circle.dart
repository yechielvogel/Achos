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
  final double? radius;

  const HachlataCircle({
    super.key,
    required this.hachlata,
    required this.category,
    this.onComplete,
    required this.completed,
    required this.allowInteraction,
    this.scale = 1.0,
    this.radius,
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

            final r = widget.radius ?? 50.0 * widget.scale;
            final center = Offset(r, r);

            if ((pos - center).distance <= r) {
              setState(() => _points.add(pos));
            }

            double fillEstimate = _estimateFillLevel();
            if (fillEstimate > 0.8) {
              setState(() {
                _isComplete = true;
              });
              HapticFeedback.mediumImpact();

              if (widget.onComplete != null) {
                widget.onComplete!();
              }
            }
          },
          onPanEnd: (_) {
            Scrollable.of(context)?.position.isScrollingNotifier.value = true;

            if (_isComplete) return;

            double fillEstimate = _estimateFillLevel();
            if (fillEstimate > 0.8) {
              setState(() {
                _isComplete = true;
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
    if (_points.isEmpty) return 0.0;

    final r = widget.radius ?? 50.0 * widget.scale;
    final center = Offset(r, r);

    const int gridSize = 20;
    final double cellSize = (r * 2) / gridSize;

    int filledCells = 0;
    int totalCells = gridSize * gridSize;

    final Set<String> checkedCells = {};

    for (final point in _points) {
      if (point == null) continue;

      if ((point - center).distance > r) continue;

      int gridX = (point.dx / cellSize).floor();
      int gridY = (point.dy / cellSize).floor();

      for (int dx = -2; dx <= 2; dx++) {
        for (int dy = -2; dy <= 2; dy++) {
          int cx = gridX + dx;
          int cy = gridY + dy;

          if (cx < 0 || cy < 0 || cx >= gridSize || cy >= gridSize) continue;

          final String key = '$cx,$cy';
          if (checkedCells.contains(key)) continue;

          final cellCenter = Offset(
            (cx + 0.5) * cellSize,
            (cy + 0.5) * cellSize,
          );

          bool cellIsHit = _points.any((p) {
            if (p == null) return false;
            return (p - cellCenter).distance <= 18 * widget.scale;
          });

          if (cellIsHit) {
            checkedCells.add(key);
            filledCells++;
          }
        }
      }
    }

    return (filledCells / totalCells).clamp(0.0, 1.0);
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
        // if (i % 5 == 0) {
        //   HapticFeedback.lightImpact();
        // }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
