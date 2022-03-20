#!/bin/fish

set -l tmp (mktemp)
set -l fid (mktemp)
lf.sh -command '$printf $id > '"$fid"'' -last-dir-path="$tmp" "$argv"
set -l id (cat "$fid")
set -l archivemount_dir "/tmp/__lf_archivemount_$id"
if [ -f "$archivemount_dir" ]
    cat "$archivemount_dir" |
        while read line
            umount "$line"
            rmdir "$line"
        end
    rm -f "$archivemount_dir" 1>/dev/null
end
if [ -f "$tmp" ]
    set -l dir (cat "$tmp")
    rm -f "$tmp" 1>/dev/null
    if [ -d "$dir" ]
        if [ "$dir" != (pwd) ]
            cd "$dir"
        end
    end
end
printf "\033]0; $TERMINAL\007" >/dev/tty
