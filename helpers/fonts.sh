#!/usr/bin/env bash

echo "Fonts"
echo "$DIVIDER"

sf_source_dir="/Applications/Utilities/Terminal.app/Contents/Resources/Fonts"
sf_test_file="SFMono-Regular.otf"
sf_target_dir="$HOME/Library/Fonts"

echo -n "Looking for SFMono font files..."
if [ -f $sf_source_dir/$sf_test_file ]; then
    echo -e "\rLooking for SFMono font files... They're available!"
    echo -n "Installing them..."
    cp $sf_source_dir/SFMono*.otf $sf_target_dir

    echo "The following font files have been installed in $sf_target_dir:" >> "$FONT_LOGFILE"
    for fontfile in $sf_target_dir/SFMono*.otf; do
        echo "        $fontfile" >> "$FONT_LOGFILE"
    done
    echo -e "\rInstalling them... Done! $SUCCESS"
else
    errcho "$ERROR SFMono font files seem to be missing, or their extension is not .otf"
    errcho "Please check this directory:"
    errcho
    errcho "    $sf_source_dir"
    errcho
    errcho "If the files are there, please manually install them."
fi

echo && echo
