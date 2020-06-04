/*
 * Created by Chuck Taylor on 19/05/20 10:13 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 19/05/20 10:13 AM
 */

import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pandemic_timer/services/service_locator.dart';
import 'package:pandemic_timer/ui/utils/custom_text_style.dart';
import 'package:pandemic_timer/ui/utils/dialog_helper.dart';
import 'package:pandemic_timer/ui/utils/timer_animation_controller.dart';
import 'package:pandemic_timer/ui/utils/token_animation_controller.dart';
import 'package:pandemic_timer/ui/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:pandemic_timer/business_logic/game_state/game_state.dart';
import 'package:after_layout/after_layout.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with AfterLayoutMixin<TimerScreen>, WidgetsBindingObserver {
  /// Properties
  // Model
  final GameState gameStateModel = serviceLocator<GameState>();

  // SharedPrefences
  SharedPreferences prefs;
  static const String _prefsMusicEnabled = 'musicEnabled';

  // Flare (Rive) Animaton Controllers
  TimerAnimationController _timerController;

  TokenAnimationController _tokenController;

  // audio players
  final _assetsSFXAudioPlayer = AssetsAudioPlayer();
  final _musicAudioPlayer = AssetsAudioPlayer();

  // Timer props
  int _counter;
  String _timeDisplay;
  Timer _timer;

  // toggles
  bool _musicEnabled = true;
  bool _shouldResume = false;
  String _startBtnText = 'START';

  /// Colors and Styles
  final Color _startBtnColor = Color.fromRGBO(105, 194, 76, 1.0);
  final Color _resolveBtnColor = Color.fromRGBO(53, 162, 189, 1.0);

  @override
  void initState() {
    super.initState();
    // add observer to get app lifecycle
    WidgetsBinding.instance.addObserver(this);

    _timerController = TimerAnimationController(play: false);
    _tokenController = TokenAnimationController(
        tokenCount: gameStateModel.timeTokensRemaining);
    _counter = gameStateModel.currentTime;
    _timeDisplay =
        '${_counter ~/ 60}:${(_counter % 60).toString().padLeft(2, '0')}';
    // load alarm sound into player
    _assetsSFXAudioPlayer.open(Audio('assets/audio/chime.mp3'),
        autoStart: false);
    // load SharedPreferences
    _loadMusicPrefs();
    // Keep the device awake on this screen
    Wakelock.enable();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        {
          if (_timer != null && _timer.isActive) {
            _shouldResume = true;
          } else {
            _shouldResume = false;
          }
          _startTimer();
          break;
        }
      case AppLifecycleState.resumed:
        {
          if (_shouldResume) {
            _startTimer();
          }
          _shouldResume = false;
          break;
        }
      default:
        break;
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _timerController.time = gameStateModel.timerAnimationCurrentTime;
    _timerController.setTimerPlayhead();
  }

  @override
  void dispose() {
    _assetsSFXAudioPlayer.dispose();
    _musicAudioPlayer.dispose();
    Wakelock.disable();
    // remove app state lifecycle observing
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _loadMusicPrefs() async {
    // get SharedPreferences
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    // set _musicEnabled to value from SharedPreferences
    setState(() {
      _musicEnabled = prefs.getBool(_prefsMusicEnabled) ?? true;
    });

    // open the music, and set the audio to the preference and move playhead to correct point.
    _musicAudioPlayer.open(Audio('assets/audio/ambientSoundtrack.mp3'),
        autoStart: false,
        volume: _musicEnabled ? 0.5 : 0.0,
        seek: Duration(seconds: gameStateModel.musicPlayHeadPosition));
  }

  void _startTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timerController.play = false;
      _musicAudioPlayer.pause();
      setState(() {
        _startBtnText = 'START';
      });
    } else {
      _timerController.play = true;
      _musicAudioPlayer.play();
      setState(() {
        _startBtnText = 'PAUSE';
      });
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
            _musicAudioPlayer.seek(Duration(seconds: 0));
            _musicAudioPlayer.pause();
            // check if there is still any time tokens remaining
            if (gameStateModel.timeTokensRemaining > 0) {
              // play alarm sound
              _assetsSFXAudioPlayer.play();
              // show timerReset Dialog
              DialogHelper.timerReset(context, callBack: () {
                _removeToken();
              });
            } else {
              // play a game end sound
              _assetsSFXAudioPlayer.open(Audio('assets/audio/drama.mp3'));
              // show gameOver Dialog
              DialogHelper.gameOver(context, callBack: () {
                _exit();
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
      // check if victory conditions are met
      if (gameStateModel.cardsInPlay == 0 && gameStateModel.cardsInDeck == 0) {
        // WIN!!
        // stop timer
        if (_timer != null && _timer.isActive) {
          _startTimer();
        }
        // play victory audio
        _assetsSFXAudioPlayer.open(Audio('assets/audio/chimesGlassy.mp3'));
        // show dialog
        DialogHelper.gameVictory(context, callBack: () {
          _exit();
        });
      }
    }
  }

  void _saveAndExit() async {
    gameStateModel.savedGame = true;
    if (_timer != null && _timer.isActive) {
      _startTimer();
    }
    gameStateModel.currentTime = _counter;
    gameStateModel.timerAnimationCurrentTime = _timerController.time;
    gameStateModel.musicPlayHeadPosition =
        _musicAudioPlayer.currentPosition.value.inSeconds;
    Navigator.of(context).pop();
  }

  void _exit() {
    gameStateModel.savedGame = false;
    if (_timer != null) {
      _timer.cancel();
    }
    Navigator.of(context).pop();
  }

  void _toggleMusic() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    setState(() {
      _musicEnabled = !_musicEnabled;
      _musicAudioPlayer.setVolume(_musicEnabled ? 0.5 : 0.0);
      prefs.setBool(_prefsMusicEnabled, _musicEnabled);
    });
  }

  Future<bool> _onAndroidBackPressed() {
    bool _shouldResume = false;
    if (_timer != null && _timer.isActive) {
      _startTimer();
      _shouldResume = true;
    }
    DialogHelper.exitConfirmation(context, onConfirm: () {
      _saveAndExit();
    }, onCancel: () {
      if (_shouldResume) {
        _startTimer();
      }
    });

    Completer completer = Completer<bool>();
    completer.complete(false);
    return completer.future;
  }

  double _getMargin(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.025;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameState>(
        create: (context) => gameStateModel,
        child: WillPopScope(
          onWillPop: () => _onAndroidBackPressed(),
          child: Scaffold(
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: MediaQuery.of(context).orientation == Orientation.portrait
                          ? AssetImage('assets/images/speakerGrillPortrait.png')
                          : AssetImage('assets/images/speakerGrillLandscape.png'),
                        fit: BoxFit.cover)),
                child: SafeArea(
                  child: Consumer<GameState>(
                    builder: (context, gameState, child) {
                      return OrientationBuilder(
                        builder: (context, orientation) {
                          return orientation == Orientation.portrait
                              ? _portraitLayout(gameState)
                              : _landscapeLayout(gameState);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _portraitLayout(GameState gameState) {
    return Container(
      child: Column(
        children: [
          /** Top Spacer */
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /** Spacer */
                Container(
                  child: IconButton(
                    icon: _musicEnabled
                        ? Icon(Icons.volume_up)
                        : Icon(Icons.volume_off),
                    iconSize: 32,
                    color: Colors.white,
                    highlightColor: Color.fromARGB(0, 0, 0, 0),
                    onPressed: () {
                      SystemSound.play(SystemSoundType.click);
                      _toggleMusic();
                    },
                  ),
                ),
                /** Sand Timer */
                Expanded(
                  child: Container(
                    child: FlareActor(
                      'assets/animations/sandTimer.flr',
                      controller: _timerController,
                    ),
                  ),
                ),
                /** Exit Button */
                Container(
                  child: IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 32,
                    color: Colors.white,
                    highlightColor: Color.fromARGB(0, 0, 0, 0),
                    onPressed: () {
                      // pause timer if running and flag if resume is needed.
                      bool _shouldResume = false;
                      if (_timer != null && _timer.isActive) {
                        _startTimer();
                        _shouldResume = true;
                      }
                      DialogHelper.exitConfirmation(context, onConfirm: () {
                        _saveAndExit();
                      }, onCancel: () {
                        if (_shouldResume) {
                          _startTimer();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          /** Time Tokens */
          Container(
            height: 60,
            child: FlareActor(
              'assets/animations/timeTokens.flr',
              controller: _tokenController,
            ),
          ),
          /** Time Display */
          Text(
            _timeDisplay,
            style: TextStyle(
              fontSize: 64,
              color: Colors.yellow,
              fontWeight: FontWeight.w300,
              fontFamily: 'Operator Mono',
            ),
          ),

          /** Start/Pause Button */
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 20.0),
                      child: Text(
                        _startBtnText,
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.buttonTextLarge(context),
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
                    _resolveCity();
                  },
                  color: _resolveBtnColor,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 20.0),
                      child: Text(
                        'RESOLVE CITY',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.buttonTextLarge(context),
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
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: CustomButton(
                      onPress: () {
                        // pause timer if running and flag if resume is needed.
                        bool _shouldResume = false;
                        if (_timer != null && _timer.isActive) {
                          _startTimer();
                          _shouldResume = true;
                        }
                        DialogHelper.cityCardCount(
                          context,
                          cardCount: gameState.cardsInPlay,
                          title: 'City cards\nin play',
                          onComplete: (int newCardCount) {
                            Navigator.of(context).pop();
                            gameStateModel.setCardsInPlay(newCardCount);
                            if (_shouldResume) {
                              _startTimer();
                            }
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                            if (_shouldResume) {
                              _startTimer();
                            }
                          },
                        );
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
                                        shadows: [
                                          Shadow(
                                              offset: Offset(2, 3),
                                              blurRadius: 3.0,
                                              color:
                                                  Color.fromRGBO(50, 50, 50, 1))
                                        ]),
                                  ),
                                ),
                                VerticalDivider(
                                  width: 20,
                                  thickness: 2,
                                  color: Color.fromRGBO(255, 255, 255, 0.7),
                                ),
                                Text(
                                  gameState.cardsInPlay.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      shadows: [
                                        Shadow(
                                            offset: Offset(2, 3),
                                            blurRadius: 3.0,
                                            color:
                                                Color.fromRGBO(50, 50, 50, 1))
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                ),

                /// City Cards In Deck
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: CustomButton(
                      onPress: () {
                        // pause timer if running and flag if resume is needed.
                        bool _shouldResume = false;
                        if (_timer != null && _timer.isActive) {
                          _startTimer();
                          _shouldResume = true;
                        }
                        // open dialog
                        DialogHelper.cityCardCount(
                          context,
                          cardCount: gameState.cardsInDeck,
                          title: 'City cards\nin deck',
                          onComplete: (int newCardCount) {
                            Navigator.of(context).pop();
                            gameStateModel.setCardsInDeck(newCardCount);
                            if (_shouldResume) {
                              _startTimer();
                            }
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                            if (_shouldResume) {
                              _startTimer();
                            }
                          },
                        );
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
                                        shadows: [
                                          Shadow(
                                              offset: Offset(2, 3),
                                              blurRadius: 3.0,
                                              color:
                                                  Color.fromRGBO(50, 50, 50, 1))
                                        ]),
                                  ),
                                ),
                                VerticalDivider(
                                  width: 20,
                                  thickness: 2,
                                  color: Color.fromRGBO(255, 255, 255, 0.7),
                                ),
                                Text(
                                  gameState.cardsInDeck.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      shadows: [
                                        Shadow(
                                            offset: Offset(2, 3),
                                            blurRadius: 3.0,
                                            color:
                                                Color.fromRGBO(50, 50, 50, 1))
                                      ]),
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
  }

  Widget _landscapeLayout(GameState gameState) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: [
          /** LEFT COLUMN */
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.40,
            child: Column(
//              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Music Toggle
                    Container(
                      child: IconButton(
                        icon: _musicEnabled
                            ? Icon(Icons.volume_up)
                            : Icon(Icons.volume_off),
                        iconSize: 32,
                        color: Colors.white,
                        highlightColor: Color.fromARGB(0, 0, 0, 0),
                        onPressed: () {
                          SystemSound.play(SystemSoundType.click);
                          _toggleMusic();
                        },
                      ),
                    ),
                    /** Exit Button */
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.close),
                        iconSize: 32,
                        color: Colors.white,
                        highlightColor: Color.fromARGB(0, 0, 0, 0),
                        onPressed: () {
                          // pause timer if running and flag if resume is needed.
                          bool _shouldResume = false;
                          if (_timer != null && _timer.isActive) {
                            _startTimer();
                            _shouldResume = true;
                          }
                          DialogHelper.exitConfirmation(context, onConfirm: () {
                            _saveAndExit();
                          }, onCancel: () {
                            if (_shouldResume) {
                              _startTimer();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),

                /** Start/Pause Button */
                Container(
                  child: CustomButton(
                      onPress: () {
                        _startTimer();
                      },
                      color: _startBtnColor,
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12.0),
                          child: Text(
                            _startBtnText,
                            textAlign: TextAlign.center,
                            style: CustomTextStyle.buttonTextLarge(context),
                          ),
                        ),
                      )),
                ),

                /// Resolve City Button
                Container(
                  child: CustomButton(
                      onPress: () {
                        _resolveCity();
                      },
                      color: _resolveBtnColor,
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12.0),
                          child: Text(
                            'RESOLVE CITY',
                            textAlign: TextAlign.center,
                            style: CustomTextStyle.buttonTextLarge(context),
                          ),
                        ),
                      )),
                ),

                /// City Cards In Play
                Container(
                  child: CustomButton(
                      onPress: () {
                        // pause timer if running and flag if resume is needed.
                        bool _shouldResume = false;
                        if (_timer != null && _timer.isActive) {
                          _startTimer();
                          _shouldResume = true;
                        }
                        DialogHelper.cityCardCount(
                          context,
                          cardCount: gameState.cardsInPlay,
                          title: 'City cards\nin play',
                          onComplete: (int newCardCount) {
                            Navigator.of(context).pop();
                            gameStateModel.setCardsInPlay(newCardCount);
                            if (_shouldResume) {
                              _startTimer();
                            }
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                            if (_shouldResume) {
                              _startTimer();
                            }
                          },
                        );
                      },
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.all(8.0),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'City cards in play:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                            offset: Offset(2, 3),
                                            blurRadius: 3.0,
                                            color:
                                                Color.fromRGBO(50, 50, 50, 1))
                                      ]),
                                ),
                                VerticalDivider(
                                  width: 20,
                                  thickness: 2,
                                  color: Color.fromRGBO(255, 255, 255, 0.7),
                                ),
                                Text(
                                  gameState.cardsInPlay.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      shadows: [
                                        Shadow(
                                            offset: Offset(2, 3),
                                            blurRadius: 3.0,
                                            color:
                                                Color.fromRGBO(50, 50, 50, 1))
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                ),

                /// City Cards In Deck
                Container(
                  child: CustomButton(
                      onPress: () {
                        // pause timer if running and flag if resume is needed.
                        bool _shouldResume = false;
                        if (_timer != null && _timer.isActive) {
                          _startTimer();
                          _shouldResume = true;
                        }
                        // open dialog
                        DialogHelper.cityCardCount(
                          context,
                          cardCount: gameState.cardsInDeck,
                          title: 'City cards\nin deck',
                          onComplete: (int newCardCount) {
                            Navigator.of(context).pop();
                            gameStateModel.setCardsInDeck(newCardCount);
                            if (_shouldResume) {
                              _startTimer();
                            }
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                            if (_shouldResume) {
                              _startTimer();
                            }
                          },
                        );
                      },
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.all(8.0),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'City cards in deck:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                            offset: Offset(2, 3),
                                            blurRadius: 3.0,
                                            color:
                                                Color.fromRGBO(50, 50, 50, 1))
                                      ]),
                                ),
                                VerticalDivider(
                                  width: 20,
                                  thickness: 2,
                                  color: Color.fromRGBO(255, 255, 255, 0.7),
                                ),
                                Text(
                                  gameState.cardsInDeck.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      shadows: [
                                        Shadow(
                                            offset: Offset(2, 3),
                                            blurRadius: 3.0,
                                            color:
                                                Color.fromRGBO(50, 50, 50, 1))
                                      ]),
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
          VerticalDivider(
            width: 40,
            thickness: 2,
            color: Colors.white.withOpacity(0.5),
            indent: 10,
            endIndent: 10,
          ),
          /** RIGHT COLUMN */
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /** Time Display */
                Text(
                  _timeDisplay,
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.yellow,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Operator Mono',
                  ),
                ),
                /** Sand Timer */
                Expanded(
                  child: FlareActor(
                    'assets/animations/sandTimer.flr',
                    controller: _timerController,
                  ),
                ),

                /** Time Tokens */
                Container(
                  height: 60,
                  child: FlareActor(
                    'assets/animations/timeTokens.flr',
                    controller: _tokenController,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
