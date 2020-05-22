/*
 * Created by Chuck Taylor on 14/05/20 10:44 PM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 14/05/20 10:44 PM
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pandemic_timer/localizations/resources/string_resources.dart';
import 'package:intl/intl.dart';

import 'package:pandemic_timer/l10n/dart/messages_all.dart';

class AppLocalizations with StringResources {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
    locale.countryCode.isEmpty ? locale.languageCode : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

}
