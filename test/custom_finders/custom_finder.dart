/*
 * Created by Chuck Taylor on 10/06/20 1:34 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 10/06/20 1:34 PM
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

abstract class CustomFinder {

  static Finder findRichText(String textToMatch) {
    return find.byWidgetPredicate(
          (Widget widget) => (widget is RichText) && widget.text.toPlainText() == textToMatch,
      description: 'Rich text is $textToMatch',
    );
  }

  static Finder findRichTextThatContains(String textToMatch) {
    return find.byWidgetPredicate(
          (Widget widget) => (widget is RichText) && widget.text.toPlainText().contains(textToMatch),
      description: 'Rich text contains $textToMatch',
    );
  }
}