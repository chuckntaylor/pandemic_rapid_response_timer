/*
 * Created by Chuck Taylor on 19/05/20 10:14 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 19/05/20 10:14 AM
 */

import 'package:flutter/material.dart';

class TimerScreenViewModel extends ChangeNotifier {

  bool _isPaused = true;

  void startTimer() {
    _isPaused = false;
  }

  void pauseTimer() {
    _isPaused = true;
  }
}