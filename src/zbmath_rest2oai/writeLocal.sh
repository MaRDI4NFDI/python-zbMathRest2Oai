#!/bin/bash

#mkdir temp_folder_software_metadata


if [ -f last_id.txt ]; then
  echo "last_id.txt exists"
  rm last_id.txt
  echo "last_id.txt deleted"
fi
if [ -f swmath_metadata.zip ]; then
  echo "swmath_metadata.zip exists"
  rm swmath_metadata.zip
  echo "swmath_metadata.zip deleted"
fi
if [ -r temp_folder_software_metadata ]; then
  echo "temp_folder_software_metadata exists"
  rm -r temp_folder_software_metadata
  echo "temp_folder_software_metadata deleted"
fi
echo 0 > last_id.txt
mkdir temp_folder_software_metadata
python3 run_write_local_all_software.py
zip -r swmath_metadata.zip temp_folder_software_metadata/
rm -r temp_folder_software_metadata
rm last_id.txt