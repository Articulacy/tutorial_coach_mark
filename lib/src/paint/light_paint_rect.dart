import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/src/target/target_position.dart';

class LightPaintRect extends CustomPainter {
  final double progress;
  final TargetPosition target;
  final Color colorShadow;
  final double opacityShadow;
  final double offset;
  final double radius;

  LightPaintRect({
    required this.progress,
    required this.target,
    this.colorShadow = Colors.black,
    this.opacityShadow = 0.8,
    this.offset = 10,
    this.radius = 10,
  }) : assert(opacityShadow >= 0 && opacityShadow <= 1);

  static Path _drawRectHole(
    Size canvasSize,
    double x,
    double y,
    double w,
    double h,
  ) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(0, y)
      ..lineTo(x + w, y)
      ..lineTo(x + w, y + h)
      ..lineTo(x, y + h)
      ..lineTo(x, y)
      ..lineTo(0, y)
      ..lineTo(0, canvasSize.height)
      ..lineTo(canvasSize.width, canvasSize.height)
      ..lineTo(canvasSize.width, 0)
      ..close();
  }

  static Path _drawRRectHole(
    Size canvasSize,
    double x,
    double y,
    double w,
    double h,
    double radius,
  ) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(0, y + radius / 2)
      ..arcTo(
        Rect.fromLTWH(x, y, radius, radius),
        pi,
        pi / 2,
        false,
      )
      ..arcTo(
        Rect.fromLTWH(x + w - radius, y, radius, radius),
        3 * pi / 2,
        pi / 2,
        false,
      )
      ..arcTo(
        Rect.fromLTWH(x + w - radius, y + h - radius, radius, radius),
        0,
        pi / 2,
        false,
      )
      ..arcTo(
        Rect.fromLTWH(x, y + h - radius, radius, radius),
        pi / 2,
        pi / 2,
        false,
      )
      ..lineTo(x, y + radius / 2)
      ..lineTo(0, y + radius / 2)
      ..lineTo(0, canvasSize.height)
      ..lineTo(canvasSize.width, canvasSize.height)
      ..lineTo(canvasSize.width, 0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (target.offset == Offset.zero) return;

    var maxSize = max(size.width, size.height) +
        max(target.size.width, target.size.height);

    double x = -maxSize / 2 * (1 - progress) + target.offset.dx - offset / 2;

    double y = -maxSize / 2 * (1 - progress) + target.offset.dy - offset / 2;

    double w = maxSize * (1 - progress) + target.size.width + offset;

    double h = maxSize * (1 - progress) + target.size.height + offset;

    canvas.drawPath(
      radius > 0
          ? _drawRRectHole(size, x, y, w, h, radius)
          : _drawRectHole(size, x, y, w, h),
      Paint()
        ..style = PaintingStyle.fill
        ..color = colorShadow.withOpacity(opacityShadow),
    );
  }

  @override
  bool shouldRepaint(LightPaintRect oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
