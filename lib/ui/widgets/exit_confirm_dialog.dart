/*
 * Created by Chuck Taylor on 02/06/20 8:13 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 02/06/20 8:13 PM
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';
import 'package:pandemic_timer/ui/utils/custom_text_style.dart';

class ExitConfirmDialog extends StatelessWidget {

  final Function onConfirm;
  final Function onCancel;

  ExitConfirmDialog({@required this.onConfirm, @required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
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
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      offset: Offset(2, 2),
                                      blurRadius: 6,
                                      spreadRadius: 0
                                  )
                                ]),
                            child: SvgPicture.asset(
                              'assets/images/exit.svg',
                              height: 100,
                              semanticsLabel: Strings.of(context).exitIconSemantic,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                Strings.of(context).exitTitle,
                                style: CustomTextStyle.buttonTextLarge(context).copyWith(fontSize: 24),
                              ))
                        ],
                      )))
            ],
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Text(Strings.of(context).exitMessage, textAlign: TextAlign.center,)
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Color.fromRGBO(228, 69, 71, 1.0),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Text(Strings.of(context).exit.toUpperCase(),
                    style: CustomTextStyle.dialogButtonLabel(),
                  ),
                  onPressed: () {
                    SystemSound.play(SystemSoundType.click);
                    onConfirm();
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 20,),
                RaisedButton(
                  color: Color.fromRGBO(228, 69, 71, 1.0),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Text(Strings.of(context).cancel.toUpperCase(),
                    style: CustomTextStyle.dialogButtonLabel(),
                  ),
                  onPressed: () {
                    SystemSound.play(SystemSoundType.click);
                    onCancel();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}