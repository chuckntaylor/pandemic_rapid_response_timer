import json, glob, os, collections, sys
from collections import OrderedDict

folder_path = 'lib/l10n/arb/'

newLanguage = sys.argv[1]

dataToWrite = {}
with open(os.path.join(folder_path,'intl_messages.arb'), 'r') as json_file:
    dataToWrite = json.load(json_file, object_pairs_hook=OrderedDict)

filename = os.path.join(folder_path, 'intl_'+newLanguage+'.arb')
with open(filename, 'w') as json_file:
    jsonString = json.dumps(dataToWrite, indent=2)
    json_file.write(jsonString)
    json_file.truncate()