/*
 * Created by Chuck Taylor on 13/05/20 11:31 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 13/05/20 11:31 PM
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';

class DifficultyOptionButton extends StatelessWidget {
  DifficultyOptionButton({
    @required this.onPressed,
    @required this.title,
    @required this.iconName,
    @required this.numCitiesPlaced,
    @required this.numCitiesInDeck,
    this.accessibilityLabel
  });

  final GestureTapCallback onPressed;
  final String title;
  final iconName;
  final numCitiesPlaced;
  final numCitiesInDeck;
  final String accessibilityLabel;

  @override
  Widget build(BuildContext context) {

    String semanticsLabel = accessibilityLabel ?? '$title ${Strings.of(context).semanticMissionIcon}';
    return RawMaterialButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 80, maxHeight: 80),
              child: SvgPicture.asset(
                  'assets/images/$iconName.svg',
                semanticsLabel: semanticsLabel,
              ),
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.toUpperCase()),
                Text('${Strings.of(context).numCityPlaced}: $numCitiesPlaced'),
                Text('${Strings.of(context).numCityInDeck}: $numCitiesInDeck'),
              ],
            )
          ],
        ),
        onPressed: onPressed,
    );
  }


}