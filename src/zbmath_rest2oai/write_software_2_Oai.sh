#!/bin/bash

#mkdir temp_folder_software_metadata
echo 0 > last_id.txt
python3 run_get_all_de_software.py
rm last_id.txt