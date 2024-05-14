#!/bin/bash
# DEPS: simple-mtpfs, dmenu, standard shell commands

set -e

log()
{
    printf "%s\n" "$1" | xargs
}

err_handler()
{
    c=$(caller)
    notify-send "${c##*/} failed" "command: ${BASH_COMMAND}"
}
trap err_handler ERR

# format for dmenu
format_mount()
{
    tr ' ' ':' | awk -F':' '{printf "%s %s (%s) %s\n",$1,$3,$5,$6}'
}

# let the user chose a mount point. If it doesn't exist ask if it should be created
get_mount_point()
{
    username=$(whoami)
    mount_point=$(printf "/mnt\n/media\n/mnt\n/mount\n/run/media\n/home/%s/handy\n/home/%s/usb" "$username" "$username" | dmenu_cmd "Select mount point: ") || exit
    test -n "$mount_point"

    if [ ! -d "$mount_point" ]; then
        mkyn=$(printf "no\nyes" | dmenu_cmd "$mount_point does not exist. Create it?") || exit
        [[ "$mkyn" =~ [yY] ]] && (mkdir -p "$mount_point" 2>/dev/null || exec_term sudo mkdir -p "$mount_point")
    fi
}

# small floating terminal as password prompt. Don't forget to set according rule in your window manager
exec_term()
{
    ${TERMINAL:-st} -n floatterm -g 60x1 -e "$@"
}

dmenu_cmd()
{
    dmenu -p "$1" -l 15
}

# check deps
if ! command -v simple-mtpfs dmenu >/dev/null 2>&1; then
    if [ -t 0 ]; then
        log "Dependencies missing!"
    else
        log "Dependencies missing!"
        notify-send "${0##*/} failed" "Dependencies missing!"
    fi
    exit 1
fi

_mount()
{
    # get all connected android devices
    phones=$(simple-mtpfs -l 2>/dev/null | sed "s/^/📱 /")

    # get all drives
    all_drives=$(lsblk -nrpo "uuid,name,type,size,label,mountpoint,fstype")

    # filter for closed luks encryption drives
    all_luks=$(echo "$all_drives" | grep crypto_LUKS) || true
    opened_luks=$(find /dev/disk/by-id/dm-uuid-CRYPT-LUKS2-* | sed "s/.*LUKS2-//;s/-.*//")
    IFS=$'\n'
    closed_luks="$(for drive in $all_luks; do
        uuid=$(echo "$drive" | cut -d" " -f1 | sed "s/-//g")
        for open in $opened_luks; do
            [ "$uuid" = "$open" ] && break
        done && continue
        echo "🔒 $drive"
    done | format_mount)"

    # get all mountable drives
    normal_parts="$(echo "$all_drives" | grep -v crypto_LUKS | grep 'part\|rom\|crypt' | sed "s/^/💾 /" | format_mount)"

    # put all drives together in a list
    all_drives=$(echo "$phones
$closed_luks
$normal_parts" | sed "/^$/d;s/ *$//")
    test -n "$all_drives"

    # chose drive to mount
    chosen=$(echo "$all_drives" | dmenu_cmd "Select drive to mount: ") || exit

    case $chosen in
    💾*)
        # mount drive
        chosen=$(echo "$chosen" | cut -d" " -f2)
        get_mount_point

        exec_term sudo mount "$chosen" "$mount_point"
        notify-send "${0##*/}" "\"$chosen\" mounted to \"$mount_point\""
        ;;
    🔒*)
        # mount encrypted drive
        chosen=$(echo "$chosen" | cut -d" " -f2)
        get_mount_point

        # get first number not in use
        num=0
        while [ -f "/dev/mapper/usb$num" ]; do
            num=$((num + 1))
        done

        exec_term sudo sh -ci 'cryptsetup open '"$chosen"' '"usb$num"' && mount '"/dev/mapper/usb$num"' '"$mount_point"''
        notify-send "${0##*/}" "\"$chosen\" decrypted and mounted to \"$mount_point\""
        ;;
    📱*)
        # mount android device
        chosen=$(echo "$chosen" | cut -d" " -f2 | tr -d ":")
        get_mount_point
        (echo "OK" | dmenu_cmd "Tap Allow on your phone if it asks for permission and then press enter") || exit

        simple-mtpfs --device "$chosen" "$mount_point" || exec_term sudo simple-mtpfs --device "$chosen" "$mount_point"
        notify-send "Android device mounted to \"$mount_point\""
        ;;
    esac
}

_umount()
{
    # get all mounted android phones
    mounted_phones=$(grep simple-mtpfs /etc/mtab | awk '{print "📱 " $2}')

    # get all mounted drives. Excludes /boot, /dev/mapper/root, /home$, SWAP
    lsblk_out=$(lsblk -nrpo "name,type,size,mountpoint,label")
    mounted_drives=$(echo "$lsblk_out" | awk '($4 ~ /\/.*/) && ($2 == "part" || $2 == "crypt") && ($4 !~ /\/boot|\/home$|SWAP/) && ($1 !~ /\/dev\/mapper\/root/) && length($4) > 1 {print}' | awk '($2 == "crypt") {printf "🔓 %s (%s) %s\n",$4,$3,$5} ($2 == "part") {printf "💾 %s (%s) %s\n",$4,$3,$5}')

    # put all together
    all_unmountable_drives=$(echo "$mounted_phones
$mounted_drives" | sed "/^$/d;s/ *$//")
    test -n "$all_unmountable_drives"

    # prompt user to chose drive to umount
    chosen=$(echo "$all_unmountable_drives" | dmenu_cmd "Select drive to unmount: ") || exit
    test -n "$chosen"

    case "$chosen" in
    📱*)
        # umount android device
        chosen=$(echo "$chosen" | cut -d" " -f2)
        umount "$chosen" || exec_term sudo umount "$chosen"
        notify-send "\"$chosen\" has been unmounted."
        ;;
    💾*)
        # umount drives
        chosen=$(echo "$chosen" | cut -d" " -f2)
        exec_term sudo umount "$chosen"
        notify-send "\"$chosen\" has been unmounted."
        ;;
    🔓*)
        # umount encrypted drives
        chosen=$(echo "$chosen" | cut -d" " -f2)
        crypt_id=$(echo "$lsblk_out" | grep "$chosen" | cut -d" " -f1)

        test -b "$crypt_id"

        exec_term sudo sh -ci 'umount '"$crypt_id"' && cryptsetup close '"${crypt_id##*/}"''
        notify-send "\"$crypt_id\" has been unmounted and securely closed."
        ;;
    esac
}

case "$1" in
"mount") ;;
"umount") ;;
*)
    if echo "$0" | grep -qE "[^u]mount.sh"; then
        _mount
    elif echo "$0" | grep -qE "umount.sh"; then
        _umount
    fi
    ;;
esac
