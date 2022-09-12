#!/bin/sh
# TODO: rework
bookmark_file="$HOME/doc/notizen/bookmarks/dirs"

if ! [ -f "$bookmark_file" ]; then
    touch "$bookmark_file"
fi

dirBook()
{
    log()
    {
        printf "DirBook: %s\n" "$1"
    }

    help()
    {
        cat <<EOF
usage:
    dirBook.sh [-hlcdgs] [name] [shortcut] [path]
        help:             -h
        list:             -l
        create:           -c <name> <shortcut> <path>
        delete:           -d <name>
        goto_name:        -g <name>
        goto_shortcut:    -s <shortcut>
        get_dir:          -get <name>
EOF
    }

    goto_name()
    {
        cd "$(get_dir "$1")" || return
    }

    goto_shortcut()
    {
        cd "$(sed -n "/^shortcut:\"$1\"/{N;p}" "$bookmark_file" | tail -1 | sed 's/^path:"\(.*\)"/\1/')" || return
    }

    get_dir()
    {
        sed -n "/^name:\"$1\"/{N;N;p}" "$bookmark_file" | tail -1 | sed 's/^path:"\(.*\)"/\1/'
    }

    # creates a bookmark in the format "<name> <shortcut> <path>"
    create()
    {
        if grep -q "^name:\"$1\"" "$bookmark_file"; then
            log "Name already exists"
            return 1
        fi
        if grep -q "^shortcut:\"$2\"" "$bookmark_file"; then
            log "Shortcut already exists"
            return 1
        fi
        if ! [ -d "$3" ]; then
            log "Directory doesn't exist"
            return 1
        fi

        cat <<EOF >>"$bookmark_file"
name:"$1"
shortcut:"$2"
path:"$(realpath "$3")"
EOF
    }

    delete()
    {
        sed -i "/^name:\"$1\"/,+2 d" "$bookmark_file"
    }

    list()
    {
        cut -d":" -f2 "$bookmark_file" | sed 's/"\(.*\)".*/\1/' | sed 'N;N;s/\n/ /g'
    }

    case "$1" in
    "-h") help ;;
    "-l") list ;;
    "-c")
        if [ "$#" -eq 4 ]; then
            create "$2" "$3" "$4"
        else
            help
        fi
        ;;
    "-d")
        if [ "$#" -eq 2 ]; then
            delete "$2"
        else
            log "No name provided"
        fi
        ;;
    "-g")
        if [ "$#" -eq 2 ]; then
            goto_name "$2"
        else
            log "No name provided"
        fi
        ;;
    "-s")
        if [ "$#" -eq 2 ]; then
            goto_shortcut "$2"
        else
            log "No shortcut provided"
        fi
        ;;
    "-get")
        if [ "$#" -eq 2 ]; then
            get_dir "$2"
        else
            log "No name provided"
        fi
        ;;
    *)
        if [ "$#" -eq 1 ]; then
            goto_shortcut "$1"
        else
            help
        fi
        ;;
    esac
}

# check if script is sourced and exexute dirBook function
(return 0 2>/dev/null) || dirBook "$@"
