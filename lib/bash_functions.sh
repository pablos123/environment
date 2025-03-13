#!/usr/bin/env bash

# Print all escape terminal colors
print_color_codes() {
    for x in {0..8}; do
        echo -ne "\e[$x""m\\\e[$x""m\e[0m "
        echo
    done
    for x in {0..8}; do
        for i in {30..37}; do
            echo -ne "\e[$x;$i""m\\\e[$x;$i""m\e[0m "
        done
        echo
    done
    for x in {0..8}; do
        for i in {30..37}; do
            for a in {40..47}; do
                echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0m "
            done
            echo
        done
    done
    echo -ne "\e[0m"
}

# All my monitors have full hd (1920x1080) resolution and I do not plan to buy some 4k monitor in the near future.
# I do not want 4k wallpapers and with this script I have all my wallpapers with (almost) the same resolution.
# This converts all images to .png and
# Rename images inside each one of the 'type' directories to '<md5sum of the file>.png'.
normalize_wallpapers() {
    images=$(find "${HOME}/.wallpapers/" -path "${HOME}/.wallpapers/.git" -prune -o -type f -print)
    for image in $images; do
        current_sum=$(md5sum "$image" | awk '{print $1}')
        image_dirname=$(dirname "$image")

        converted_image="$image_dirname/$current_sum.png"
        if [[ $image == "$converted_image" ]]; then
            # Already converted
            continue
        fi

        convert "$image" -depth 8 -resize '1920x1080!' rgb32:"$converted_image"
        new_sum=$(md5sum "$converted_image" | awk '{print $1}')
        mv "$converted_image" "$image_dirname/$new_sum.png"

        rm -f "$image"
    done
}
