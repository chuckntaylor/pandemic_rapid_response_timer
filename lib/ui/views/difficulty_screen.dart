/*
 * Created by Chuck Taylor on 12/05/20 9:01 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 12/05/20 8:42 PM
 */

import 'package:flutter/material.dart';
import 'package:pandemic_timer/services/service_locator.dart';
import 'package:pandemic_timer/ui/views/timer_screen.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';
import 'package:pandemic_timer/ui/widgets/difficulty_option_button.dart';
import 'package:pandemic_timer/business_logic/models/difficulty.dart';
import 'package:pandemic_timer/services/game_state/game_state.dart';

class DifficultySelectionScreen extends StatelessWidget {

  final GameState gameState = serviceLocator<GameState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DifficultyOptionButton(
                      title: Strings.of(context).easy,
                      iconName: 'easyPlane',
                      numCitiesPlaced: 2,
                      numCitiesInDeck: 3,
                      onPressed: () {
                        _navigateToTimer(context, difficulty: Difficulty.EASY);
                      },
                    ),
                    DifficultyOptionButton(
                      title: Strings.of(context).normal,
                      iconName: 'normalPlane',
                      numCitiesPlaced: 2,
                      numCitiesInDeck: 5,
                      onPressed: () {
                        _navigateToTimer(context, difficulty: Difficulty.NORMAL);
                      },
                    ),
                    DifficultyOptionButton(
                      title: Strings.of(context).veteran,
                      iconName: 'veteranPlane',
                      numCitiesPlaced: 3,
                      numCitiesInDeck: 7,
                      onPressed: () {
                        _navigateToTimer(context, difficulty: Difficulty.VETERAN);
                      },
                    ),
                    DifficultyOptionButton(
                      title: Strings.of(context).heroic,
                      iconName: 'heroicPlane',
                      numCitiesPlaced: 4,
                      numCitiesInDeck: 9,
                      onPressed: () {
                        _navigateToTimer(context, difficulty: Difficulty.HEROIC);
                      },
                    )
                  ],
                )
            ),
          ),
    );
  }

  void _navigateToTimer(BuildContext context, {Difficulty difficulty}) {
    gameState.initNewGame(difficulty: difficulty);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => TimerScreen()
    ));
  }
}
