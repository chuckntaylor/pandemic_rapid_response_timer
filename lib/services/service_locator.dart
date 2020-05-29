/*
 * Created by Chuck Taylor on 19/05/20 10:35 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 19/05/20 10:35 AM
 */

import 'package:get_it/get_it.dart';
import 'package:pandemic_timer/business_logic/game_state/game_state.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<GameState>(() => GameState());
}
