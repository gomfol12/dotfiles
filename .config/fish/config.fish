## ==================== General ==================== ##
# TODO: history, completion, key bindings, ble keybinds, autocd, cdspell, fancy git stuff
# TODO: keybind list (fish doc interactive shared bindings)

if not  status is-interactive
    exit
end

set fish_greeting

# command not found
function fish_command_not_found
    echo "fish: $argv[1]: command not found"
end

### cursor ###
set fish_cursor_default block blink
set fish_cursor_insert block blink
set fish_cursor_replace_one block blink
set fish_cursor_visual block blink

### aliases ###
source ~/.local/scripts/aliases.sh

### GPG ###
set -g GPG_TTY (tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

### lf ###
function lfcd
    source ~/.config/fish/fishBashFrankenstein/lfcd.fish
end

# title
function fish_title
    echo "st" (pwd | sed "s@/home/$USER@~@")
end
