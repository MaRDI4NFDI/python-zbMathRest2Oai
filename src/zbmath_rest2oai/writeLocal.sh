#!/bin/bash

#mkdir temp_folder_software_metadata
mkdir temp_folder_software_metadata
python3 run_write_local_all_software.py
zip -r swmath_metadata.zip temp_folder_software_metadata/
rm -r temp_folder_software_metadata