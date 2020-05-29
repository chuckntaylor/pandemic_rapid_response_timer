/*
 * Created by Chuck Taylor on 28/05/20 10:23 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 28/05/20 10:23 PM
 */

import 'package:flutter/material.dart';
import 'package:pandemic_timer/ui/utils/color_shades.dart';

class CityCountDialogPainter extends CustomPainter {

  final Color color = Colors.blue;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint _mainPaint = Paint()
      ..color = color;
    final Paint _highlightPaint = Paint()
      ..color = color.lighter(40);
    final Paint _shadowPaint = Paint()
      ..color = color.darker(50).withOpacity(0.8);
    final Paint _glossPaint = Paint()
      ..color = color.darker(15);

    final highlightThickness = 4;

    // highlight RRect
    canvas.drawRRect(RRect.fromLTRBR(
        0, 0, size.width, size.height - highlightThickness,
        Radius.circular(10)), _highlightPaint);
    // shadow RRect
    canvas.drawRRect(RRect.fromLTRBR(
        0, (0 + highlightThickness).toDouble(), size.width, size.height,
        Radius.circular(10)), _shadowPaint);
    // main RRect
    canvas.drawRRect(RRect.fromLTRBR(
        0, (0 + highlightThickness).toDouble(), size.width,
        size.height - highlightThickness, Radius.circular(10)), _mainPaint);

    // create path for the filled in curve (gloss)
    final curvePath = Path()
      ..moveTo(-20, (size.height - 4))
      ..quadraticBezierTo(size.width - 40, size.height, size.width - 10, 0)
      ..lineTo(size.width, 0)..lineTo(size.width, size.height)..lineTo(
          0, size.height)
      ..close();
    // clip path that matches the main part of the button.
    canvas.clipRRect(RRect.fromLTRBR(
        0, (0 + highlightThickness).toDouble(), size.width,
        size.height - highlightThickness, Radius.circular(10)));
    // draw the path.
    canvas.drawPath(curvePath, _glossPaint);
  }

  @override
  bool shouldRepaint(CityCountDialogPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}