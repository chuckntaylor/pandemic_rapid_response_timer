/*
 * Created by Chuck Taylor on 22/05/20 9:54 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 22/05/20 9:54 AM
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';

class TimerResetDialog extends StatelessWidget {

  final Function callBack;

  TimerResetDialog({@required this.callBack});

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
                            'assets/images/alertIcon.svg',
                            semanticsLabel: Strings.of(context).timerAlertIconSemantic,
                            height: 100,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                Strings.of(context).timeUpTitle.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                    color: Colors.white),
                              ))
                        ],
                      )))
            ],
          ),
          Container(
            padding: EdgeInsets.all(20),
              child: Text(Strings.of(context).timeUpMessage, textAlign: TextAlign.center,)
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: RaisedButton(
              color: Color.fromRGBO(228, 69, 71, 1.0),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Text(Strings.of(context).resume.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                    fontSize: 18,
                  color: Colors.white
                ),
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
