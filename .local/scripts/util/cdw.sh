#!/bin/bash

CDW_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"

CDW_SHORTCUT_FILE="$HOME/doc/bookmarks/cdw_dirs"
CDW_HISTORY_FILE="$CDW_CACHE_DIR/cdw_history"

CDW_PROGRAM_NAME="cdw.sh"

\mkdir -p "$HOME/doc/bookmarks/"
\mkdir -p "$CDW_CACHE_DIR/"

\touch "$CDW_SHORTCUT_FILE" "$CDW_HISTORY_FILE"

cdw()
{
    log()
    {
        printf '%s: %s\n' "$CDW_PROGRAM_NAME" "$1"
    }

    real()
    {
        realpath "$1" 2>/dev/null || readlink -f "$1"
    }

    help()
    {
        cat <<EOF
usage:
  cdw [query]
  cdw -a <name> <path>     add shortcut
  cdw -r <name>            remove shortcut
  cdw -l                   list shortcuts
  cdw -hl                  list history
  cdw -hc                  clear history
  cdw -h                   help

examples:
  cdw proj
  cdw h/d/d/p
  cdw -a dev ~/doc/dev
EOF
    }

    save_history()
    {
        local file_path
        local tmp
        file_path="$(real "$1")"
        tmp=$(\mktemp)

        awk -F '\t' -v p="$file_path" '$2 != p' "$CDW_HISTORY_FILE" >"$tmp" &&
            \mv "$tmp" "$CDW_HISTORY_FILE"

        printf '%s\t%s\n' "$(\date +%s)" "$file_path" >>"$CDW_HISTORY_FILE"
    }

    list_shortcuts()
    {
        column -t -s $'\t' "$CDW_SHORTCUT_FILE"
    }

    list_history()
    {
        column -t -s $'\t' "$CDW_HISTORY_FILE"
    }

    clear_history()
    {
        : >"$CDW_HISTORY_FILE"
    }

    add_shortcut()
    {
        local name="${1:-}"
        local file_path="${2:-}"

        if [ -z "$name" ] || [ -z "$file_path" ]; then
            log "usage: cdw -a <name> <path>"
            return 1
        fi

        file_path="$(real "$file_path")"

        if ! [ -d "$file_path" ]; then
            log "directory does not exist"
            return 1
        fi

        if awk -F '\t' -v n="$name" '$1 == n' "$CDW_SHORTCUT_FILE" | grep . >/dev/null; then
            log "shortcut already exists"
            return 1
        fi

        printf '%s\t%s\n' "$name" "$file_path" >>"$CDW_SHORTCUT_FILE"

        log "added shortcut '$name'"
    }

    remove_shortcut()
    {
        local name="${1:-}"

        if [ -z "$name" ]; then
            log "usage: cdw -r <name>"
            return 1
        fi

        tmp=$(mktemp)

        awk -F '\t' -v n="$name" '$1 != n' "$CDW_SHORTCUT_FILE" >"$tmp" &&
            \mv "$tmp" "$CDW_SHORTCUT_FILE"

        log "removed shortcut '$name'"
    }

    collect_candidates()
    {
        {
            awk -F '\t' '{ print "0\t" $2 }' "$CDW_SHORTCUT_FILE"
            cat "$CDW_HISTORY_FILE"
        } | awk -F '\t' '
{
    # keep newest timestamp for duplicates
    if (!seen[$2] || $1 > ts[$2]) {
        seen[$2] = 1
        ts[$2] = $1
    }
}

END {
    for (p in ts)
        print ts[p] "\t" p
}
'
    }

    find_best_match()
    {
        # remove trailing 'f' for lf mode
        local query="${1%f}"

        awk -v q="$query" '
BEGIN {
    now = systime()
}

{
    ts = $1
    path = $2

    s = 0

    # exact path
    if (path == q)
        s += 1000

    # basename prefix
    base = path
    sub(".*/", "", base)

    if (index(base, q) == 1)
        s += 300

    # substring
    else if (index(path, q))
        s += 200

    # recency bonus
    if (ts)
        s += int(1000000 / (now - ts + 3600))

    if (s > best) {
        best = s
        best_path = path
    }
}

END {
    print best_path
}
    ' < <(collect_candidates)
    }

    jump()
    {
        local input="${1:-}"

        # default home
        if [ -z "$input" ]; then
            echo "$HOME"
            save_history "$HOME"
            return
        fi

        # special dirs
        case "$input" in
        "." | "..")
            echo "$input"
            return
            ;;
        esac

        # direct path
        if [ -d "$input" ]; then
            echo "$input"
            save_history "$input"
            return
        fi

        # exact shortcut
        local shortcut_match
        shortcut_match="$(awk -F '\t' -v q="$input" '$1 == q { print $2 }' "$CDW_SHORTCUT_FILE")"

        if [ -n "$shortcut_match" ]; then
            echo "$shortcut_match"
            save_history "$shortcut_match"
            return
        fi

        # smart matching
        local match
        match="$(find_best_match "$input")"

        if [ -n "$match" ]; then
            echo "$match"
            save_history "$match"
            return
        fi

        # fallback to input
        echo "$input"
    }

    case "${1:-}" in
    "-h")
        help
        ;;
    "-a")
        add_shortcut "${2:-}" "${3:-}"
        ;;
    "-r")
        remove_shortcut "${2:-}"
        ;;
    "-l")
        list_shortcuts
        ;;
    "-hl")
        list_history
        ;;
    "-hc")
        clear_history
        ;;
    *)
        local target
        target="$(jump "${1:-}")"

        if [ -f "$target" ]; then
            if [ -n "${EDITOR:-}" ]; then
                "$EDITOR" "$target"
            else
                nvim "$target"
            fi

            return
        fi

        \cd "$target" || return 1

        # for my own stupidity
        if [ "${1: -1}" = "f" ]; then
            lf.sh

            last_dir_file="/tmp/lf_last_dir"
            if [ -f "$last_dir_file" ]; then
                newdir="$(cat "$last_dir_file")"
                if [ -d "$newdir" ]; then
                    target="$newdir"
                fi
            fi
        fi
        ;;
    esac
}
