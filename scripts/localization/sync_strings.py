import json, glob, os, collections
from collections import OrderedDict

folder_path = 'lib/l10n/arb/'

dataToWrite = {}
with open(os.path.join(folder_path,'intl_messages.arb')) as json_file:
    dataToWrite = json.load(json_file)

for filename in glob.glob(os.path.join(folder_path, 'intl_*.arb')):
    if filename != os.path.join(folder_path,'intl_messages.arb'):
        with open(filename, 'r+') as json_file:
            currentJson = json.load(json_file, object_pairs_hook=OrderedDict)
            for item in dataToWrite:
                if item not in currentJson:
                    currentJson[item] = dataToWrite[item]
                elif item == '@@last_modified':
                    currentJson[item] = dataToWrite[item]
            for item in currentJson:
                if item not in dataToWrite:
                    del currentJson[item]
            jsonString = json.dumps(currentJson, indent=2)
            json_file.seek(0)
            json_file.write(jsonString)
            json_file.truncate()