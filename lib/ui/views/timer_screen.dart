/*
 * Created by Chuck Taylor on 19/05/20 10:13 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 19/05/20 10:13 AM
 */

import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:pandemic_timer/ui/widgets/circle_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pandemic_timer/services/service_locator.dart';
import 'package:pandemic_timer/ui/utils/custom_text_style.dart';
import 'package:pandemic_timer/ui/utils/dialog_manager.dart';
import 'package:pandemic_timer/ui/utils/timer_animation_controller.dart';
import 'package:pandemic_timer/ui/utils/token_animation_controller.dart';
import 'package:pandemic_timer/ui/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:pandemic_timer/business_logic/game_state/game_state.dart';
import 'package:pandemic_timer/ui/utils/color_shades.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with WidgetsBindingObserver {
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
  String _startBtnText = '';

  /// Colors and Styles
  final Color _startBtnColor = Color.fromRGBO(105, 194, 76, 1.0);
  final Color _resolveBtnColor = Color.fromRGBO(53, 162, 189, 1.0);

  @override
  void initState() {
    super.initState();
    // add observer to get app lifecycle
    WidgetsBinding.instance.addObserver(this);
    // setup the Flare animation controllers
    _timerController = TimerAnimationController(play: false);
    _timerController.time = gameStateModel.timerAnimationCurrentTime;
    _tokenController = TokenAnimationController(tokenCount: gameStateModel.timeTokensRemaining);
    // get starting values from the gameStateModel
    _counter = gameStateModel.currentTime;
    _timeDisplay = '${_counter ~/ (60 * 10)}:${(_counter % (60 * 10) ~/ 10).toString().padLeft(2, '0')}';
    // load SharedPreferences
    _loadMusicPrefs();
    // Keep the device awake on this screen
    Wakelock.enable();
  }

  @override
  void didChangeDependencies() {
    if (_timer != null && _timer.isActive) {
      setState(() {
        _startBtnText = Strings.of(context).pause;
      });
    } else {
      setState(() {
        _startBtnText = Strings.of(context).start;
      });
    }
    super.didChangeDependencies();
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
          _toggleTimer();
          break;
        }
      case AppLifecycleState.resumed:
        {
          if (_shouldResume) {
            _toggleTimer();
          }
          _shouldResume = false;
          break;
        }
      default:
        break;
    }
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
        autoStart: false, volume: _musicEnabled ? 0.5 : 0.0, seek: Duration(seconds: gameStateModel.musicPlayHeadPosition));
  }

  void _toggleTimer() {
    if (_timer != null && _timer.isActive) {
      // if timer is already active
      // pause timer, animation, and music
      _timer.cancel();
      _timerController.play = false;
      _musicAudioPlayer.pause();
      // change the button text from 'pause' to 'start'
      setState(() {
        _startBtnText = Strings.of(context).start;
      });
    } else {
      // if timer is not running
      // play the animation, and music
      _timerController.play = true;
      _musicAudioPlayer.play();
      // change the button text from 'start' to 'pause'
      setState(() {
        _startBtnText = Strings.of(context).pause;
      });
      // run the timer every 0.1 seconds
      _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (_counter > 0) {
          // if timer has not finished
          // continue countdown
          setState(() {
            _counter--;
            _timeDisplay = '${_counter ~/ (60 * 10)}:${(_counter % (60 * 10) ~/ 10).toString().padLeft(2, '0')}';
          });
        } else {
          // countdown complete
          // stop the timer, reset the animation, reset the music to the beginning and pause it
          _timer.cancel();
          _timerController.reset();
          _musicAudioPlayer.seek(Duration(seconds: 0));
          _musicAudioPlayer.pause();
          // check if there is still any time tokens remaining
          if (gameStateModel.timeTokensRemaining > 0) {
            // play alarm sound
            _assetsSFXAudioPlayer.open(Audio('assets/audio/chime.mp3'));
            // show timerReset Dialog if there are still cards in the city deck
            if (gameStateModel.cardsInDeck > 0) {
              DialogManager.timerReset(context, callBack: () {
                _removeToken();
              });
            } else {
              // if no cards are in the deck, just continue with resetting the timer.
              _removeToken();
            }
          } else {
            // GAME OVER!
            // play a game end sound
            _assetsSFXAudioPlayer.open(Audio('assets/audio/drama.mp3'));
            // show gameOver Dialog
            DialogManager.gameOver(context, callBack: () {
              _exit();
            });
          }
        }
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
        _counter = 1200;
        _timeDisplay = '${_counter ~/ (60 * 10)}:${(_counter % (60 * 10) ~/ 10).toString().padLeft(2, '0')}';
      });
      // it takes the sand timer one second to turn over before the sand starts to fall.
      // delay the start of the countdown timer by one second.
      await new Future.delayed(const Duration(seconds: 1), () {
        _toggleTimer();
      });
    }
  }

  void _resolveCity() {
    if (_tokenController.idle == true) {
      _assetsSFXAudioPlayer.open(Audio('assets/audio/cityResolved.mp3'));
      gameStateModel.resolveCity();
      _tokenController.updateTokenCount(gameStateModel.timeTokensRemaining);
      // check if victory conditions are met
      if (gameStateModel.cardsInPlay == 0 && gameStateModel.cardsInDeck == 0) {
        // WIN!!
        // stop timer
        if (_timer != null && _timer.isActive) {
          _toggleTimer();
        }
        // play victory audio
        _assetsSFXAudioPlayer.open(Audio('assets/audio/chimesGlassy.mp3'));
        // show dialog
        DialogManager.gameVictory(context, callBack: () {
          _exit();
        });
      }
    }
  }

  void _saveAndExit() async {
    gameStateModel.savedGame = true;
    if (_timer != null && _timer.isActive) {
      _toggleTimer();
    }
    gameStateModel.currentTime = _counter;
    gameStateModel.timerAnimationCurrentTime = _timerController.time;
    gameStateModel.musicPlayHeadPosition = _musicAudioPlayer.currentPosition.value.inSeconds;
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
      _toggleTimer();
      _shouldResume = true;
    }
    DialogManager.exitConfirmation(context, onConfirm: () {
      _saveAndExit();
    }, onCancel: () {
      if (_shouldResume) {
        _toggleTimer();
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
                            ? AssetImage('assets/images/speakerGrillPortrait.jpg')
                            : AssetImage('assets/images/speakerGrillLandscape.jpg'),
                        fit: BoxFit.cover)),
                child: SafeArea(
                  child: Consumer<GameState>(
                    builder: (context, gameState, child) {
                      return OrientationBuilder(
                        builder: (context, orientation) {
                          return orientation == Orientation.portrait ? _portraitLayout(gameState) : _landscapeLayout(gameState);
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
            child: Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /** Music Toggle */
                  CircleButton(
                      borderWidth: 6.0,
                      size: 48,
                      color: Colors.blue.lighter(30),
                      onPress: () => _toggleMusic(),
                      child: Icon(
                        _musicEnabled ? Icons.volume_up : Icons.volume_off,
                        color: Colors.white,
                        semanticLabel: Strings.of(context).musicToggleIconSemantic,
                        size: 32,
                      )),
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
                  CircleButton(
                    borderWidth: 6.0,
                    size: 48,
                    color: Colors.redAccent,
                    child: Icon(
                      Icons.exit_to_app,
                      size: 32,
                      color: Colors.white,
                      semanticLabel: Strings.of(context).exitIconSemantic,
                    ),
                    onPress: () {
                      // pause timer if running and flag if resume is needed.
                      bool _shouldResume = false;
                      if (_timer != null && _timer.isActive) {
                        _toggleTimer();
                        _shouldResume = true;
                      }
                      DialogManager.exitConfirmation(context, onConfirm: () {
                        _saveAndExit();
                      }, onCancel: () {
                        if (_shouldResume) {
                          _toggleTimer();
                        }
                      });
                    },
                  ),
                ],
              ),
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
            style: CustomTextStyle.timer(),
          ),

          /** Start/Pause Button */
          Container(
            margin: EdgeInsets.all(_getMargin(context)),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                  onPress: () {
                    _toggleTimer();
                  },
                  color: _startBtnColor,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                      child: Text(
                        _startBtnText.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.headingWithShadow(context),
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
                  playClickAudio: false,
                  onPress: () {
                    _resolveCity();
                  },
                  color: _resolveBtnColor,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                      child: Text(
                        Strings.of(context).resolveCity.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.headingWithShadow(context),
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
                          _toggleTimer();
                          _shouldResume = true;
                        }
                        DialogManager.cityCardCount(
                          context,
                          cardCount: gameState.cardsInPlay,
                          title: Strings.of(context).cardsInPlay,
                          onComplete: (int newCardCount) {
                            Navigator.of(context).pop();
                            gameStateModel.setCardsInPlay(newCardCount);
                            if (_shouldResume) {
                              _toggleTimer();
                            }
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                            if (_shouldResume) {
                              _toggleTimer();
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
                                    '${Strings.of(context).cardsInPlay}:',
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 18),
                                  ),
                                ),
                                VerticalDivider(
                                  width: 20,
                                  thickness: 2,
                                  color: Color.fromRGBO(255, 255, 255, 0.7),
                                ),
                                Text(
                                  gameState.cardsInPlay.toString(),
                                  style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 32),
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
                          _toggleTimer();
                          _shouldResume = true;
                        }
                        // open dialog
                        DialogManager.cityCardCount(
                          context,
                          cardCount: gameState.cardsInDeck,
                          title: Strings.of(context).cardsInDeck,
                          onComplete: (int newCardCount) {
                            Navigator.of(context).pop();
                            gameStateModel.setCardsInDeck(newCardCount);
                            if (_shouldResume) {
                              _toggleTimer();
                            }
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                            if (_shouldResume) {
                              _toggleTimer();
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
                                    '${Strings.of(context).cardsInDeck}:',
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 18),
                                  ),
                                ),
                                VerticalDivider(
                                  width: 20,
                                  thickness: 2,
                                  color: Color.fromRGBO(255, 255, 255, 0.7),
                                ),
                                Text(
                                  gameState.cardsInDeck.toString(),
                                  style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 32),
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
                    /** Music Toggle */
                    CircleButton(
                        borderWidth: 6.0,
                        size: 48,
                        color: Colors.blue.lighter(30),
                        onPress: () => _toggleMusic(),
                        child: Icon(
                          _musicEnabled ? Icons.volume_up : Icons.volume_off,
                          color: Colors.white,
                          semanticLabel: Strings.of(context).musicToggleIconSemantic,
                          size: 32,
                        )),
                    /** Exit Button */
                    CircleButton(
                      borderWidth: 6.0,
                      size: 48,
                      color: Colors.redAccent,
                      child: Icon(
                        Icons.exit_to_app,
                        size: 32,
                        color: Colors.white,
                        semanticLabel: Strings.of(context).exitIconSemantic,
                      ),
                      onPress: () {
                        // pause timer if running and flag if resume is needed.
                        bool _shouldResume = false;
                        if (_timer != null && _timer.isActive) {
                          _toggleTimer();
                          _shouldResume = true;
                        }
                        DialogManager.exitConfirmation(context, onConfirm: () {
                          _saveAndExit();
                        }, onCancel: () {
                          if (_shouldResume) {
                            _toggleTimer();
                          }
                        });
                      },
                    ),
                  ],
                ),

                /** Start/Pause Button */
                Container(
                  child: CustomButton(
                      onPress: () {
                        _toggleTimer();
                      },
                      color: _startBtnColor,
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                          child: Text(
                            _startBtnText.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 24),
                          ),
                        ),
                      )),
                ),

                /// Resolve City Button
                Container(
                  child: CustomButton(
                      playClickAudio: false,
                      onPress: () {
                        _resolveCity();
                      },
                      color: _resolveBtnColor,
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                          child: Text(
                            Strings.of(context).resolveCity.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 24),
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
                          _toggleTimer();
                          _shouldResume = true;
                        }
                        DialogManager.cityCardCount(
                          context,
                          cardCount: gameState.cardsInPlay,
                          title: Strings.of(context).cardsInPlay,
                          onComplete: (int newCardCount) {
                            Navigator.of(context).pop();
                            gameStateModel.setCardsInPlay(newCardCount);
                            if (_shouldResume) {
                              _toggleTimer();
                            }
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                            if (_shouldResume) {
                              _toggleTimer();
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
                                  '${Strings.of(context).cardsInPlay}:',
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 18),
                                ),
                                VerticalDivider(
                                  width: 20,
                                  thickness: 2,
                                  color: Color.fromRGBO(255, 255, 255, 0.7),
                                ),
                                Text(
                                  gameState.cardsInPlay.toString(),
                                  style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 32),
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
                          _toggleTimer();
                          _shouldResume = true;
                        }
                        // open dialog
                        DialogManager.cityCardCount(
                          context,
                          cardCount: gameState.cardsInDeck,
                          title: Strings.of(context).cardsInDeck,
                          onComplete: (int newCardCount) {
                            Navigator.of(context).pop();
                            gameStateModel.setCardsInDeck(newCardCount);
                            if (_shouldResume) {
                              _toggleTimer();
                            }
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                            if (_shouldResume) {
                              _toggleTimer();
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
                                  '${Strings.of(context).cardsInDeck}:',
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 18),
                                ),
                                VerticalDivider(
                                  width: 20,
                                  thickness: 2,
                                  color: Color.fromRGBO(255, 255, 255, 0.7),
                                ),
                                Text(
                                  gameState.cardsInDeck.toString(),
                                  style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 32),
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
                  style: CustomTextStyle.timer().copyWith(fontSize: 48),
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
