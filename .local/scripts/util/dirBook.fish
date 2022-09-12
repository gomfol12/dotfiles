#!/bin/fish
# TODO: rework
set -g bookmark_file "$HOME/doc/notizen/bookmarks/dirs"

if ! [ -f "$bookmark_file" ]
    touch "$bookmark_file"
end

function dirBook
    function log
        printf "DirBook: %s\n" "$argv[1]"
    end

    function help
        echo "usage:
    dirBook.sh [-hlcdgs] [name] [shortcut] [path]
        help:             -h
        list:             -l
        create:           -c <name> <shortcut> <path>
        delete:           -d <name>
        goto_name:        -g <name>
        goto_shortcut:    -s <shortcut>
        get_dir:          -get <name>"
    end

    function goto_name
        cd (get_dir "$argv[1]")
    end

    function goto_shortcut
        cd (sed -n "/^shortcut:\"$argv[1]\"/{N;p}" "$bookmark_file" | tail -1 | sed 's/^path:"\(.*\)"/\1/')
    end

    function get_dir
        sed -n "/^name:\"$argv[1]\"/{N;N;p}" "$bookmark_file" | tail -1 | sed 's/^path:"\(.*\)"/\1/'
    end

    # creates a bookmark in the format "<name> <shortcut> <path>"
    function create
        if grep -q "^name:\"$argv[1]\"" "$bookmark_file"
            log "Name already exists"
            return 1
        end
        if grep -q "^shortcut:\"$argv[2]\"" "$bookmark_file"
            log "Shortcut already exists"
            return 1
        end
        if ! [ -d "$argv[3]" ]
            log "Directory doesn't exist"
            return 1
        end

        echo "name:\"$argv[1]\"
shortcut:\"$argv[2]\"
path:\"$(realpath "$argv[3]")\"" >>"$bookmark_file"
    end

    function delete
        sed -i "/^name:\"$argv[1]\"/,+2 d" "$bookmark_file"
    end

    function list
        cut -d":" -f2 "$bookmark_file" | sed 's/"\(.*\)".*/\1/' | sed 'N;N;s/\n/ /g'
    end

    switch "$argv[1]"
        case "-h"
            help
        case "-l"
            list
        case "-c"
            if [ (count $argv) -eq 4 ]
                create "$argv[2]" "$argv[3]" "$argv[4]"
            else
                help
            end
        case "-d"
            if [ (count $argv) -eq 2 ]
                delete "$argv[2]"
            else
                log "No name provided"
            end
        case "-g"
            if [ (count $argv) -eq 2 ]
                goto_name "$argv[2]"
            else
                log "No name provided"
            end
        case "-s"
            if [ (count $argv) -eq 2 ]
                goto_shortcut "$argv[2]"
            else
                log "No shortcut provided"
            end
        case "-get"
            if [ (count $argv) -eq 2 ]
                get_dir "$argv[2]"
            else
                log "No name provided"
            end
        case "*"
            if [ (count $argv) -eq 1 ]
                goto_shortcut "$argv[1]"
            else
                help
            end
    end
end

# check if script is sourced and exexute dirBook function
if ! string match -q -- "*from sourcing file*" (status)
    dirBook $argv
end
