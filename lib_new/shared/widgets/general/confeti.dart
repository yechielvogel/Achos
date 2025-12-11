import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../types/dtos/categories.dart';
import '../../../types/dtos/hachlata.dart';
import '../../../types/dtos/hachlata_completed.dart';

class ConfettiPiece {
  double x;
  double y;
  double size;
  double speed;
  Color color;
  bool isLanded;
  double targetY;

  ConfettiPiece({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
    required this.targetY,
    this.isLanded = false,
  });
}

class ConfettiLayer extends StatefulWidget {
  const ConfettiLayer({super.key});

  @override
  State<ConfettiLayer> createState() => ConfettiLayerState();
}

class ConfettiLayerState extends State<ConfettiLayer>
    with SingleTickerProviderStateMixin {
  final List<ConfettiPiece> _pieces = [];
  late final Ticker _ticker;
  final Random _rnd = Random();

  double _pileHeight = 0;
  final double _layerThickness = 6;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((_) {
      setState(() {
        for (final p in _pieces) {
          if (p.isLanded) continue;

          p.y += p.speed;

          if (p.y >= p.targetY) {
            p.y = p.targetY;
            p.isLanded = true;
          }
        }
      });
    })
      ..start();
  }

  void setPileFromCompleted(
    List<HachlataCompleted> completed,
    List<Hachlata> hachlatas,
    List<Category> categories,
  ) {
    setState(() {
      _pieces.clear();

      final width = context.size?.width ?? 300;
      final height = context.size?.height ?? 600;

      double currentPileY = height;

      for (final item in completed) {
        currentPileY -= _layerThickness;

        Color color = Colors.grey.shade400;

        try {
          final hachlata = hachlatas.firstWhere((h) => h.id == item.hachlata);
          final category =
              categories.firstWhere((c) => c.id == hachlata.category);

          if (category.color.isNotEmpty) {
            color = Color(int.parse(category.color));
          }
        } catch (_) {}

        for (int i = 0; i < 25; i++) {
          _pieces.add(
            ConfettiPiece(
              x: _rnd.nextDouble() * width,
              y: currentPileY,
              size: 6 + _rnd.nextDouble() * 6,
              speed: 0,
              color: color,
              targetY: currentPileY,
              isLanded: true,
            ),
          );
        }
      }

      _pileHeight = completed.length * _layerThickness;
    });
  }

  void shoot(Color color) {
    final width = context.size?.width ?? 300;
    final height = context.size?.height ?? 600;

    for (int i = 0; i < 25; i++) {
      final targetY = height - _pileHeight;

      _pieces.add(
        ConfettiPiece(
          x: _rnd.nextDouble() * width,
          y: 0,
          size: 6 + _rnd.nextDouble() * 6,
          speed: 2 + _rnd.nextDouble() * 3,
          color: color,
          targetY: targetY,
        ),
      );
    }

    _pileHeight += _layerThickness;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ConfettiPainter(_pieces),
      size: Size.infinite,
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<ConfettiPiece> pieces;

  _ConfettiPainter(this.pieces);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final p in pieces) {
      paint.color = p.color;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(p.x, p.y),
          width: p.size,
          height: p.size,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
