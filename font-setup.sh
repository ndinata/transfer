#!/usr/bin/env bash

echo "Commence font-setup."

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
    echo "Error: the SFMono font files seem to be missing, or their extension is not .otf"
    echo "Please check this directory:"
    echo
    echo "$sf_source_dir"
    echo
    echo "If they're there, please manually install them."
fi

lato_source_url="https://www.fontsquirrel.com/fonts/download/lato"
lato_temp_download_dir="$HOME/Downloads/lato"
lato_test_file="Lato-Regular.ttf"
lato_target_dir="$HOME/Library/Fonts"

echo "Downloading Lato font files into $lato_temp_download_dir as a zip file..."
mkdir $lato_temp_download_dir
curl $lato_source_url -o $lato_temp_download_dir/lato.zip

echo "Extracting the zip file..."
unzip $lato_temp_download_dir/lato.zip -d $lato_temp_download_dir/

if [ -f $lato_temp_download_dir/$lato_test_file ]; then
    echo "The font files are available! Installing them..."
    mv $lato_temp_download_dir/Lato*.ttf $lato_target_dir/

    echo "The following font files have been installed in $lato_target_dir:"
    for fontfile in $lato_target_dir/Lato*.ttf; do
        echo "        $fontfile"
    done

    echo "Cleaning up temporary download folder..."
    rm -rf $lato_temp_download_dir
else
    echo "Error: the Lato font files seem to be missing, or their extension is not .ttf"
    echo "Please check this directory:"
    echo
    echo "$lato_temp_download_dir"
    echo
    echo "If the files are there, please manually install them."
fi

echo "font-setup is done!"
