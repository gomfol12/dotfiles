#!/bin/sh
set -f

if [ "$1" = "-nl" ]; then
    SAVEIFS=$IFS
    IFS=$(printf "\n\b")
    shift
fi

# idk why shellcheck is complaining here. With quotes it don't work
for file in $@; do
    case "$file" in
    *.zip) unzip "$file" ;;
    *.tar.gz) tar xzvf "$file" ;;
    *.tar.bz2) tar xjvf "$file" ;;
    *.tar.xz) tar xJvf "$file" ;;
    *.tar.lzma) tar -x --lzma -f "$file" ;;
    *.tar) tar xvf "$file" ;;
    *.gz) gunzip "$file" ;;
    *.bz2) bunzip2 "$file" ;;
    *.rar) unrar x "$file" ;;
    *.tbz2) tar xjvf "$file" ;;
    *.tgz) tar xzvf "$file" ;;
    *.Z) uncompress "$file" ;;
    *.7z) 7z x "$file" ;;
    *) printf "File: %s: Unsupported format\n" "$file" ;;
    esac
done

if [ "$1" = "-nl" ]; then
    IFS=$SAVEIFS
fi
