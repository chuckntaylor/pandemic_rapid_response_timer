/*
 * Created by Chuck Taylor on 28/05/20 9:27 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 28/05/20 9:27 PM
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';
import 'package:pandemic_timer/ui/utils/custom_text_style.dart';
import 'package:pandemic_timer/ui/widgets/button_painter.dart';
import 'package:pandemic_timer/ui/utils/color_shades.dart';

// ignore: must_be_immutable
class CityCardCountDialog extends StatefulWidget {
  final Function(int) onComplete;
  final Function onCancel;
  final int cardCount;
  final String title;
  
  CityCardCountDialog({
    @required this.onComplete,
    @required this.onCancel,
    @required this.cardCount,
    @required this.title
  });

  @override
  _CityCardCountDialogState createState() => _CityCardCountDialogState();
}

class _CityCardCountDialogState extends State<CityCardCountDialog> {

  final Color _fillColor = Color.fromRGBO(53, 162, 189, 1.0);
  final Color _outlineColor = Color.fromRGBO(53, 162, 189, 1.0).darker(50);
  final Color _iconColor = Color.fromRGBO(53, 162, 189, 1.0).darker(100);

  int _cardCount;

  void _incrementCardCount() {
    if (_cardCount < 9) {
      setState(() {
        _cardCount++;
      });
    }
  }

  void _decrementCardCount() {
    if (_cardCount > 0) {
      setState(() {
        _cardCount--;
      });
    }
  }

  @override
  void initState() {
    _cardCount = widget.cardCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IntrinsicHeight(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: CustomButtonPainter(color: Color.fromRGBO(100, 100, 100, 1.0)),
              ),
              Positioned(
                right: 10,
                top: 10,
                  child: Material(
                    shape: CircleBorder(),
                    color: _fillColor,
                    clipBehavior: Clip.antiAlias,
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        SystemSound.play(SystemSoundType.click);
                        widget.onCancel();
                        },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.close,
                        color: Colors.white,
                        semanticLabel: Strings.of(context).cancel,
                        size: 24,),
                      ),
                    ),
                  ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 46),
                      child: Text('${widget.title}'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 24)

                        ,),
                    ),
                    SizedBox(height: 20,),

                    IntrinsicHeight(
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// Toggle Buttons
                            IntrinsicWidth(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: _outlineColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 2, left: 2),
                                      child: Material(
                                        color: _fillColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_drop_up),
                                          color: _iconColor,
                                          iconSize: 48,
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            SystemSound.play(SystemSoundType.click);
                                            _incrementCardCount();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: _outlineColor,
                                    height: 2,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: _outlineColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 2, left: 2),
                                      child: Material(
                                        color: _fillColor,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_drop_down),
                                          color: _iconColor,
                                          iconSize: 48,
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            SystemSound.play(SystemSoundType.click);
                                            _decrementCardCount();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 2,
                              color: _outlineColor,
                            ),
                            Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                                ),
                                color: _outlineColor
                              ),
                              child: Container(
                                margin: EdgeInsets.only(top: 2, right: 2, bottom: 2),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8)
                                    ),
                                    color: _fillColor
                                ),
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text('$_cardCount',
                                  style: CustomTextStyle.headingWithShadow(context).copyWith(fontSize: 60)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      child: RaisedButton(
                        color: _fillColor,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Text(Strings.of(context).done.toUpperCase(),
                          style: CustomTextStyle.dialogButtonLabel(),
                        ),
                        onPressed: () {
                          SystemSound.play(SystemSoundType.click);
                          widget.onComplete(_cardCount);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
