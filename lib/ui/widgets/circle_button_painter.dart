/*
 * Created by Chuck Taylor on 04/06/20 10:30 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 04/06/20 10:30 AM
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pandemic_timer/ui/utils/color_shades.dart';

class CircleButtonPainter extends CustomPainter {

  CircleButtonPainter({@required this.color, double borderWidth, double elevation, Color shadowColor}) {
    _borderWidth = borderWidth == null ? 9 : borderWidth;
    _elevation = elevation == null ? 4 : elevation;
    _shadowColor = shadowColor == null ? Colors.transparent : shadowColor;
  }

  final Color color;
  double _borderWidth;
  double _elevation;
  Color _shadowColor;

  @override
  void paint(Canvas canvas, Size size) {

    // dimensions
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double fullRadius = min<double>(size.width / 2, size.height / 2);
    final double _metalOuterBorderWidth = _borderWidth * 0.45;
    final double _metalInnerBorderWidth = _borderWidth * 0.65;

    // colors
    Color _metalGreyColor = Color.fromRGBO(170, 177, 185, 1.0);
    
    // gradients
    final Gradient _metalRingOuterGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Colors.white,
        _metalGreyColor
      ],
      stops: [0.0, 1.0]
    );

    final Gradient _metalRingInnerGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          _metalGreyColor,
          Colors.white
        ],
        stops: [0.0, 1.0]
    );

    final Gradient _mainColorOuterGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: <Color>[
        color,
        color.darker(90)
      ],
      stops: [0.0, 1.0]
    );

    final Gradient _mainColorInnerGradient = RadialGradient(
      center: Alignment.center,
      colors: <Color>[
        color,
        color.darker(70)
      ],
      stops: [0.0, 1.0]
    );

    final Gradient _glossGradient = RadialGradient(
        center: Alignment.center,
        colors: <Color>[
          color.withOpacity(0.35),
          color.darker(70).withOpacity(0.35)
        ],
        stops: [0.0, 1.0]
    );

    // paints
    final Paint _metalRingOuterPaint = Paint()..shader = _metalRingOuterGradient.createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: fullRadius));
    final Paint _metalRingInnerPaint = Paint()..shader = _metalRingInnerGradient.createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: fullRadius - _metalOuterBorderWidth));
    final Paint _mainColorOuterPaint = Paint()..shader = _mainColorOuterGradient.createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: fullRadius - _metalInnerBorderWidth));
    final Paint _mainColorInnerPaint = Paint()..shader = _mainColorInnerGradient.createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: fullRadius));
    final Paint _glossPaint = Paint()..shader = _glossGradient.createShader(Rect.fromCircle(center: Offset(centerX, centerY ), radius: fullRadius));
    _glossPaint.blendMode = BlendMode.multiply;

    // paths
    Path _shadowPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(centerX, centerY), radius: fullRadius));
    Path _glossClipPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(centerX, centerY), radius: fullRadius - _borderWidth));
    Path _glossPath = Path()
      ..moveTo(_borderWidth, size.height * 0.65)
      ..quadraticBezierTo(size.width * 0.6, size.height * 0.8, size.width - _borderWidth, size.height * 0.35)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawShadow(_shadowPath, _shadowColor, _elevation, false);
    canvas.drawCircle(Offset(centerX, centerY), fullRadius, _metalRingOuterPaint);
    canvas.drawCircle(Offset(centerX, centerY), fullRadius - _metalOuterBorderWidth, _metalRingInnerPaint);
    canvas.drawCircle(Offset(centerX, centerY), fullRadius - _metalInnerBorderWidth, _mainColorOuterPaint);
    canvas.drawCircle(Offset(centerX, centerY), fullRadius - _borderWidth, _mainColorInnerPaint);
    canvas.clipPath(_glossClipPath, doAntiAlias: true);
    canvas.drawPath(_glossPath, _glossPaint);
  }

  @override
  bool shouldRepaint(CircleButtonPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}