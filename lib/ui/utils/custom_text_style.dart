/*
 * Created by Chuck Taylor on 01/06/20 3:50 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 01/06/20 3:50 PM
 */

import 'package:flutter/material.dart';

class CustomTextStyle {

  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1.copyWith(
      color: Colors.white
    );
  }

  static TextStyle headingWithShadow(BuildContext context) {
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

  static TextStyle dialogBody(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1.copyWith(
      color: Colors.black,
      fontSize: 14
    );
  }

  static TextStyle htmlLink() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
      color: Colors.amber,
    );
  }

  static TextStyle timer() {
    return TextStyle(
      fontSize: 64,
      color: Colors.yellow,
      fontWeight: FontWeight.w300,
      fontFamily: 'Operator Mono',
    );
  }
}
