/*
 * Created by Chuck Taylor on 19/05/20 11:01 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 19/05/20 11:01 AM
 */

import 'package:flutter/material.dart';
import 'package:pandemic_timer/business_logic/models/difficulty.dart';

class GameState extends ChangeNotifier {
  int _cardsInPlay = 0;

  int get cardsInPlay => _cardsInPlay;

  int _cardsInDeck = 0;

  int get cardsInDeck => _cardsInDeck;

  int _totalCities;
  int get totalCities => _totalCities;

  final int _maxTimeTokens = 9;

  int _timeTokensRemaining = 1;

  int get timeTokensRemaining => _timeTokensRemaining;

  int secondsRemaining = 120;

  void initNewGame({Difficulty difficulty}) {
    switch (difficulty) {
      case Difficulty.EASY:
        _cardsInPlay = 2;
        _cardsInDeck = 3;
        break;

      case Difficulty.NORMAL:
        _cardsInPlay = 2;
        _cardsInDeck = 5;
        break;

      case Difficulty.VETERAN:
        _cardsInPlay = 3;
        _cardsInDeck = 7;
        break;

      case Difficulty.HEROIC:
        _cardsInPlay = 4;
        _cardsInDeck = 9;
        break;
    }

    _totalCities = _cardsInPlay + _cardsInDeck;
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

}
