#!/bin/sh
#
# Start a composition manager.
# (picom in this case)

help()
{
    echo "Composition Manager:"
    echo "   (re)start:      picom.sh"
    echo "   stop:           picom.sh -s"
    echo "   toggle:         picom.sh -t"
    echo "   toggle(notify): picom.sh -tn"
    echo "   query:          picom.sh -q"
    echo "                   returns 0 if composition manager is running, else 1"
}

check()
{
    pgrep -u "$(id -u)" -nf "^picom$" > /dev/null 2>&1
}

stop()
{
    check && killall picom
}

start()
{
    stop
    picom &
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
        notify-send "picom killed"
    else
        start
        notify-send "picom started"
    fi
}

case "$1" in
    "") start; exit ;;
    "-q") check ;;
    "-s") stop; exit ;;
    "-t") toggle; exit ;;
    "-tn") togglenotify; exit ;;
    *) help; exit ;;
esac
