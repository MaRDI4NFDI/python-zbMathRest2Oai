#!/bin/bash

#mkdir temp_folder_software_metadata
rm last_de.txt
echo 0 > last_de.txt
python3 run_get_all_de_documents.py
rm last_de.txt