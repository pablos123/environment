#!/usr/bin/env bash

# Load completions
load_completions() {
    # Load bash completions capabilities
    source /usr/share/bash-completion/bash_completion
    local wanted_completions
    wanted_completions=(
        man git gitk ssh ssh-add sshfs su sudo scp pkill apt fdisk
        grub curl tar mount umount hugo perl mpv vagrant crontab wget
        useradd usermod userdel python3 kill pgrep xrandr
    )
    local completions_dir="/usr/share/bash-completion/completions/"
    if [ -d "$completions_dir" ]; then
        for completion in "${wanted_completions[@]}"; do
            if [[ -f "$completions_dir/$completion" ]] && [[ -r "$completions_dir/$completion" ]]; then
                # 'command' built-in to avoid alias lookups to reduce overheads
                command source "/usr/share/bash-completion/completions/$completion" >/dev/null
            fi
        done
    fi
}

# List all available completions
# Load all completions in bash-completion/completions
list_completions() {
    local completions_dir="/usr/share/bash-completion/completions/"
    echo "Listing completions in $completions_dir:"
    if [ -d "$completions_dir" ]; then
        for completion in "$completions_dir"*; do
            if [[ -f "$completion" ]] && [[ -r "$completion" ]]; then
                echo "$completion"
            fi
        done
    fi
}

# Naza find
# Usage: nfind <name> to not type -name every time
nfind() {
    if [[ -n $1 ]]; then
        find . -name "*$1*" 2>/dev/null
    else
        find . 2>/dev/null
    fi
}

# Print all escape terminal colors
colors() {
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

# Edit the crontab but before create a backup file
ecrontab() {
    crontab -l >"$HOME/crontab.old"
    crontab -e
}

# Copy a lot of the same file with diferent names in a directory
# Usage: copylot <file> <directory_where> <times=100>
copylot() {
    local times
    times=100
    if [[ -n $3 ]]; then
        times=$3
    fi
    if [[ ! $times =~ ^[0-9]+$ ]]; then
        echo "Usage: copylot <file> <directory_where> <times>"
        echo "<times> needs to be non-negative int"
        return
    fi
    local dir
    dir=$2
    if [[ ! -d $dir ]]; then
        echo "Usage: copylot <file> <directory_where> <times>"
        echo "<dir> needs to be a directory"
        return
    fi
    local file
    file=$1
    local i
    i=0
    while ((i++ < times)); do
        if [[ -e "$dir/$i.$file" ]]; then
            continue
        fi
        cp "$file" "$dir/$i.$file"
    done
}

# 'Reset' a git repository. Used for repos that only contains binary files.
reset_repo() {
    branch=$1
    message=$2

    if [[ -z "$branch" ]] || { [[ ! $branch == "main" ]] && [[ ! $branch == "master" ]]; }; then
        echo "Usage: reset_repo 'main/master' ['<commit_message>']"
        return
    fi

    if [[ -z "$message" ]]; then
        message="reset commit"
    fi

    # Checkout to an orphan branch
    git checkout --orphan latest_branch
    # Add all the files
    git add -A
    # Commit the changes
    git commit -m "$message"
    # Delete the master/main branch
    git branch -D "$branch"
    # Rename the current branch to master/main
    git branch -m "$branch"
    # Force update your repository
    git push -f origin "$branch"
    # Set the upstream for next pulls etc
    git branch --set-upstream-to=origin/"$branch"
}

# All my monitors have full hd (1920x1080) resolution and I do not plan to buy some 4k monitor in the near future.
# I do not want 4k wallpapers and with this script I have all my wallpapers with (almost) the same resolution.
# This converts all images to .png and
# Rename images inside each one of the 'type' directories to '<md5sum of the file>.png'.
normalize_wallpapers() {
    images=$(find "$HOME/.wallpapers/" -path "$HOME/.wallpapers/.git" -prune -o -type f -print)
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
