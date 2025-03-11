#!/bin/bash

out_file="combined.pdf"
bookmarks_file="/tmp/bookmarks.txt"

if [ -f "$out_file" ]; then
    echo "Error: Output file '$out_file' already exists." >&2
    exit 1
fi

# Read input files separated by newlines
mapfile -t files < <(printf "%s\n" "$@")
page_counter=1

if [ "${#files[@]}" -eq 0 ]; then
    echo "Usage: $0 file1.pdf file2.pdf ..."
    exit 1
fi

# Clear or create the bookmarks file
: >"$bookmarks_file"

cleanup()
{
    rm -f "$bookmarks_file"
}
trap cleanup EXIT INT TERM

# Generate bookmarks file.
for f in "${files[@]}"; do
    if [ ! -f "$f" ]; then
        echo "Error: File '$f' not found." >&2
        exit 1
    fi

    title="$(basename "$f" .pdf)"
    printf "BookmarkBegin\nBookmarkTitle: %s\nBookmarkLevel: 1\nBookmarkPageNumber: %d\n" "$title" "$page_counter" >>"$bookmarks_file"

    num_pages=$(pdftk "$f" dump_data 2>/dev/null | awk '/NumberOfPages/ {print $2}')
    if [ -z "$num_pages" ]; then
        echo "Error: Unable to get page count for '$f'." >&2
        exit 1
    fi

    page_counter=$((page_counter + num_pages))
done

# Combine PDFs and embed bookmarks.
pdftk "${files[@]}" cat output - 2>/dev/null | pdftk - update_info "$bookmarks_file" output "$out_file" 2>/dev/null || {
    echo "Error: Failed to merge PDFs." >&2
    exit 1
}

echo "PDFs merged into $out_file with bookmarks."
