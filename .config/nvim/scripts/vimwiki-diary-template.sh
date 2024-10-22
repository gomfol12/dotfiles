#!/bin/sh

date_format="+%a %d %B %Y"

if [ -n "$1" ]; then
    filename=$(basename "$1")
    filename="${filename%.*}"

    date=$(date "$date_format" -d "$filename")
fi

date=$(date "$date_format")

echo "# $date

## Todo

- [ ]

## Notes"
