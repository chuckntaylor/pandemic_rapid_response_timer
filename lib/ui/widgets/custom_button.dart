/*
 * Created by Chuck Taylor on 27/05/20 3:31 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 27/05/20 3:31 PM
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pandemic_timer/ui/widgets/button_painter.dart';

class CustomButton extends StatelessWidget {

  final Color color;
  final Widget child;
  final Function onPress;
  static const Color _defaultGrey = Color.fromRGBO(89, 89, 89, 1.0);

  CustomButton({
    this.color = _defaultGrey,
    @required this.child,
    @required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            size: Size.infinite,
            painter: CustomButtonPainter(color: color),
          ),
        ),
        Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            SystemSound.play(SystemSoundType.click);
            onPress();
          },
          child: child,
        )
        )
      ],
    );
  }
}