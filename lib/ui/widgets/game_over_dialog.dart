/*
 * Created by Chuck Taylor on 28/05/20 4:28 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 28/05/20 4:28 PM
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameOverDialog extends StatelessWidget {

  Function callBack;

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
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                'MISSION FAILED!',
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
              child: Text('Your team is out of time.', textAlign: TextAlign.center,)
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: RaisedButton(
              color: Color.fromRGBO(228, 69, 71, 1.0),
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