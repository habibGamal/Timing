import 'dart:math' as math;
import 'package:ecommerce/colors.dart';
import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final double _x;
  ClockPainter(this._x);
  @override
  paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = MyColors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    canvas.drawArc(const Rect.fromLTRB(0, 0, 200, 200), 0,
        (2 * math.pi) - (2 * math.pi / 100) * _x, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter customPainter) {
    return true;
  }
}
