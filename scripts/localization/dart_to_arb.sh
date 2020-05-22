#!/usr/bin/env bash

flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n/arb lib/localizations/resources/string_resources.dart
