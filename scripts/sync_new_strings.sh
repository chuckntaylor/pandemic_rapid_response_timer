#!/usr/bin/env bash

bash scripts/localization/dart_to_arb.sh

python scripts/localization/sync_strings.py

bash scripts/localization/arb_to_dart.sh