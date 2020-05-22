After making changes to the string_resources.dart file, the templates can be updated by running the following
command from the main directory

$ bash ./scripts/sync_new_strings.sh


To add a new language, run the following command from the main directory
** the 'pt_pt' gets replaced by the language and region code to be added.
** example: fr_CA
** or simply the language code - example: fr

$ bash ./scripts/add_new_language.sh pt_pt