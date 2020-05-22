/*
 * Created by Chuck Taylor on 21/05/20 10:09 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 21/05/20 10:09 AM
 */

import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';

class TokenAnimationController extends FlareController {

  bool idle;
  int _currentTokenCount;

  TokenAnimationController({this.idle = true, int tokenCount = 3}) {
    this._currentTokenCount = tokenCount;
  }

  FlutterActorArtboard _artboard;

  double time = 0.0;

  ActorAnimation _idle_0;
  ActorAnimation _idle_1;
  ActorAnimation _idle_2;
  ActorAnimation _idle_3;
  ActorAnimation _idle_4;
  ActorAnimation _idle_5;
  ActorAnimation _idle_6;
  ActorAnimation _idle_7;
  ActorAnimation _idle_8;
  ActorAnimation _idle_9;
  ActorAnimation _0_to_1;
  ActorAnimation _1_to_2;
  ActorAnimation _2_to_3;
  ActorAnimation _3_to_4;
  ActorAnimation _4_to_5;
  ActorAnimation _5_to_6;
  ActorAnimation _6_to_7;
  ActorAnimation _7_to_8;
  ActorAnimation _8_to_9;
  ActorAnimation _9_to_8;
  ActorAnimation _8_to_7;
  ActorAnimation _7_to_6;
  ActorAnimation _6_to_5;
  ActorAnimation _5_to_4;
  ActorAnimation _4_to_3;
  ActorAnimation _3_to_2;
  ActorAnimation _2_to_1;
  ActorAnimation _1_to_0;

  ActorAnimation _currentAnimation;

  void updateTokenCount(int newCount) {
    // check if an animation is in progress
    if (!idle) {
      // if so, apply the idle state first
      String idleName = '_idle_$_currentTokenCount';
      ActorAnimation idleAnimation = _getAnimation(idleName);
      idleAnimation.apply(0, _artboard, 1.0);
    }

    // continue to update the token count
    if (newCount != _currentTokenCount) {
      idle = false;
      String animationName = '_${_currentTokenCount}_to_$newCount';
      _currentAnimation = _getAnimation(animationName);
      _currentTokenCount = newCount;
    } else {
      // no change
      return;
    }
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (idle) {
      String animationName = '_idle_$_currentTokenCount';
      ActorAnimation animation = _getAnimation(animationName);
      animation.apply(0, artboard, 1.0);
      return true;
    } else {
      // advance time
      time = time + elapsed;
      // check if animation is complete
      if (_currentAnimation.duration > time ) {
        _currentAnimation.apply(time, artboard, 1.0);
      } else {
        // switch to idle
        time = 0;
        idle = true;
      }
      return true;
    } // if idle
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    // get reference to the artboard
    _artboard = artboard;
    // provide reference to the animation components the will be affected by this controller
    _idle_0 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.IDLE_0));
    _idle_1 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.IDLE_1));
    _idle_2 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.IDLE_2));
    _idle_3 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.IDLE_3));
    _idle_4 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.IDLE_4));
    _idle_5 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.IDLE_5));
    _idle_6 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.IDLE_6));
    _idle_7 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.IDLE_7));
    _idle_8 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.IDLE_8));
    _idle_9 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.IDLE_9));
    _0_to_1 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_0_TO_1));
    _1_to_2 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_1_TO_2));
    _2_to_3 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_2_TO_3));
    _3_to_4 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_3_TO_4));
    _4_to_5 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_4_TO_5));
    _5_to_6 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_5_TO_6));
    _6_to_7 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_6_TO_7));
    _7_to_8 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_7_TO_8));
    _8_to_9 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_8_TO_9));
    _9_to_8 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_9_TO_8));
    _8_to_7 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_8_TO_7));
    _7_to_6 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_7_TO_6));
    _6_to_5 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_6_TO_5));
    _5_to_4 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_5_TO_4));
    _4_to_3 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_4_TO_3));
    _3_to_2 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_3_TO_2));
    _2_to_1 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_2_TO_1));
    _1_to_0 = artboard.getAnimation(_getTokenAnimation(TokenAnimation.GO_1_TO_0));
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
  }

  ActorAnimation _getAnimation(String name) {
    switch(name) {
      case '_idle_0':
        return _idle_0;
      case '_idle_1':
        return _idle_1;
      case '_idle_2':
        return _idle_2;
      case '_idle_3':
        return _idle_3;
      case '_idle_4':
        return _idle_4;
      case '_idle_5':
        return _idle_5;
      case '_idle_6':
        return _idle_6;
      case '_idle_7':
        return _idle_7;
      case '_idle_8':
        return _idle_8;
      case '_idle_9':
        return _idle_9;
      case '_0_to_1':
        return _0_to_1;
      case '_1_to_2':
        return _1_to_2;
      case '_2_to_3':
        return _2_to_3;
      case '_3_to_4':
        return _3_to_4;
      case '_4_to_5':
        return _4_to_5;
      case '_5_to_6':
        return _5_to_6;
      case '_6_to_7':
        return _6_to_7;
      case '_7_to_8':
        return _7_to_8;
      case '_8_to_9':
        return _8_to_9;
      case '_9_to_8':
        return _9_to_8;
      case '_8_to_7':
        return _8_to_7;
      case '_7_to_6':
        return _7_to_6;
      case '_6_to_5':
        return _6_to_5;
      case '_5_to_4':
        return _5_to_4;
      case '_4_to_3':
        return _4_to_3;
      case '_3_to_2':
        return _3_to_2;
      case '_2_to_1':
        return _2_to_1;
      case '_1_to_0':
        return _1_to_0;
      default:
        return _idle_3;
    }
  }

  String _getTokenAnimation(TokenAnimation tokenAnimation) {
    switch (tokenAnimation) {
      case TokenAnimation.IDLE_0:
        return 'idle_0';
      case TokenAnimation.IDLE_1:
        return 'idle_1';
      case TokenAnimation.IDLE_2:
        return 'idle_2';
      case TokenAnimation.IDLE_3:
        return 'idle_3';
      case TokenAnimation.IDLE_4:
        return 'idle_4';
      case TokenAnimation.IDLE_5:
        return 'idle_5';
      case TokenAnimation.IDLE_6:
        return 'idle_6';
      case TokenAnimation.IDLE_7:
        return 'idle_7';
      case TokenAnimation.IDLE_8:
        return 'idle_8';
      case TokenAnimation.IDLE_9:
        return 'idle_9';
      case TokenAnimation.GO_0_TO_1:
        return '0_to_1';
      case TokenAnimation.GO_1_TO_2:
        return '1_to_2';
      case TokenAnimation.GO_2_TO_3:
        return '2_to_3';
      case TokenAnimation.GO_3_TO_4:
        return '3_to_4';
      case TokenAnimation.GO_4_TO_5:
        return '4_to_5';
      case TokenAnimation.GO_5_TO_6:
        return '5_to_6';
      case TokenAnimation.GO_6_TO_7:
        return '6_to_7';
      case TokenAnimation.GO_7_TO_8:
        return '7_to_8';
      case TokenAnimation.GO_8_TO_9:
        return '8_to_9';
      case TokenAnimation.GO_9_TO_8:
        return '9_to_8';
      case TokenAnimation.GO_8_TO_7:
        return '8_to_7';
      case TokenAnimation.GO_7_TO_6:
        return '7_to_6';
      case TokenAnimation.GO_6_TO_5:
        return '6_to_5';
      case TokenAnimation.GO_5_TO_4:
        return '5_to_4';
      case TokenAnimation.GO_4_TO_3:
        return '4_to_3';
      case TokenAnimation.GO_3_TO_2:
        return '3_to_2';
      case TokenAnimation.GO_2_TO_1:
        return '2_to_1';
      case TokenAnimation.GO_1_TO_0:
        return '1_to_0';
    }
  }

}

enum TokenAnimation {
  IDLE_0,
  IDLE_1,
  IDLE_2,
  IDLE_3,
  IDLE_4,
  IDLE_5,
  IDLE_6,
  IDLE_7,
  IDLE_8,
  IDLE_9,
  GO_0_TO_1,
  GO_1_TO_2,
  GO_2_TO_3,
  GO_3_TO_4,
  GO_4_TO_5,
  GO_5_TO_6,
  GO_6_TO_7,
  GO_7_TO_8,
  GO_8_TO_9,
  GO_9_TO_8,
  GO_8_TO_7,
  GO_7_TO_6,
  GO_6_TO_5,
  GO_5_TO_4,
  GO_4_TO_3,
  GO_3_TO_2,
  GO_2_TO_1,
  GO_1_TO_0,
}