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
usage: $programm_name [-h]
        -h      help
EOF
    }

    dir_change()
    {
        arg1=$1

        # if file ask for opening with editor
        if [ -f "$arg1" ]; then
            log "$arg1 is a file."
            if [ -n "$EDITOR" ]; then
                open_with_editor=""

                if [ -n "$ZSH_VERSION" ]; then
                    vared -p "open with $EDITOR? (y/n): " -c open_with_editor
                else
                    read -p "open with $EDITOR? (y/n): " -r open_with_editor
                fi

                if echo "$open_with_editor" | grep -E "^[yY]" -q || [ -z "$open_with_editor" ]; then
                    nvim "$arg1"
                    return 0
                fi
            fi
            return 1
        fi

        if ! [ -d "$arg1" ]; then
            log "no such file or directory: $arg1"
            return 1
        fi

        # save history
        if ! [ "$2" = "nosave" ]; then
            save="name:${arg1}:path:$(realpath "$arg1")"
            save_hash=$(printf "%s" "$save" | md5sum | cut -d' ' -f1)
            sed -i "/$save_hash/d" "$history_file"
            printf "%s\n" "md5:${save_hash}:time:$(date +%s):${save}" >>"$history_file"
        fi

        \cd "$arg1" || return 1
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
        arg1=$1
        lf_open=0

        if [ -z "$arg1" ]; then
            arg1="$HOME"
        fi

        # for my own stupidity
        if [ "$(echo "$arg1" | tail -c 2)" = "f" ]; then
            if ! [ -d "$arg1" ]; then
                arg1="$(echo "$arg1" | head -c -2)"
                lf_open=1
            fi
        fi

        # main change or jump "logic"
        if ! [ -d "$arg1" ] && grep "^name:$arg1:" "$shortcut_file" -q; then
            dir_change "$(grep "^name:$arg1:" "$shortcut_file" | cut -d':' -f4)" "nosave"
        else
            if ! [ "$arg1" = ".." ] && grep -E 'name:[^:]+'"$arg1"':' "$history_file" -q; then
                dir_change "$(grep -E 'name:[^:]+'"$arg1"':' "$history_file" | cut -d':' -f8 | tail -1)" "nosave"
            elif ! [ "$arg1" = ".." ] && grep "path:.*$arg1$" "$history_file" -q; then
                dir_change "$(grep "path:.*$arg1$" "$history_file" | cut -d':' -f8 | tail -1)" "nosave"
            else
                dir_change "$arg1"
            fi
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
