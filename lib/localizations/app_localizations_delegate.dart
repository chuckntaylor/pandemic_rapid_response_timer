/*
 * Created by Chuck Taylor on 14/05/20 10:45 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 14/05/20 10:45 PM
 */

import 'package:flutter/material.dart';
import 'package:pandemic_timer/localizations/app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  @override
  bool isSupported(Locale locale) {
    return ['en','fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;

}