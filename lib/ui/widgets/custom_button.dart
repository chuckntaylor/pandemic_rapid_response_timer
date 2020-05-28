/*
 * Created by Chuck Taylor on 27/05/20 3:31 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 27/05/20 3:31 PM
 */

import 'package:flutter/material.dart';
import 'package:pandemic_timer/ui/widgets/button_painter.dart';

class CustomButton extends StatelessWidget {

  final Color color;
  CustomButton({@required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: CustomButtonPainter(color: color),
    );
  }
}