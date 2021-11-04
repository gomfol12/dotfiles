#!/bin/bash
#
# Start a composition manager.
# (xcompmgr in this case)

comphelp() {
    echo "Composition Manager:"
    echo "   (re)start:      comp"
    echo "   stop:           comp -s"
    echo "   toggle:         comp -t"
    echo "   toggle(notify): comp -tn"
    echo "   query:          comp -q"
    echo "                   returns 0 if composition manager is running, else 1"
    exit
}

checkcomp() {
    pgrep xcompmgr &>/dev/null
}

stopcomp() {
    checkcomp && killall xcompmgr
}

startcomp() {
    stopcomp
    xcompmgr -c &
}

togglecomp() {
    checkcomp && stopcomp || startcomp
}

togglenotifycomp() {
    checkcomp && (stopcomp && notify-send "xcompmgr killed") || (startcomp && notify-send "xcompmgr started")
}

case "$1" in
    "")   startcomp; exit ;;
    "-q") checkcomp ;;
    "-s") stopcomp; exit ;;
    "-t") togglecomp; exit ;;
    "-tn") togglenotifycomp; exit ;;
    *)    comphelp ;;
esac
