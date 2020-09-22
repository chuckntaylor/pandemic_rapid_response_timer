/*
 * Created by Chuck Taylor on 12/05/20 9:01 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 12/05/20 8:42 PM
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pandemic_timer/services/service_locator.dart';
import 'package:pandemic_timer/ui/utils/custom_text_style.dart';
import 'package:pandemic_timer/ui/views/about_screen.dart';
import 'package:pandemic_timer/ui/views/timer_screen.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';
import 'package:pandemic_timer/ui/widgets/circle_button.dart';
import 'package:pandemic_timer/ui/widgets/custom_button.dart';
import 'package:pandemic_timer/ui/widgets/difficulty_option_button.dart';
import 'package:pandemic_timer/business_logic/models/difficulty.dart';
import 'package:pandemic_timer/business_logic/game_state/game_state.dart';
import 'package:pandemic_timer/ui/utils/color_shades.dart';

class DifficultySelectionScreen extends StatefulWidget {
  @override
  _DifficultySelectionScreenState createState() => _DifficultySelectionScreenState();
}

class _DifficultySelectionScreenState extends State<DifficultySelectionScreen> {
  final GameState gameState = serviceLocator<GameState>();

  // ignore: unused_field
  bool _savedGameExists = false;

  final Color _easyColor = Color.fromRGBO(105, 194, 76, 1.0).darker(40);
  final Color _normalColor = Color.fromRGBO(53, 162, 189, 1.0).darker(20);
  final Color _veteranColor = Colors.amber.darker(40);
  final Color _heroicColor = Colors.red.darker(20);

  static const double _buttonSpacing = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: MediaQuery.of(context).orientation == Orientation.portrait
                      ? AssetImage('assets/images/speakerGrillPortrait.png')
                      : AssetImage('assets/images/speakerGrillLandscape.png'),
                  fit: BoxFit.cover)),
          child: SafeArea(child: OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.portrait ? _portraitLayout() : _landscapeLayout();
            },
          )),
        ),
      ),
    );
  }

  Widget _portraitLayout() {
    return Stack(children: [
      Positioned(
        right: 8,
        top: 8,
        child: CircleButton(
          color: Colors.deepPurple,
          borderWidth: 6.0,
          size: 40,
          onPress: () {
            _navigateToAbout(context);
          },
          child: Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
        ),
      ),
      Center(
          child: IntrinsicWidth(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (gameState.savedGame)
              CustomButton(
                onPress: () {
                  _navigateToTimer(context, difficulty: Difficulty.RESUME);
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        Strings.of(context).resumeGame.toUpperCase(),
                        style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 18),
                      ),
                    ],
                  )),
                ),
              ),
            if (gameState.savedGame)
              SizedBox(
                height: _buttonSpacing,
              ),
            DifficultyOptionButton(
              title: Strings.of(context).easy,
              iconName: 'easyPlane',
              numCitiesPlaced: 2,
              numCitiesInDeck: 3,
              onPressed: () {
                _navigateToTimer(context, difficulty: Difficulty.EASY);
              },
              color: _easyColor,
            ),
            SizedBox(
              height: _buttonSpacing,
            ),
            DifficultyOptionButton(
              title: Strings.of(context).normal,
              iconName: 'normalPlane',
              numCitiesPlaced: 2,
              numCitiesInDeck: 5,
              onPressed: () {
                _navigateToTimer(context, difficulty: Difficulty.NORMAL);
              },
              color: _normalColor,
            ),
            SizedBox(
              height: _buttonSpacing,
            ),
            DifficultyOptionButton(
              title: Strings.of(context).veteran,
              iconName: 'veteranPlane',
              numCitiesPlaced: 3,
              numCitiesInDeck: 7,
              onPressed: () {
                _navigateToTimer(context, difficulty: Difficulty.VETERAN);
              },
              color: _veteranColor,
            ),
            SizedBox(
              height: _buttonSpacing,
            ),
            DifficultyOptionButton(
              title: Strings.of(context).heroic,
              iconName: 'heroicPlane',
              numCitiesPlaced: 4,
              numCitiesInDeck: 9,
              onPressed: () {
                _navigateToTimer(context, difficulty: Difficulty.HEROIC);
              },
              color: _heroicColor,
            )
          ],
        ),
      )),
    ]);
  }

  Widget _landscapeLayout() {
    return Stack(
      children: [
        Positioned(
          right: 8,
          top: 8,
          child: CircleButton(
            color: Colors.deepPurple,
            borderWidth: 6.0,
            size: 40,
            onPress: () {
              _navigateToAbout(context);
            },
            child: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
        ),
        Center(
            child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (gameState.savedGame)
                CustomButton(
                  onPress: () {
                    _navigateToTimer(context, difficulty: Difficulty.RESUME);
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          Strings.of(context).resumeGame.toUpperCase(),
                          style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 18),
                        ),
                      ],
                    )),
                  ),
                ),
              if (gameState.savedGame)
                SizedBox(
                  height: _buttonSpacing,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DifficultyOptionButton(
                    title: Strings.of(context).easy,
                    iconName: 'easyPlane',
                    numCitiesPlaced: 2,
                    numCitiesInDeck: 3,
                    onPressed: () {
                      _navigateToTimer(context, difficulty: Difficulty.EASY);
                    },
                    color: _easyColor,
                  ),
                  SizedBox(
                    width: _buttonSpacing,
                  ),
                  DifficultyOptionButton(
                    title: Strings.of(context).normal,
                    iconName: 'normalPlane',
                    numCitiesPlaced: 2,
                    numCitiesInDeck: 5,
                    onPressed: () {
                      _navigateToTimer(context, difficulty: Difficulty.NORMAL);
                    },
                    color: _normalColor,
                  ),
                ],
              ),
              SizedBox(
                height: _buttonSpacing,
                width: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DifficultyOptionButton(
                    title: Strings.of(context).veteran,
                    iconName: 'veteranPlane',
                    numCitiesPlaced: 3,
                    numCitiesInDeck: 7,
                    onPressed: () {
                      _navigateToTimer(context, difficulty: Difficulty.VETERAN);
                    },
                    color: _veteranColor,
                  ),
                  SizedBox(
                    width: _buttonSpacing,
                  ),
                  DifficultyOptionButton(
                    title: Strings.of(context).heroic,
                    iconName: 'heroicPlane',
                    numCitiesPlaced: 4,
                    numCitiesInDeck: 9,
                    onPressed: () {
                      _navigateToTimer(context, difficulty: Difficulty.HEROIC);
                    },
                    color: _heroicColor,
                  )
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }

  void _navigateToTimer(BuildContext context, {Difficulty difficulty}) async {
    if (difficulty != Difficulty.RESUME) {
      gameState.initNewGame(difficulty: difficulty);
    }
    await Navigator.push(context, MaterialPageRoute(builder: (context) => TimerScreen())).then((_) {
      setState(() {
        _savedGameExists = gameState.savedGame;
      });
    });
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.push((context), MaterialPageRoute(builder: (context) => AboutScreen()));
  }
}
