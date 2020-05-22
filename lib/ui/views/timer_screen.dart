/*
 * Created by Chuck Taylor on 19/05/20 10:13 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 19/05/20 10:13 AM
 */

import 'package:flare_flutter/flare_actor.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pandemic_timer/business_logic/view_models/timer_screen_viewmodel.dart';
import 'package:pandemic_timer/services/service_locator.dart';
import 'package:pandemic_timer/ui/utils/dialog_helper.dart';
import 'package:pandemic_timer/ui/utils/timer_animation_controller.dart';
import 'package:pandemic_timer/ui/utils/token_animation_controller.dart';
import 'package:provider/provider.dart';
import 'package:pandemic_timer/services/game_state/game_state.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TimerScreenViewModel viewModel = serviceLocator<TimerScreenViewModel>();

  final TimerAnimationController _timerController =
      TimerAnimationController(play: false);
  
  final GameState gameStateModel = serviceLocator<GameState>();


  TokenAnimationController _tokenController;


  int _counter = 10;
  String _timeDisplay = '2:00';
  Timer _timer;


  @override
  void initState() {
    _tokenController = TokenAnimationController(tokenCount: gameStateModel.timeTokensRemaining);
    super.initState();
  }

  void _startTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_counter > 0) {
            // continue countdown
            _counter--;
            _timeDisplay = '${_counter ~/ 60}:${(_counter % 60).toString().padLeft(2, '0')}';
          } else {
            // countdown complete
            _timer.cancel();
            _removeToken();
          }
        });
      });
    }
  }

  void _removeToken() {
    if (gameStateModel.timeTokensRemaining == 0) {
      // game over man!
    } else {
      gameStateModel.removeToken();
      _tokenController.updateTokenCount(gameStateModel.timeTokensRemaining);
      setState(() {
        _counter = 10;
        _timeDisplay = '2:00';
      });
    }
  }


  void _resolveCity() {
    if (_tokenController.idle == true) {
      gameStateModel.resolveCity();
      _tokenController.updateTokenCount(gameStateModel.timeTokensRemaining);
    }
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<GameState>(
        create: (context) => gameStateModel,
        child: Scaffold(
          body: Container(
            color: Colors.black,
            child: SafeArea(
              child: Consumer<GameState>(
                builder: (context, gameState, child) {
                  return Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.pause_circle_outline),
                                  iconSize: 32,
                                  color: Colors.white,
                                  highlightColor: Color.fromARGB(0, 0, 0, 0),
                                  onPressed: () {
                                    DialogHelper.timerReset(context: context, callBack: () {
                                      print('clicked to resume');
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: FlareActor(
                                    'assets/animations/sandTimer.flr',
                                    controller: _timerController,
                                  ),
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  iconSize: 32,
                                  color: Colors.white,
                                  highlightColor: Color.fromARGB(0, 0, 0, 0),
                                  onPressed: () {
                                    print('Pause');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(_timeDisplay,
                        style: GoogleFonts.cutiveMono(
                          fontSize: 64,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: RaisedButton(
                            onPressed: () {
                              _startTimer();
                            },
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                            child: Text('START',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  fontSize: 36
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: RaisedButton(
                            onPressed: () {
                              if (gameState.cardsInDeck == 0) {
                                return null;
                              } else {
                                _resolveCity();
                              }
                            },
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                            child: Text('CITY\nRESOLVED',
                              textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    fontSize: 36
                                  ),
                              ),
                            ),
                          ),
                        Container(
                          height: 60,
                          child: FlareActor(
                            'assets/animations/timeTokens.flr',
                            controller: _tokenController,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'City cards in play: ${gameState.cardsInPlay}',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            Text(
                              'City cards in deck: ${gameState.cardsInDeck}',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}