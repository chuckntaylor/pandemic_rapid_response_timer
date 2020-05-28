/*
 * Created by Chuck Taylor on 19/05/20 10:13 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 19/05/20 10:13 AM
 */

import 'package:flare_flutter/flare_actor.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pandemic_timer/business_logic/view_models/timer_screen_viewmodel.dart';
import 'package:pandemic_timer/services/service_locator.dart';
import 'package:pandemic_timer/ui/utils/dialog_helper.dart';
import 'package:pandemic_timer/ui/utils/timer_animation_controller.dart';
import 'package:pandemic_timer/ui/utils/token_animation_controller.dart';
import 'package:pandemic_timer/ui/widgets/custom_button.dart';
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

  int _counter = 120;
  String _timeDisplay = '2:00';
  Timer _timer;

  /// Colors and Styles
  final Color _startBtnColor = Color.fromRGBO(105, 194, 76, 1.0);
  final Color _resolveBtnColor = Color.fromRGBO(53, 162, 189, 1.0);

  @override
  void initState() {
    _tokenController = TokenAnimationController(
        tokenCount: gameStateModel.timeTokensRemaining);
    super.initState();
  }

  void _startTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timerController.play = false;
    } else {
      _timerController.play = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_counter > 0) {
            // continue countdown
            _counter--;
            _timeDisplay =
                '${_counter ~/ 60}:${(_counter % 60).toString().padLeft(2, '0')}';
          } else {
            // countdown complete
            _timer.cancel();
            _timerController.reset();
            // check if there are still city cards in deck
            // if so show alert to reset time and draw new card
            if (gameStateModel.cardsInDeck > 0) {
              DialogHelper.timerReset(
                  context: context,
                  callBack: () {
                    _removeToken();
                  });
            }
          }
        });
      });
    }
  }

  void _removeToken() async {
    if (gameStateModel.timeTokensRemaining == 0) {
      // game over man!
    } else {
      // remove a time token from the pool
      gameStateModel.removeToken();
      _tokenController.updateTokenCount(gameStateModel.timeTokensRemaining);
      // reset the sand timer animation and play it again.
      _timerController.reset();
      _timerController.play = true;
      setState(() {
        _counter = 120;
        _timeDisplay = '2:00';
      });
      // it takes the sand timer one second to turn over before the sand starts to fall.
      // delay the start of the countdown timer by one second.
      await new Future.delayed(const Duration(seconds: 1), () {
        _startTimer();
      });
    }
  }

  void _resolveCity() {
    if (_tokenController.idle == true) {
      gameStateModel.resolveCity();
      _tokenController.updateTokenCount(gameStateModel.timeTokensRemaining);
    }
  }

  double _getMargin(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.025;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameState>(
        create: (context) => gameStateModel,
        child: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/speakerGrill.png'),
                      fit: BoxFit.cover)),
              child: SafeArea(
                child: Consumer<GameState>(
                  builder: (context, gameState, child) {
                    return Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
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
                                      DialogHelper.timerReset(
                                          context: context,
                                          callBack: () {
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
                          Container(
                            height: 60,
                            child: FlareActor(
                              'assets/animations/timeTokens.flr',
                              controller: _tokenController,
                            ),
                          ),
                          Text(
                            _timeDisplay,
                            style: GoogleFonts.cutiveMono(
                                fontSize: 64,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: EdgeInsets.all(_getMargin(context)),
                            child: SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                  onPress: () {
                                    _startTimer();
                                  },
                                  color: _startBtnColor,
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                                      child: Text(
                                        'START',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1.0),
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                  offset: Offset(2, 3),
                                                  blurRadius: 3.0,
                                                  color: Color.fromRGBO(
                                                      50, 50, 50, 0.5))
                                            ]),
                                      ),
                                    ),
                                  )),
                            ),
                          ),

                          /// Resolve City Button
                          Container(
                            margin: EdgeInsets.all(_getMargin(context)),
                            child: SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                  onPress: () {
                                    if (gameState.cardsInDeck == 0) {
                                      return null;
                                    } else {
                                      _resolveCity();
                                    }
                                  },
                                  color: _resolveBtnColor,
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                                      child: Text(
                                        'RESOLVE CITY',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1.0),
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                  offset: Offset(2, 3),
                                                  blurRadius: 3.0,
                                                  color: Color.fromRGBO(
                                                      50, 50, 50, 0.5))
                                            ]),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          /// Bottom row of buttons
                          Container(
                            margin: EdgeInsets.all(_getMargin(context)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// City Cards In Play
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: CustomButton(
                                      onPress: () {
                                        print("Clicked");
                                      },
                                      child: Center(
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          padding: const EdgeInsets.all(8.0),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'City cards in play:',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 20,
                                                  thickness: 2,
                                                  color: Color.fromRGBO(255, 255, 255, 0.7),
                                                ),
                                                Text(gameState.cardsInPlay.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 32
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                                /// City Cards In Deck
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: CustomButton(
                                      onPress: () {
                                        print("Clicked 2");
                                      },
                                      child: Center(
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          padding: const EdgeInsets.all(8.0),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'City cards in deck:',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 20,
                                                  thickness: 2,
                                                  color: Color.fromRGBO(255, 255, 255, 0.7),
                                                ),
                                                Text(gameState.cardsInDeck.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      fontSize: 32
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
