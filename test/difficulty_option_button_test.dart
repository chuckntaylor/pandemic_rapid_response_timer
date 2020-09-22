/*
 * Created by Chuck Taylor on 10/06/20 10:19 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 10/06/20 10:19 AM
 */

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pandemic_timer/localizations/app_localizations_delegate.dart';
import 'package:pandemic_timer/ui/widgets/difficulty_option_button.dart';

import 'custom_finders/custom_finder.dart';

Widget makeTestableWidget({Widget child}) {
  return MaterialApp(
    localizationsDelegates: [AppLocalizationsDelegate(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
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
//  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Difficulty Option Button renders supplied values (title, placed cards, cards in deck)', (WidgetTester tester) async {
    final String title = 'Title';
    final String iconName = 'easyPlane';
    final String semanticIconTitle = 'Accessibilty Label';
    final int cardsInDeck = 3;
    final int cardsInPlay = 2;
    final Color color = Colors.red;

    await tester.pumpWidget(Builder(
      builder: (BuildContext context) {
        return makeTestableWidget(
            child: DifficultyOptionButton(
          onPressed: () {},
          title: title,
          iconName: iconName,
          numCitiesPlaced: cardsInPlay,
          numCitiesInDeck: cardsInDeck,
          accessibilityLabel: semanticIconTitle,
          color: color,
        ));
      },
    ));

    await tester.pump();

    // create finders
    final titleFinder = find.text(title.toUpperCase());
    final semanticIconTitleFinder = find.bySemanticsLabel(semanticIconTitle);
    final cardsInDeckFinder = CustomFinder.findRichTextThatContains(': $cardsInDeck');
    final cardsInPlayFinder = CustomFinder.findRichTextThatContains(': $cardsInPlay');
    final svgFinder = find.byType(SvgPicture);

    // create expectations
    expect(titleFinder, findsOneWidget);
    expect(semanticIconTitleFinder, findsOneWidget);
    expect(cardsInDeckFinder, findsOneWidget);
    expect(cardsInPlayFinder, findsOneWidget);
    expect(svgFinder, findsOneWidget);
  });
}
