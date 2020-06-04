/*
 * Created by Chuck Taylor on 14/05/20 10:42 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 14/05/20 10:42 PM
 */

import 'package:intl/intl.dart';

mixin StringResources {
  String get title {
    return Intl.message(
        'Pandemic Rapid Response Timer',
        name: 'title',
        desc: 'The title of the application'
    );
  }

  /** Difficulty Selection Screen */
  String get resumeGame {
    return Intl.message(
      'Resume Game',
      name: 'resumeGame',
      desc: 'Button text to resume a game if one is already in progress.'
    );
  }

  String get easy {
    return Intl.message(
        'Easy',
        name: 'easy',
        desc: 'The label for the easy difficulty option'
    );
  }

  String get normal {
    return Intl.message(
        'Normal',
        name: 'normal',
        desc: 'The label for the normal difficulty option'
    );
  }

  String get veteran {
    return Intl.message(
        'Veteran',
        name: 'veteran', desc:
    'The label for the veteran difficulty option'
    );
  }

  String get heroic {
    return Intl.message(
        'Heroic',
        name: 'heroic',
        desc: 'The label for the heroic difficulty option'
    );
  }

  String get numCityPlaced {
    return Intl.message(
        'City cards placed',
        name: 'numCityPlaced',
        desc: 'Label for how many city cards are placed at the start of the game'
    );
  }

  String get numCityInDeck {
    return Intl.message(
        'City cards in deck',
        name: 'numCityInDeck',
        desc: 'Label for how many city cards are in the city deck at the start of the game'
    );
  }

  String get semanticMissionIcon {
    return Intl.message(
      'mission icon',
      name: 'semanticMissionIcon',
      desc: 'Used in the semantic label for the difficulty icons'
    );
  }

  /** Timer Screen */
  String get start {
    return Intl.message(
      'start',
      name: 'start',
      desc: 'Button label to \'start\' the timer'
    );
  }
}
