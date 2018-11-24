#!/usr/bin/env bash

echo "Commence font-setup."

echo "Looking for SF Mono font..."
source_font_path="/Applications/Utilities/Terminal.app/Contents/Resources/Fonts"
font_file="SFMono-Regular.otf"
target_font_path="$HOME/Library/Fonts"

if [ -f $source_font_path/$font_file ]; then
    echo "The font files are available! Installing them..."
    cp $source_font_path/SFMono*.otf $target_font_path

    echo "The following font files have been installed in $target_font_path:"
    for fontfile in $target_font_path/SFMono*.otf; do
        echo "        $fontfile"
    done
else
    echo "The fonts seem to be missing, or something must've gone wrong."
    echo "Please check this directory:"
    echo
    echo "$source_font_path"
    echo
    echo "If they're there, please manually install them."
fi

echo "font-setup is done!"
