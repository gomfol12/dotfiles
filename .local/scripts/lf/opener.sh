#!/bin/sh
#TODO: multi file

redirect()
{
    exec </dev/null 1>&0 2>&0
}

fork()
{
    exec setsid -f -- "$@"
}

spawn()
{
    redirect
    fork "$@"
}

set -f
id=$1
op=$2

if [ -z "$id" ] || [ -z "$op" ]; then
    printf "first two arguments id and op must be parsed\n"
    exit 1
fi

shift 2
files=$*

if [ -z "$files" ]; then
    printf "please provide one or more files\n"
    exit 1
fi

f=$(printf "%s" "$files" | head -1)
fx=$(printf "%s" "$files" | sed 's/.*/"&"/')

case "$f" in
*.tar.bz | *.tar.bz2 | *.tbz | *.tbz2 | *.tar.gz | *.tgz | *.tar.xz | *.txz | *.zip | *.rar | *.iso)
    mntdir="$f-archivemount"
    [ ! -d "$mntdir" ] && {
        mkdir "$mntdir"
        archivemount "$f" "$mntdir"
        echo "$mntdir" >>"/tmp/__lf_archivemount_$id"
    }
    lf -remote "send $id cd \"$mntdir\""
    lf -remote "send $id reload"
    ;;
*.graphml)
    if [ -n "$DISPLAY" ]; then
        spawn yed "$f"
    fi
    ;;
*.doc | *.docx)
    if [ -n "$DISPLAY" ]; then
        spawn libreoffice "$f"
    fi
    ;;
*.exe)
    if [ -n "$DISPLAY" ]; then
        spawn wine "$f"
    fi
    ;;
*.bluej)
    if [ -n "$DISPLAY" ]; then
        spawn bluej "$f"
    fi
    ;;
*.xopp)
    if [ -n "$DISPLAY" ]; then
        spawn xournalpp "$f"
    fi
    ;;
*.html | *.htm)
    if [ -n "$DISPLAY" ] && [ "$op" = "open_sec" ]; then
        spawn "$BROWSER" "$f"
    else
        $EDITOR "$f"
    fi
    ;;
*.aseprite)
    if [ -n "$DISPLAY" ]; then
        spawn aseprite "$f"
    fi
    ;;
*.mp3)
    if [ -n "$DISPLAY" ]; then
        mpv "$f"
    fi
    ;;
*)
    case $(file --mime-type "$f" -bL) in
    text/* | application/json | inode/x-empty | application/octet-stream | application/x-sega-pico-rom | application/javascript | application/mbox | application/x-object)
        printf "%s" "$fx" | xargs -ro "$EDITOR"
        ;;
    image/x-xcf)
        if [ -n "$DISPLAY" ]; then
            spawn gimp "$f"
        fi
        ;;
    image/*)
        if [ -n "$DISPLAY" ]; then
            spawn sxiv.sh "$fx"
        fi
        ;;
    inode/directory)
        if [ -n "$DISPLAY" ] && [ "$op" = "open_sec" ]; then
            spawn sxiv.sh "$f"
        fi
        ;;
    application/pdf)
        if [ -n "$DISPLAY" ]; then
            spawn zathura.sh "$f"
        fi
        ;;
    *)
        if [ -n "$DISPLAY" ]; then
            spawn xdg-open "$f"
        fi
        ;;
    esac
    ;;
esac
