#!/usr/bin/env bash

set -uo pipefail

url="$1"
path="${url#file://}"
line="${path##*#}"
path="${path%%#*}"

state_file="$(kitten @ ls | jq -r '.[].tabs[].windows[].user_vars.kitty_links_server // empty')"

if [[ ! -f "$state_file" ]]; then
    echo "Error: Kitty links server state file not found." >&2
    exit 1
fi

nvim --server "$(cat "$state_file")" --remote-send "<C-\\><C-N>:KittyOpen ${path}:${line}<CR>"
