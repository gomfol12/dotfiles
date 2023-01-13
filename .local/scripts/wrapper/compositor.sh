#!/bin/sh
#
# Start a composition manager.

compositor_command="xcompmgr -cfCF -D10 -I.1 -O.1"
compositor_name="xcompmgr"

help()
{
    echo "Composition Manager:"
    echo "   (re)start:      compositor.sh"
    echo "   stop:           compositor.sh -s"
    echo "   toggle:         compositor.sh -t"
    echo "   toggle(notify): compositor.sh -tn"
    echo "   query:          compositor.sh -q"
    echo "                   returns 0 if composition manager is running, else 1"
}

check()
{
    pgrep -u "$(id -u)" -nf "^$compositor_name" >/dev/null 2>&1
}

stop()
{
    check && killall "$compositor_name"
}

start()
{
    stop
    $compositor_command &
}

toggle()
{
    if check; then
        stop
    else
        start
    fi
}

togglenotify()
{
    if check; then
        stop
        notify-send "$compositor_name killed"
    else
        start
        notify-send "$compositor_name started"
    fi
}

case "$1" in
"")
    start
    exit
    ;;
"-q") check ;;
"-s")
    stop
    exit
    ;;
"-t")
    toggle
    exit
    ;;
"-tn")
    togglenotify
    exit
    ;;
*)
    help
    exit
    ;;
esac
