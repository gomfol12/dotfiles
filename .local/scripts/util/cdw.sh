#!/bin/sh
# for bash: replace vared with read
shortcut_file="$HOME/doc/bookmarks/cdw_dirs"
history_file="$HOME/.cache/cdw_history"
programm_name="cdw.sh"

if ! [ -f "$shortcut_file" ]; then
    if ! [ -d "$HOME/doc/bookmarks/" ]; then
        mkdir -p "$HOME/doc/bookmarks/"
    fi
    touch "$shortcut_file"
fi
if ! [ -f "$history_file" ]; then
    if ! [ -d "$HOME/.cache/" ]; then
        mkdir -p "$HOME/.cache/"
    fi
    touch "$history_file"
fi

cdw()
{
    log()
    {
        printf "$programm_name: %s\n" "$1"
    }

    help()
    {
        cat <<EOF
usage: $programm_name [-h|-c|-d|-l|-j|-g|-hl|-hc] [<path>|<shortcut>|<shortcut> <path>]
        -h     help
        -c     create shortcut
        -d     delete shortcut
        -l     list shortcuts
        -j|-g  jump or change to directory
        -hl    list history
        -hc    clear history
EOF
    }

    dir_change()
    {
        # if file ask for opening with editor
        if [ -f "$1" ]; then
            log "$1 is a file."
            if [ -n "$EDITOR" ]; then
                open_with_editor=""

                if [ -n "$ZSH_VERSION" ]; then
                    vared -p "open with $EDITOR? (y/n): " -c open_with_editor
                else
                    read -p "open with $EDITOR? (y/n): " -r open_with_editor
                fi

                if echo "$open_with_editor" | grep -E "^[yY]" -q || [ -z "$open_with_editor" ]; then
                    nvim "$1"
                    return 0
                fi
            fi
            return 1
        fi

        if ! [ -d "$1" ]; then
            log "no such file or directory: $1"
            return 1
        fi

        \cd "$1" || return 1

        # save history
        if ! [ "$2" = "nosave" ]; then
            save="name:${1}"
            save_hash=$(printf "%s" "$save" | md5sum | cut -d' ' -f1)
            sed -i "/$save_hash/d" "$history_file"
            printf "%s\n" "md5:${save_hash}:time:$(date +%s):${save}:path:$(pwd)" >>"$history_file"
        fi
    }

    shortcut_create()
    {
        if [ -z "$1" ] || [ -z "$2" ]; then
            log "usage: $programm_name -c <shortcut> <path>"
            return 1
        fi

        if ! [ -d "$2" ]; then
            log "directory doesn't exist"
            return 1
        fi

        if grep "^name:$1:" "$shortcut_file" -q; then
            log "shortcut already exists"
            return 1
        fi

        printf "%s\n" "name:${1}:path:$(realpath "$2")" >>"$shortcut_file"
    }

    shortcut_delete()
    {
        if [ -z "$1" ]; then
            log "usage: $programm_name -d <shortcut>"
            return 1
        fi

        sed -i "/^name:$1:/d" "$shortcut_file"
    }

    shortcut_list()
    {
        cut -d':' -f2,4 "$shortcut_file" | tr ':' ' ' | column -t
    }

    dir_change_or_jump()
    {
        lf_open=0

        if [ -z "$1" ]; then
            dir_change "$HOME"
            return 0
        fi

        if [ "$1" = ".." ] || [ "$1" = "." ]; then
            dir_change "$1" "nosave"
            return 0
        fi

        searched_shortcut="$(tac "$shortcut_file" | grep -m 1 "^name:$1:")"

        if [ -d "$1" ]; then
            if [ -n "$searched_shortcut" ]; then
                dir_change "$1" "nosave"
            else
                dir_change "$1"
            fi
            return 0
        fi

        input="$1"

        # for my own stupidity
        if [ "$(echo "$input" | tail -c 2)" = "f" ]; then
            input="$(echo "$input" | head -c -2)"
            lf_open=1
        fi

        # main change or jump "logic"
        searched_shortcut="$(tac "$shortcut_file" | grep -m 1 "^name:$input:")"
        searched_history_name="$(tac "$history_file" | grep -E -m 1 'name:[^:]*'"$input"'/?:')"
        searched_history_path="$(tac "$shortcut_file" | grep -E -m 1 "path:.*$input/?$")"

        if [ -n "$searched_shortcut" ]; then
            dir_change "$(echo "$searched_shortcut" | cut -d':' -f4)" "nosave"
        elif [ -n "$searched_history_name" ]; then
            dir_change "$(echo "$searched_history_name" | cut -d':' -f8)" "nosave"
        elif [ -n "$searched_history_path" ]; then
            dir_change "$(echo "$searched_history_path" | cut -d':' -f8)" "nosave"
        else
            dir_change "$input"
        fi

        if [ $lf_open -eq 1 ]; then
            lf.sh
        fi
    }

    history_clear()
    {
        if [ -f "$history_file" ]; then
            rm -f "$history_file"
            touch "$history_file"
        fi
    }

    history_list()
    {
        cut -d':' -f6,8 "$history_file" | tr ':' ' ' | column -t
    }

    case "$1" in
    "-h") help ;;
    "-c") shortcut_create "$2" "$3" ;;
    "-d") shortcut_delete "$2" ;;
    "-l") shortcut_list ;;
    "-j" | "-g") dir_change_or_jump "$2" ;;
    "-hl") history_list ;;
    "-hc") history_clear ;;
    *) dir_change_or_jump "$1" ;;
    esac
}
