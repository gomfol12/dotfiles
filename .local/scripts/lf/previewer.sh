#!/bin/sh
draw()
{
    "$SCRIPT_DIR/lf/draw_img.sh" "$@"
    exit 1
}

hash()
{
    printf '%s/.cache/lf/%s' "$HOME" \
        "$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$1")" | sha256sum | awk '{print $1}')"
}

cache()
{
    if [ -f "$1" ]; then
        draw "$@"
    fi
}

file="$1"
shift

head_num=-50
fold_width=80

# exiftool
case "$file" in
*.pdf)
    if [ -n "$FIFO_UEBERZUG" ] || [ "$TERM" = "xterm-kitty" ]; then
        cache="$(hash "$file")"
        cache "$cache.jpg" "$@"
        pdftoppm -f 1 -l 1 \
            -scale-to-x 1920 \
            -scale-to-y -1 \
            -singlefile \
            -jpeg \
            -- "$file" "$cache"
        draw "$cache.jpg" "$@"
    else
        pdftotext -nopgbrk -q -- "$file" -
    fi
    ;;
*.docx | *.odt | *.epub) pandoc -s -t plain -- "$file" | head "$head_num" ;;
*.doc) catdoc "$file" | head "$head_num" ;;
*.zip) zipinfo "$file" | head "$head_num" ;;
*.7z) 7z l "$file" | tail -n +2 | head "$head_num" ;;
*.rar) unrar l "$file" | tail -n +2 | head "$head_num" ;;
*.tar) tar -tvf "$file" | head "$head_num" ;;
*.tar.gz) tar -ztvf "$file" | head "$head_num" ;;
*.tar.bz2) tar -jtvf "$file" | head "$head_num" ;;
*.exe | *.dll | *.img) printf "\033[48;5;7m\033[30mbinary\033[0m\n" ;;
*.o) nm "$file" | head "$head_num" ;;
*.iso) iso-info --no-header "$file" ;;
*.xcf) printf "gimp file format\n" ;;
*.aseprite) printf "aseprite file format\n" ;;
*.gpg) printf "gpg encrypted data\n" ;;
*.pak) printf "pak archive\n" ;;
*.db-shm | *.db-wal) printf "sqlite3 database\n" ;;
*)
    case "$(file -Lb --mime-type -- "$file")" in
    image/*)
        if [ -n "$FIFO_UEBERZUG" ] || [ "$TERM" = "xterm-kitty" ]; then
            orientation="$(identify -format '%[EXIF:Orientation]\n' -- "$file")"
            if [ -n "$orientation" ] && [ "$orientation" != 1 ]; then
                cache="$(hash "$file").jpg"
                cache "$cache" "$@"
                convert -- "$file" -auto-orient "$cache"
                draw "$cache" "$@"
            else
                draw "$file" "$@"
            fi
        else
            mediainfo "$file"
        fi
        ;;
    video/*)
        if [ -n "$FIFO_UEBERZUG" ] || [ "$TERM" = "xterm-kitty" ]; then
            cache="$(hash "$file").jpg"
            cache "$cache" "$@"
            ffmpegthumbnailer -i "$file" -o "$cache" -s 0
            draw "$cache" "$@"
        else
            mediainfo "$file"
        fi
        ;;
    *) highlight -i "$file" --stdout --out-format=ansi -q --force | head "$head_num" ;;
    esac
    ;;
esac

printf "\n-----\n"
file -Lb -- "$file" | fold -s -w "$fold_width"
