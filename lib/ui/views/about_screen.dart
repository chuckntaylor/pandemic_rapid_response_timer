/*
 * Created by Chuck Taylor on 08/06/20 2:57 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 08/06/20 2:57 PM
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pandemic_timer/app/config.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';
import 'package:pandemic_timer/ui/utils/custom_text_style.dart';
import 'package:pandemic_timer/ui/widgets/circle_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {

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
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.all(16),
              child: Stack(
                children: [
                      CircleButton(
                        borderWidth: 6.0,
                        size: 48,
                        color: Colors.redAccent,
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: Icon(Icons.exit_to_app,
                            size: 32,
                            color: Colors.white,
                            semanticLabel: Strings.of(context).exitIconSemantic,
                          ),
                        ),
                        onPress: () {
                          // pause timer if running and flag if resume is needed.
                          _navigateToMainScreen(context);
                        },
                      ),
                  Center(child: _buildAboutText(context))
                ],),
            ),
                ),
            ),
          )
        );
  }

  Widget _buildAboutText(BuildContext context) {
    String originalString = Strings.of(context).aboutChuck;
    int startOfLink = originalString.indexOf('{{');
    int endOfLink = originalString.indexOf('}}') + 2;

    List<String> splitStrings = [
      originalString.substring(0, startOfLink),
      originalString.substring(startOfLink, endOfLink),
      originalString.substring(endOfLink)
    ];

    _assembleTextSpans() {
      List<InlineSpan> _textSpans = [];

      for (String item in splitStrings) {
        // check if it is the link text
        if (item.startsWith('{{')) {
          // remove the curly braces at the beginning and end
          String _linkText = item.replaceAll(RegExp(r'({{|}})'), '');
          _textSpans.add(
              TextSpan(text: _linkText,
                      style: CustomTextStyle.htmlLink(),
                      recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(AppConfig.CHUCK_WEBSITE);
                          }
                      ),
              );
        } else {
          // regular text
          _textSpans.add(
            TextSpan(text: item)
          );
        }
      }

      return _textSpans;
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16),
        children: _assembleTextSpans()
      ),
      textAlign: TextAlign.center,
    );
  }

  void _navigateToMainScreen(BuildContext context) {
    Navigator.of(context).pop();
  }
}