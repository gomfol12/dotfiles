#!/bin/sh
#TODO: pass otp
#TODO: better clear

if ! test -t 0 -a -t 1 -a -t 2; then
    export PINENTRY_USER_DATA=gtk
else
    export PINENTRY_USER_DATA=curses
fi

log()
{
    printf "%s\n" "$1" | xargs
}

list()
{
    #ls --color=auto -1 -F "$PASSWORD_STORE_DIR"
    find "$PASSWORD_STORE_DIR" -not -name ".gpg-id" -type f | sed "s@$PASSWORD_STORE_DIR/@@" | sed 's@\w*\.gpg$@@' | uniq | sort
}

menu()
{
    selection=$(printf "fill user/pass\ncopy username\ncopy password\ncopy email\n" | dmenu)
    [ -z "$selection" ] && exit 1

    acc=$(list | dmenu)
    [ -z "$acc" ] && exit 1

    clipctl disable
    sleep 1

    case $selection in
        "fill user/pass")
            xdotool type --clearmodifiers "$(pass "$acc/username")"
            xdotool key Tab
            xdotool type --clearmodifiers "$(pass "$acc/password")"
            xdotool key Enter
            log "filled user/pass"
            ;;
        "copy username")
            pass "$acc/username" | xclip -selection clipboard
            log "copied username, will be cleared in $PASSWORD_STORE_CLIP_TIME seconds"
            ;;
        "copy password")
            pass "$acc/password" | xclip -selection clipboard
            log "copied password, will be cleared in $PASSWORD_STORE_CLIP_TIME seconds"
            ;;
        "copy email")
            pass "$acc/email" | xclip -selection clipboard
            log "copied email, will be cleared in $PASSWORD_STORE_CLIP_TIME seconds"
            ;;
    esac

    sleep 1
    clipctl enable

    (sleep "$PASSWORD_STORE_CLIP_TIME" && clipctl clear) &
}

case $1 in
    "list") list ;;
    "menu") menu ;;
    *)
        if [ "$#" -eq 0 ]; then
            menu
        else
            echo "Invalid argument";
        fi
esac
