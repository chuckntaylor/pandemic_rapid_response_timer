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
  double time = 0.0;


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
    _flip.apply(0, artboard, 1.0);
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
  }

}

String _getTimerAnimation(TimerAnimation timerAnimation) {
  switch (timerAnimation) {
    case TimerAnimation.FLIP:
      return 'timerFlip';
    case TimerAnimation.RUN:
      return 'timerRun';
  }
}

enum TimerAnimation {
  FLIP,
  RUN
}
