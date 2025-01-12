#!/bin/sh
set -f

if [ "$1" = "-nl" ]; then
    SAVEIFS=$IFS
    IFS=$(printf "\n\b")
    shift
fi

if [ "$1" = "-d" ]; then
    extract_to_dir=1
    shift
fi

# idk why shellcheck is complaining here. With quotes it don't work
for file in $@; do
    if [ "$extract_to_dir" = 1 ]; then
        case "$file" in
        *.zip) unzip "$file" -d "$(basename "$file" .zip)" ;;
        *.tar.gz | *.tgz) tar xzvf "$file" --one-top-level ;;
        *.tar.bz2 | *.tbz2) tar xjvf "$file" --one-top-level ;;
        *.tar.xz) tar xJvf "$file" --one-top-level ;;
        *.tar.lzma) tar --lzma -xvf "$file" --one-top-level ;;
        *.tar) tar xvf "$file" --one-top-level ;;
        *.gz) gunzip "$file" ;;
        *.bz2) bunzip2 "$file" ;;
        *.rar) unrar x "$file" "$(basename "$file" .rar)/" ;;
        *.Z) uncompress "$file" ;;
        *.7z) 7z x "$file" -o"$(basename "$file" .7z)/" ;;
        *) printf "File: %s: Unsupported format\n" "$file" ;;
        esac
    else
        case "$file" in
        *.zip) unzip "$file" ;;
        *.tar.gz | *.tgz) tar xzvf "$file" ;;
        *.tar.bz2 | *.tbz2) tar xjvf "$file" ;;
        *.tar.xz) tar xJvf "$file" ;;
        *.tar.lzma) tar --lzma -xvf "$file" ;;
        *.tar) tar xvf "$file" ;;
        *.gz) gunzip "$file" ;;
        *.bz2) bunzip2 "$file" ;;
        *.rar) unrar x "$file" ;;
        *.Z) uncompress "$file" ;;
        *.7z) 7z x "$file" ;;
        *) printf "File: %s: Unsupported format\n" "$file" ;;
        esac
    fi
done

if [ "$1" = "-nl" ]; then
    IFS=$SAVEIFS
fi
