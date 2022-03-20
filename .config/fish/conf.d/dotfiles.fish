function se
    set -l s (find "$SCRIPT_DIR"/ -type f | \
    sed -n "s@$SCRIPT_DIR/@@p" | \
    fzf --preview "highlight -i $SCRIPT_DIR/{1} --stdout --out-format=ansi -q --force")

    [ -n "$s" ] && $EDITOR "$SCRIPT_DIR/$s"
end

function dot
    configlist | \
    fzf --preview "highlight -i $HOME/{1} --stdout --out-format=ansi -q --force" | \
    sed "s@^@$HOME/@" | \
    xargs -ro $EDITOR
end
