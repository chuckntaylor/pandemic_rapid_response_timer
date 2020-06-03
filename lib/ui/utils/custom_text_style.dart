/*
 * Created by Chuck Taylor on 01/06/20 3:50 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 01/06/20 3:50 PM
 */

import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle buttonTextLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1.copyWith(
        color: Color.fromRGBO(
            255, 255, 255, 1.0),
        fontSize: 28,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
              offset: Offset(2, 3),
              blurRadius: 3.0,
              color: Color.fromRGBO(
                  50, 50, 50, 0.5))
        ]
    );
  }

  static TextStyle dialogButtonLabel() {
    return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.white
    );
  }
}
