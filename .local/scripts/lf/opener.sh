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

if [ "$#" -eq 3 ]; then
    f=$1
    id=$2
    open=$3

    case "$f" in
		*.tar.bz|*.tar.bz2|*.tbz|*.tbz2|*.tar.gz|*.tgz|*.tar.xz|*.txz|*.zip|*.rar|*.iso)
			mntdir="$f-archivemount"
            [ ! -d "$mntdir" ] && {
                mkdir "$mntdir"
                archivemount "$f" "$mntdir"
                echo "$mntdir" >> "/tmp/__lf_archivemount_$id"
            }
            lf -remote "send $id cd \"$mntdir\""
            lf -remote "send $id reload"
            ;;
		*.graphml)
            if [ -n "$DISPLAY" ]; then
                spawn yed "$f"
            fi
            ;;
		*.doc|*.docx)
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
        *.html|*.htm)
            if [ -n "$DISPLAY" ] && [ "$open" = "open_sec" ]; then
                spawn "$BROWSER" "file://$f"
            else
                $EDITOR "$f"
            fi
            ;;
        *)
		    case $(file --mime-type "$f" -bL) in
                text/*|application/json|inode/x-empty|application/octet-stream)
                    $EDITOR "$f"
                    ;;
                image/x-xcf)
                    if [ -n "$DISPLAY" ]; then
                        spawn gimp "$f"
                    fi
                    ;;
                image/*)
                    if [ -n "$DISPLAY" ]; then
                        spawn sxiv.sh "$f"
                    fi
                    ;;
                inode/directory)
                    if [ -n "$DISPLAY" ] && [ "$open" = "open_sec" ]; then
                        spawn sxiv.sh "$f"
                    fi
                    ;;
                *)
                    if [ -n "$DISPLAY" ]; then
                        spawn xdg-open "$f"
                    fi
		    esac
            ;;
    esac
fi
