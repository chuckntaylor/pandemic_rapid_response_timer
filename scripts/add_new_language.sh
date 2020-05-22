#!/usr/bin/env bash

python scripts/localization/add_new_language.py $1

bash scripts/localization/arb_to_dart.sh