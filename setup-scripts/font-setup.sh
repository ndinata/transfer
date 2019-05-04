#!/usr/bin/env bash

echo && echo "font-setup.sh"

sf_source_dir="/Applications/Utilities/Terminal.app/Contents/Resources/Fonts"
sf_test_file="SFMono-Regular.otf"
sf_target_dir="$HOME/Library/Fonts"

echo "Looking for SFMono font..."
if [ -f $sf_source_dir/$sf_test_file ]; then
    echo "The font files are available! Installing them..."
    cp $sf_source_dir/SFMono*.otf $sf_target_dir

    echo "The following font files have been installed in $sf_target_dir:"
    for fontfile in $sf_target_dir/SFMono*.otf; do
        echo "        $fontfile"
    done
else
    echo "ERROR: the SFMono font files seem to be missing, or their extension is not .otf"
    echo "Please check this directory:"
    echo
    echo "$sf_source_dir"
    echo
    echo "If the files are there, please manually install them."
fi

echo "end font-setup.sh"
