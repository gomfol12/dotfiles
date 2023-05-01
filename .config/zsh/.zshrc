#!/bin/zsh
# TODO: Title

### General ###
setopt autocd extendedglob nomatch
setopt interactive_comments
unsetopt beep notify
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt inc_append_history
setopt extended_history
setopt hist_find_no_dups
setopt no_case_glob
setopt globdots
# Disable ctrl-s and ctrl-q
stty -ixon

### Config ###
source "$ZDOTDIR/zsh-aliases"
source "$ZDOTDIR/zsh-functions"
zsh_add_file "zsh-timer"
zsh_add_file "zsh-prompt"

### "Plugins" ###
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

### Completion ###
# TODO: what is compinstall
#zstyle :compinstall filename '$ZDOTDIR/zshrc'

autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' rehash true
zstyle ':completion:*' completer _complete _ignored _files

# zstyle ':completion:*' special-dirs true

# fzf
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

compinit

### Keybinds ###
export KEYTIMEOUT=1

bindkey -v # vi keybinds

bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history
bindkey "^N" autosuggest-execute
bindkey "^F" autosuggest-accept
tmuxShow() { BUFFER="tmux"; zle accept-line }; zle -N tmuxShow; bindkey '^Z' tmuxShow
lfShow() { BUFFER="f"; zle accept-line }; zle -N lfShow; bindkey '^G' lfShow

# Edit line in vim with ctrl-v:
autoload edit-command-line; zle -N edit-command-line; bindkey "^V" edit-command-line

# exit with ctrl-d
exit_zsh() { exit }; zle -N exit_zsh; bindkey '^D' exit_zsh

# disable spamming of '^Y' '^E' when scrolling
bindkey -r "^Y"
bindkey -r "^E"

# disable keys for vim tmux integration
if [ -n "${TMUX}" ] && [ ! "$TERM" = "linux" ]; then
    bindkey -r "^h"
    bindkey -r "^j"
    bindkey -r "^k"
    bindkey -r "^l"
fi

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"
key[Control-Backspace]="${terminfo[kBS5]}"
key[Shift-Backspace]="${terminfo[kBS2]}"
key[Shift-Space]="${terminfo[kSP2]}"

# widgets
insert_space() { zle -U " " }

# setup key accordingly
[[ -n "${key[Home]}" ]] && bindkey -- "${key[Home]}" beginning-of-line
[[ -n "${key[End]}" ]] && bindkey -- "${key[End]}" end-of-line
[[ -n "${key[Insert]}" ]] && bindkey -- "${key[Insert]}" overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}" ]] && bindkey -- "${key[Delete]}" delete-char
[[ -n "${key[Up]}" ]] && bindkey -- "${key[Up]}" up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
[[ -n "${key[Left]}" ]] && bindkey -- "${key[Left]}" backward-char
[[ -n "${key[Right]}" ]] && bindkey -- "${key[Right]}" forward-char
[[ -n "${key[PageUp]}" ]] && bindkey -- "${key[PageUp]}" beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]] && bindkey -- "${key[PageDown]}" end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete
[[ -n "${key[Control-Left]}" ]] && bindkey -- "${key[Control-Left]}" backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word
[[ -n "${key[Control-Backspace]}" ]] && bindkey -- "${key[Control-Backspace]}" backward-kill-word
[[ -n "${key[Shift-Backspace]}" ]] && bindkey -- "${key[Shift-Backspace]}" backward-delete-char
[[ -n "${key[Shift-Space]}" ]] && bindkey -- "${key[Shift-Space]}" insert_space

if [ "$TERM" = "linux" ]; then
    bindkey "^[[A" history-beginning-search-backward
    bindkey "^[[B" history-beginning-search-forward
fi

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search

    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }

    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop

    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search

    zle -N insert_space insert_space
fi

# Change cursor shape for different vi modes.
function zle-keymap-select () 
{
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # line
    esac
}
zle -N zle-keymap-select
zle-line-init() 
{
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use line shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use line shape cursor for each new prompt.

### GPG ###
tty_val=$(tty)
export GPG_TTY=$tty_val
gpg-connect-agent updatestartuptty /bye >&/dev/null

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    socket=$(gpgconf --list-dirs agent-ssh-socket)
    export SSH_AUTH_SOCK=$socket
fi

### cdw.sh ###
if [ -f "$SCRIPT_DIR/util/cdw.sh" ]; then
    source "$SCRIPT_DIR/util/cdw.sh"
fi

### tmux ###
if command -v tmux &>/dev/null && [ -z "${TMUX}" ] && [ -n "$DISPLAY" ]; then
    tmux
fi
