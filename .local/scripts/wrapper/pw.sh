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
    find "$PASSWORD_STORE_DIR" -mindepth 3 -not -name ".gpg-id" -not -path "*trash_bin*" -not -path "*.git*" -type d | sed "s@$PASSWORD_STORE_DIR/@@"
}

menu()
{
    selection=$(printf "fill user/pass\ncopy username\ncopy password\ncopy email\n" | dmenu -l 10)
    [ -z "$selection" ] && exit 1

    pass_path=$(list | dmenu -l 10)
    [ -z "$pass_path" ] && exit 1

    username=$(printf "%s" "$pass_path" | sed 's@^.*/@@')

    clipctl disable
    sleep 1

    case $selection in
        "fill user/pass")
            xdotool type --clearmodifiers "$username"
            xdotool key Tab
            xdotool type --clearmodifiers "$(pass "$pass_path/password")"
            xdotool key Enter
            log "filled user/pass"
            ;;
        "copy username")
            printf "%s" "$username" | xclip -selection clipboard
            log "copied username, will be cleared in $PASSWORD_STORE_CLIP_TIME seconds"
            ;;
        "copy password")
            pass "$pass_path/password" | xclip -selection clipboard
            log "copied password, will be cleared in $PASSWORD_STORE_CLIP_TIME seconds"
            ;;
        "copy email")
            if [ -f "$PASSWORD_STORE_DIR/$pass_path/email.gpg" ]; then
                pass "$pass_path/email" | xclip -selection clipboard
                log "copied email, will be cleared in $PASSWORD_STORE_CLIP_TIME seconds"
            elif [ ! -f "$PASSWORD_STORE_DIR/$pass_path/email.gpg" ]; then
                printf "%s" "$username" | xclip -selection clipboard
                log "copied email, will be cleared in $PASSWORD_STORE_CLIP_TIME seconds"
            fi
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
            printf "Invalid argument\n"
        fi
        ;;
esac
