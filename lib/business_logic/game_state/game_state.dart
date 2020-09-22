/*
 * Created by Chuck Taylor on 19/05/20 11:01 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 19/05/20 11:01 AM
 */

import 'package:flutter/material.dart';
import 'package:pandemic_timer/business_logic/models/difficulty.dart';

class GameState extends ChangeNotifier {
  // game saving properties
  bool savedGame = false;
  int currentTime = 120;
  double timerAnimationCurrentTime = 0;
  int musicPlayHeadPosition = 0;

  // Defaults
  static const int _defaultStartingTimeTokens = 3;
  static const int _defaultTimerLength = 1200;

  int _cardsInPlay = 0;

  int get cardsInPlay => _cardsInPlay;

  int _cardsInDeck = 0;

  int get cardsInDeck => _cardsInDeck;

  final int _maxTimeTokens = 9;

  int _timeTokensRemaining;

  int get timeTokensRemaining => _timeTokensRemaining;

  int secondsRemaining;

  void initNewGame({Difficulty difficulty}) {
    switch (difficulty) {
      case Difficulty.EASY:
        _cardsInPlay = 2;
        _cardsInDeck = 3;
        currentTime = _defaultTimerLength;
        timerAnimationCurrentTime = 0;
        musicPlayHeadPosition = 0;
        _timeTokensRemaining = _defaultStartingTimeTokens;
        break;

      case Difficulty.NORMAL:
        _cardsInPlay = 2;
        _cardsInDeck = 5;
        currentTime = _defaultTimerLength;
        timerAnimationCurrentTime = 0;
        musicPlayHeadPosition = 0;
        _timeTokensRemaining = _defaultStartingTimeTokens;
        break;

      case Difficulty.VETERAN:
        _cardsInPlay = 3;
        _cardsInDeck = 7;
        currentTime = _defaultTimerLength;
        timerAnimationCurrentTime = 0;
        musicPlayHeadPosition = 0;
        _timeTokensRemaining = _defaultStartingTimeTokens;
        break;

      case Difficulty.HEROIC:
        _cardsInPlay = 4;
        _cardsInDeck = 9;
        currentTime = _defaultTimerLength;
        timerAnimationCurrentTime = 0;
        musicPlayHeadPosition = 0;
        _timeTokensRemaining = _defaultStartingTimeTokens;
        break;

      case Difficulty.RESUME:
        break;
    }
  }

  void resolveCity() {
    if (_cardsInPlay > 0) {
      _cardsInPlay--;
      _addTimeToken();
      notifyListeners();
    }
  }

  void removeToken() {
    if (_timeTokensRemaining == 0) {
      // game lost
    } else {
      _timeTokensRemaining--;
      _addCardInPlay();
      notifyListeners();
    }
  }

  void _addCardInPlay() {
    if (_cardsInDeck > 0) {
      _cardsInDeck--;
      _cardsInPlay++;
    }
  }

  void _addTimeToken() {
    if (_timeTokensRemaining < _maxTimeTokens) {
      _timeTokensRemaining++;
    }
  }

  void setCardsInPlay(int newCardCount) {
    if (newCardCount >= 0 && newCardCount <= 9) {
      _cardsInPlay = newCardCount;
      notifyListeners();
    }
  }

  void setCardsInDeck(int newCardCount) {
    if (newCardCount >= 0 && newCardCount <= 9) {
      _cardsInDeck = newCardCount;
      notifyListeners();
    }
  }

  @override
  // need to keep singleton alive. cannot make a new one.
  // ignore: must_call_super
  void dispose() {}
}
