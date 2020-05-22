/*
 * Created by Chuck Taylor on 14/05/20 10:52 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 14/05/20 10:52 PM
 */

import 'package:flutter/material.dart';
import 'package:pandemic_timer/localizations/app_localizations.dart';

class Strings {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
}