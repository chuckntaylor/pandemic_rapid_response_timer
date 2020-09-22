/*
 * Created by Chuck Taylor on 19/05/20 10:45 AM
 * Copyright (c) 2020. All rights reserved.
 * Last modified 14/05/20 10:58 PM
 */

import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pandemic_timer/localizations/app_localizations_delegate.dart';
import 'package:pandemic_timer/localizations/localizations_util.dart';
import 'package:pandemic_timer/services/service_locator.dart';
import 'package:pandemic_timer/ui/views/difficulty_screen.dart';

// Flare animations global warmup.
List<AssetFlare> _assetsToWarmup = [
  AssetFlare(bundle: rootBundle, name: "assets/animations/sandTimer.flr"),
  AssetFlare(bundle: rootBundle, name: "assets/animations/timeTokens.flr"),
];

Future<void> warmupFlare() async {
  for (final asset in _assetsToWarmup) {
    await cachedActor(asset);
  }
}

void main() {
  setupServiceLocator();
  // Newer versions of Flutter require initializing widget-flutter binding
  // prior to warming up the cache.
  WidgetsFlutterBinding.ensureInitialized();
  // Don't prune the Flare cache, keep loaded Flare files warm and ready
  // to be re-displayed.
  FlareCache.doesPrune = false;
  // Warm the cache up.
  warmupFlare().then((_) {
    // Finally start the app.
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [AppLocalizationsDelegate(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
      supportedLocales: [
        Locale('en', 'EN'), // English
        Locale('fr', 'FR'), // French
      ],
      onGenerateTitle: (BuildContext context) => Strings.of(context).title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DifficultySelectionScreen(),
    );
  }
}
