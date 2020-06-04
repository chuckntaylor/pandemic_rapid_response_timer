/*
 * Created by Chuck Taylor on 19/05/20 9:47 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 19/05/20 9:47 PM
 */

import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';

class TimerAnimationController extends FlareController {

  bool play;

  TimerAnimationController({this.play});

  ActorAnimation _flip;
  ActorAnimation _run;
  FlutterActorArtboard _artboard;
  double time = 0.0;

  void reset() {
    time = 0;
    play = false;
    _flip.apply(time, _artboard, 1.0);
  }


  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (play) {
      time = time + elapsed;
      if (time < _flip.duration) {
        _flip.apply(time, artboard, 1.0);
      } else {
        _flip.apply(0, artboard, 1.0);
        _run.apply(time - _flip.duration, artboard, 1.0);
      }
    } else {
      return true;
    }
    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    // provide reference to the animation components the will be affected by this controller
    _flip = artboard.getAnimation(_getTimerAnimation(TimerAnimation.FLIP));
    _run = artboard.getAnimation(_getTimerAnimation(TimerAnimation.RUN));
    _artboard = artboard;
    _flip.apply(0, artboard, 1.0);
    _setTimerPlayhead();
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
  }



  void _setTimerPlayhead() {
    if (time > 0) {
      _flip.apply(0, _artboard, 1.0);
      _run.apply(time, _artboard, 1.0);
    }
  }

}

String _getTimerAnimation(TimerAnimation timerAnimation) {
  switch (timerAnimation) {
    case TimerAnimation.FLIP:
      {
        return 'timerFlip';
      }
      break;
    case TimerAnimation.RUN:
      {
        return 'timerRun';
      }
      break;
    default: {
      FormatException('_getTimerAnimation was called without a suitable TimerAnimation value. Function called with: $timerAnimation');
      return '';
    }
      break;
  }
}

enum TimerAnimation {
  FLIP,
  RUN
}
