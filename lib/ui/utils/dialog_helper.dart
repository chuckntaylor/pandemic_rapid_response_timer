/*
 * Created by Chuck Taylor on 22/05/20 10:38 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 22/05/20 10:38 AM
 */

import 'package:flutter/material.dart';
import 'package:pandemic_timer/ui/widgets/game_over_dialog.dart';
import 'package:pandemic_timer/ui/widgets/timer_reset_dialog.dart';

class DialogHelper {
  static timerReset({BuildContext context, Function callBack}) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return TimerResetDialog(callBack: callBack,);
        }
    );
  }

  static gameOver({BuildContext context, Function callBack}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
      builder: (context) {
          return GameOverDialog(callBack: callBack,);
      }
      ,);
  }
}