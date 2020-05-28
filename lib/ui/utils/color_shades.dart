/*
 * Created by Chuck Taylor on 27/05/20 8:20 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 27/05/20 8:20 PM
 */

import 'dart:ui';

extension ColorShades on Color {
  Color darker(int darkness) {
    int r = (red - darkness).clamp(0, 255);
    int g = (green - darkness).clamp(0, 255);
    int b = (blue - darkness).clamp(0, 255);
    return Color.fromRGBO(r, g, b, 1);
  }

  Color lighter(int lightness) {
    int r = (red + lightness).clamp(0, 255);
    int g = (green + lightness).clamp(0, 255);
    int b = (blue + lightness).clamp(0, 255);
    return Color.fromRGBO(r, g, b, 1);
  }
}