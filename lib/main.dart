
/*
 * Created by Chuck Taylor on 19/05/20 10:45 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 14/05/20 10:58 PM
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pandemic_timer/localizations/app_localizations_delegate.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';
import 'package:pandemic_timer/services/service_locator.dart';
import 'package:pandemic_timer/ui/views/difficulty_screen.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en', 'EN'), // English
        Locale('fr', 'FR'), // French
      ],
      onGenerateTitle: (BuildContext context) => Strings.of(context).title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DifficultySelectionScreen(),
    );
  }
}
