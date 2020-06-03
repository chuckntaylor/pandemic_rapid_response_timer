/*
 * Created by Chuck Taylor on 02/06/20 11:57 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 02/06/20 11:57 AM
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pandemic_timer/ui/utils/custom_text_style.dart';

class VictoryDialog extends StatelessWidget {

  final Function callBack;

  VictoryDialog({@required this.callBack});

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
                    'assets/images/victoryBlueBG.svg', fit: BoxFit.cover, alignment: Alignment.topCenter,
                  )),
              Positioned.fill(
                  child: Align(
                      alignment: Alignment(0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/threeStars.svg',
                            height: 100,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                'VICTORY!',
                                style: CustomTextStyle.buttonTextLarge(context).copyWith(fontSize: 24),
                              ))
                        ],
                      )))
            ],
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Text('Congratulations! Your team has won the game!', textAlign: TextAlign.center,)
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: RaisedButton(
              color: Color.fromRGBO(33, 142, 169, 1.0),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Text('EXIT',
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