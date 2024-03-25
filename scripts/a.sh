#!/bin/bash

echo "Please choose between the main-release or the rolling-release (development version):"
version=$(gum choose "main-release" "rolling-release")
if [ "$version" == "main-release" ]; then
    echo 'aaa'
elif [ "$version" == "rolling-release" ]; then
    echo 'bbb'
else
	exit 130
fi
echo ":: Download complete."
