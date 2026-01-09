#!/bin/sh

elapsed_time()
{
    start_time="$1"

    start_epoch=$(date -d "$start_time" +%s 2>/dev/null)
    now_epoch=$(date +%s)

    # if start time is in the future, assume it was yesterday
    if [ "$start_epoch" -gt "$now_epoch" ]; then
        start_epoch=$(date -d "yesterday $start_time" +%s)
    fi

    elapsed=$((now_epoch - start_epoch))
    hours=$((elapsed / 3600))
    minutes=$(((elapsed % 3600) / 60))

    printf '%02d:%02d' "$hours" "$minutes"
}

klog bookmarks list | awk -F' -> ' '{print $2}' | sort -u | while read -r path; do
    start_time=$(klog json "$path" |
        jq -r '.records[].entries[] | select(.type=="open_range") | .start' |
        head -n1)

    [ -z "$start_time" ] && continue

    elapsed=$(elapsed_time "$start_time")
    name=$(basename "$path" ".klg")

    printf '%s(%s) ' "$elapsed" "$(expr "$name" : '\(.\)')"
done
