#!/usr/bin/env bash

sf_source_dir="/System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts"
sf_test_file="SF-Mono-Regular.otf"
sf_target_dir="$HOME/Library/Fonts"

###########################################################################

echo_header "Fonts"
echo "$DIVIDER"

if [[ $IS_SHOWCASE_MODE == true ]]; then
    try_action "Looking for SFMono font files"
    echo && echo
    return 0
fi

# Install SFMono font, if available
are_fontfiles_available=false

echo -n "Looking for SFMono font files..."
if [ -f $sf_source_dir/$sf_test_file ]; then
    are_fontfiles_available=true
fi

if [[ "$are_fontfiles_available" == true ]]; then
    echo -e "\rLooking for SFMono font files... They're available!"
    echo -n "Copying them..."

    cp $sf_source_dir/SF-Mono*.otf $sf_target_dir

    echo "The following font files have been copied to $sf_target_dir:" >> "$FONT_LOGFILE"
    for fontfile in $sf_target_dir/*.otf; do
        echo "        $fontfile" >> "$FONT_LOGFILE"
    done
    echo -e "\rCopying them... Done! $SUCCESS"
else
    echo -e "\rLooking for SFMono font files... $FAIL"
    errcho "$ERROR SFMono font files seem to be missing, or their extension is not .otf"
    errcho "Please check this directory:"
    errcho
    errcho "    $sf_source_dir"
    errcho
    errcho "If the files are there, please manually install them."
fi

echo && echo
