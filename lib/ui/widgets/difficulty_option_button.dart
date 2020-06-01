/*
 * Created by Chuck Taylor on 13/05/20 11:31 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 13/05/20 11:31 PM
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';

import 'custom_button.dart';

class DifficultyOptionButton extends StatelessWidget {
  DifficultyOptionButton({
    @required this.onPressed,
    @required this.title,
    @required this.iconName,
    @required this.numCitiesPlaced,
    @required this.numCitiesInDeck,
    this.accessibilityLabel,
    @required this.color
  });

  final GestureTapCallback onPressed;
  final String title;
  final iconName;
  final numCitiesPlaced;
  final numCitiesInDeck;
  final String accessibilityLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {

    String semanticsLabel = accessibilityLabel ?? '$title ${Strings.of(context).semanticMissionIcon}';
    return CustomButton(
        onPress: onPressed,
        color: color,
        child: IntrinsicWidth(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: SvgPicture.asset(
                      'assets/images/$iconName.svg',
                    semanticsLabel: semanticsLabel,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20,),
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18
                      ),),
                      Divider(
                        height: 6,
                        thickness: 1,
                        color: Colors.white.withOpacity(0.5),
                        
                      ),
                      SizedBox(height: 4,),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white
                          ),
                          children: [
                            TextSpan( text: '${Strings.of(context).numCityPlaced}: '),
                            TextSpan( text: ' $numCitiesPlaced', style: TextStyle(fontWeight: FontWeight.bold))
                          ]
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Colors.white
                            ),
                            children: [
                              TextSpan( text: '${Strings.of(context).numCityInDeck}: '),
                              TextSpan( text: ' $numCitiesInDeck', style: TextStyle(fontWeight: FontWeight.bold))
                            ]
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }


}