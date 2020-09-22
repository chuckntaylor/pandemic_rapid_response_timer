/*
 * Created by Chuck Taylor on 14/05/20 10:42 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 14/05/20 10:42 PM
 */

import 'package:intl/intl.dart';

mixin StringResources {
  String get title {
    return Intl.message('Pandemic Rapid Response Timer', name: 'title', desc: 'The title of the application');
  }

  // Difficulty Selection Screen
  String get resumeGame {
    return Intl.message('Resume Game', name: 'resumeGame', desc: 'Button text to resume a game if one is already in progress.');
  }

  String get easy {
    return Intl.message('Easy', name: 'easy', desc: 'The label for the easy difficulty option');
  }

  String get normal {
    return Intl.message('Normal', name: 'normal', desc: 'The label for the normal difficulty option');
  }

  String get veteran {
    return Intl.message('Veteran', name: 'veteran', desc: 'The label for the veteran difficulty option');
  }

  String get heroic {
    return Intl.message('Heroic', name: 'heroic', desc: 'The label for the heroic difficulty option');
  }

  String get numCityPlaced {
    return Intl.message('City cards placed',
        name: 'numCityPlaced', desc: 'Label for how many city cards are placed at the start of the game');
  }

  String get numCityInDeck {
    return Intl.message('City cards in deck',
        name: 'numCityInDeck', desc: 'Label for how many city cards are in the city deck at the start of the game');
  }

  String get semanticMissionIcon {
    return Intl.message('mission icon', name: 'semanticMissionIcon', desc: 'Used in the semantic label for the difficulty icons');
  }

  // Timer Screen
  String get start {
    return Intl.message('start', name: 'start', desc: 'Button label to \'start\' the timer');
  }

  String get pause {
    return Intl.message('pause', name: 'pause', desc: 'Button label to \'pause\' the timer');
  }

  String get musicToggleIconSemantic {
    return Intl.message('music toggle button', name: 'musicToggleIconSemantic', desc: 'Semantic label for the music toggle icon');
  }

  String get exitIconSemantic {
    return Intl.message('exit button', name: 'exitIconSemantic', desc: 'Semantic label for the exit icon');
  }

  String get resolveCity {
    return Intl.message('resolve city', name: 'resolveCity', desc: 'Label for the button to resolve a city card');
  }

  String get cardsInPlay {
    return Intl.message('City cards in play',
        name: 'cardsInPlay', desc: 'Label for button which indicates how many city cards are currently in play');
  }

  String get cardsInDeck {
    return Intl.message('City cards in deck',
        name: 'cardsInDeck', desc: 'Label for button which indicates how many city cards are still in the deck');
  }

  // Dialogs
  String get timerAlertIconSemantic {
    return Intl.message('Time up alert icon',
        name: 'timerAlertIconSemantic', desc: 'Semantic label for the alert image when the timer runs out.');
  }

  String get timeUpTitle {
    return Intl.message('Time up!', name: 'timeUpTitle', desc: 'Title for the time up alert dialog');
  }

  String get timeUpMessage {
    return Intl.message('Draw a new card from the city deck. When you are ready, press RESUME.',
        name: 'timeUpMessage', desc: 'Message displayed to the user in the time up alert dialog.');
  }

  String get resume {
    return Intl.message('resume', name: 'resume', desc: 'Label for the dialog \'resume\' button');
  }

  String get gameOverIconSemantic {
    return Intl.message('Game over', name: 'gameOverIconSemantic', desc: 'Semantic label for the skull and cross-bones game over image.');
  }

  String get gameOverTitle {
    return Intl.message('Mission failed!', name: 'gameOverTitle', desc: 'Title for the game over dialog');
  }

  String get gameOverMessage {
    return Intl.message('Your team is out of time.',
        name: 'gameOverMessage', desc: 'Message displayed to the user when they lose the game');
  }

  String get exit {
    return Intl.message('exit', name: 'exit', desc: 'Button label for \'exit\'');
  }

  String get done {
    return Intl.message('done', name: 'done', desc: 'Button label for \'done\'');
  }

  String get cancel {
    return Intl.message('cancel', name: 'cancel', desc: 'Button label for \'cancel\'');
  }

  String get victoryIconSemantic {
    return Intl.message('Victory stars',
        name: 'victoryIconSemantic', desc: 'Semantic label for the stars image that shows when the game is won.');
  }

  String get victoryTitle {
    return Intl.message('Victory!', name: 'victoryTitle', desc: 'Title for the game won \'victory\' dialog');
  }

  String get victoryMessage {
    return Intl.message('Congratulations! Your team has won the game!',
        name: 'victoryMessage', desc: 'Message displayed to the user when they win the game');
  }

  String get exitTitle {
    return Intl.message('Exit?', name: 'exitTitle', desc: 'Title for the exit confirmation dialog');
  }

  String get exitMessage {
    return Intl.message('Are you sure you want to exit?',
        name: 'exitMessage', desc: 'Message displayed to the user asking them to confirm that they wish to exit the game');
  }

  String get aboutChuck {
    return Intl.message(
        "Rapid Response Timer App developed by Chuck Taylor.\n"
        "For more information, visit {{chucktaylor.dev}}.\n"
        "\u00A9 Chuck Taylor 2020\n\n"
        "Disclaimer: This application is an 'unofficial' companion app for the Pandemic Rapid Response\u2122 boardgame from Z-MAN games. This app is not affiliated or sponsored in any way by Z-MAN Games.",
        name: 'aboutChuck',
        desc: 'The about screen describing Chuck as the developer. Wrap the text that should be the link with double curly braces. {{}}');
  }
}
