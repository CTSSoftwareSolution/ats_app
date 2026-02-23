import 'dart:math';

import 'package:flutter/material.dart';

class LoaderPainter extends CustomPainter {
  final double progress;
  final int dotCount;
  final Color activeColor;
  final Color inactiveColor;

  LoaderPainter({
    required this.progress,
    required this.dotCount,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 18;
    final dotRadius = size.width / 80;

    for (int i = 0; i < dotCount; i++) {
      final angle = (2 * pi / dotCount) * i;
      final position = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      final activeIndex = (progress * dotCount).floor() % dotCount;
      final paint = Paint()
        ..color = i == activeIndex ? activeColor : inactiveColor
        ..strokeWidth = 1
        ..style = i == activeIndex ? PaintingStyle.fill : PaintingStyle.stroke;

      canvas.drawCircle(position, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant LoaderPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
