#!/bin/bash

wikidir="/usr/share/doc/arch-wiki/html/en/"

docs=$(find $wikidir -iname "*.html")

choice=$(echo "$docs" | cut -d "/" -f8- | sed 's/.html$//g' | sort | dmenu -l 20 -p "Arch Wiki Search: ")

if [ -n "$choice" ]; then
    if [ -z "$BROWSER" ] || ! command -v "$BROWSER" >/dev/null 2>&1; then
        xdg-open "$wikidir$choice.html"
    fi
    $BROWSER "$wikidir$choice.html"
fi
