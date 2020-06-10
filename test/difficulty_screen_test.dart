/*
 * Created by Chuck Taylor on 10/06/20 1:57 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 10/06/20 1:57 PM
 */

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pandemic_timer/localizations/app_localizations_delegate.dart';
import 'package:pandemic_timer/services/service_locator.dart';
import 'package:pandemic_timer/ui/views/difficulty_screen.dart';
import 'package:pandemic_timer/ui/widgets/difficulty_option_button.dart';

Widget makeTestableWidget({Widget child}) {
  return MaterialApp(
    localizationsDelegates: [
      AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [
      Locale('en', 'EN'), // English
      Locale('fr', 'FR'), // French
    ],
    home: Scaffold(
      body: child,
    ),
  );
}

void main() {

  final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    setupServiceLocator();
  });

  testWidgets('Difficulty Options Screen renders', (WidgetTester tester) async {

    await binding.setSurfaceSize(Size(600, 800));
    final screen = DifficultySelectionScreen();
    await tester.pumpWidget(makeTestableWidget(child: screen));
    await tester.pump();

    final screenFinder = find.byWidget(screen);
    final buttonsFinder = find.byType(DifficultyOptionButton);

    expect(screenFinder, findsOneWidget);
    expect(buttonsFinder, findsNWidgets(4));

    await binding.setSurfaceSize(Size(800, 600));
    await tester.pump();

    expect(screenFinder, findsOneWidget);
    expect(buttonsFinder, findsNWidgets(4));
  });

}