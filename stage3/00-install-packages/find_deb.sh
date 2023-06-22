#!/bin/bash

# Find the file matching the pattern
deb_file=$(find . -type f -name 'p7zip-rar_*_armhf.deb' -print -quit)

# Check if the file was found
if [[ -n "$deb_file" ]]; then
    echo "File found: $deb_file"
    # Assign the file path to a variable
    file_path=$deb_file
    echo "File path assigned to variable: $file_path"
else
    echo "File not found"
fi

echo "sudo dpkg -i $file_path"
