/*
 * Created by Chuck Taylor on 28/05/20 4:28 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 28/05/20 4:28 PM
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';
import 'package:pandemic_timer/ui/utils/custom_text_style.dart';

class GameOverDialog extends StatelessWidget {

  final Function callBack;

  GameOverDialog({@required this.callBack});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: _buildChild(context, callBack),
    );
  }

  Widget _buildChild(BuildContext context, Function callBack) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            fit: StackFit.passthrough,
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: SvgPicture.asset(
                    'assets/images/alertRedBG.svg', fit: BoxFit.cover, alignment: Alignment.topCenter,
                  )),
              Positioned.fill(
                  child: Align(
                      alignment: Alignment(0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/skull.svg',
                            height: 100,
                            semanticsLabel: Strings.of(context).gameOverIconSemantic,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                Strings.of(context).gameOverTitle.toUpperCase(),
                                style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 24),
                              ))
                        ],
                      )))
            ],
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Text(Strings.of(context).gameOverMessage, textAlign: TextAlign.center, style: CustomTextStyle.dialogBody(context),)
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: RaisedButton(
              color: Color.fromRGBO(228, 69, 71, 1.0),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Text(Strings.of(context).exit.toUpperCase(),
                style: CustomTextStyle.dialogButtonLabel(),
              ),
              onPressed: () {
                callBack();
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
