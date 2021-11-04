#!/bin/sh

if [ "$#" -eq 3 ]; then
    alg=$1
    file=$2
    sum=$3
elif [ "$#" -eq 2 ]; then
    alg=sha256sum
    file=$1
    sum=$2
else
    printf "Invalid argument/s\n"
    printf "usage: cksum.sh [alg: default sha256sum] <file> <sum>\n"
    exit 1
fi

if ! command -v "$alg" >/dev/null 2>&1; then
    printf "alg does not exist, install %s\n" "$alg"
    exit 1
fi

if [ ! -f "$file" ]; then
    printf "%s is not a file\n" "$file"
    exit 1
fi

if [ "$($alg "$file" | cut -d' ' -f1)" = "$sum" ]; then
    printf "cksum is correct\n"
    exit 0
else
    printf "cksum is not correct. Something went wrong!!!\n"
    exit 1
fi
