/*
 * Created by Chuck Taylor on 04/06/20 10:32 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 04/06/20 10:32 AM
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pandemic_timer/ui/widgets/circle_button_painter.dart';

class CircleButton extends StatelessWidget {
  final Color color;
  final Widget child;
  final Function onPress;
  final double size;
  final double borderWidth;
  final double elevation;
  final Color shadowColor;
  static const Color _defaultGrey = Color.fromRGBO(89, 89, 89, 1.0);
  static const double _defaultSize = 64.0;

  CircleButton(
      {@required this.onPress,
      this.color = _defaultGrey,
      this.size = _defaultSize,
      this.child,
      this.borderWidth,
      this.shadowColor,
      this.elevation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
              child: CustomPaint(
            size: Size.infinite,
            painter: CircleButtonPainter(
                color: color,
                borderWidth: borderWidth,
                elevation: elevation,
                shadowColor: shadowColor),
          )),
          Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  SystemSound.play(SystemSoundType.click);
                  onPress();
                },
                child: Center(
                  child: child ?? Container(),
                ),
              ))
        ],
      ),
    );
  }
}
