/*
 * Created by Chuck Taylor on 12/06/20 9:24 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 12/06/20 9:24 AM
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:pandemic_timer/business_logic/game_state/game_state.dart';
import 'package:pandemic_timer/business_logic/models/difficulty.dart';
import 'package:pandemic_timer/services/service_locator.dart';

void main() {

  setupServiceLocator();
  final GameState gameState = serviceLocator<GameState>();

  // create a new 'Normal' Game
  gameState.initNewGame(difficulty: Difficulty.NORMAL);

  group('GameState - Intialize \'Normal\' game', () {
    test('Time tokens should start at 3', () {
      expect(gameState.timeTokensRemaining, 3);
    });

    test('Cards in deck should start at 5', () {
      expect(gameState.cardsInDeck, 5);
    });

    test('Cards in play should be 2', () {
      expect(gameState.cardsInPlay, 2);
    });
  });

  group('GameState methods', () {
    test('Resolve city removes a card in play and adds time token', () {
      gameState.resolveCity();
      expect(gameState.cardsInPlay, 1);
      expect(gameState.cardsInDeck, 5);
      expect(gameState.timeTokensRemaining, 4);
    });

    test('Time token is removed and new card is put into play', () {
      gameState.removeToken();
      expect(gameState.timeTokensRemaining, 3);
      expect(gameState.cardsInDeck, 4);
      expect(gameState.cardsInPlay, 2);
    });

    test('Setting cards in play directly to 3', () {
      gameState.setCardsInPlay(3);
      expect(gameState.cardsInPlay, 3);
    });

    test('Not possible to set cards in play to negative value', () {
      gameState.setCardsInPlay(-3);
      expect(gameState.cardsInPlay, 3);
    });

    test('Setting cards in deck directly to 2', () {
      gameState.setCardsInDeck(2);
      expect(gameState.cardsInDeck, 2);
    });

    test('Not possible to set cards in deck to negative value', () {
      gameState.setCardsInDeck(-3);
      expect(gameState.cardsInDeck, 2);
    });

    test('Not possible to remove time tokens below 0', () {
      gameState.removeToken();
      gameState.removeToken();
      gameState.removeToken();
      gameState.removeToken();
      gameState.removeToken();
      expect(gameState.timeTokensRemaining, 0);
    });

    test('Cards in deck should be 0', () {
      expect(gameState.cardsInDeck, 0);
    });
  });

}