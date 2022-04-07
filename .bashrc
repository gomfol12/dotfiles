#!/bin/bash
#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### general ###
set -o vi             # vi keybinds
stty -ixon            #Disable ctrl-s and ctrl-q
shopt -s autocd       #Allows you to cd into directory merely by typing directory name
shopt -s checkwinsize # Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s cdspell      # make cd ignore case and small typos

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

#Infinite history
HISTSIZE=-1
HISTFILESIZE=-1

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=ignoreboth:erasedups

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
# Write & read history after every command (reduces problems with multiple terminal sessions)
#PROMPT_COMMAND="history -a; history -n"

# colors for ls and all grep commands
#export CLICOLOR=1
#export LS_COLORS=''

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;30m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;31m'

# colors
BLACK="\[\033[30m\]"
GRAY="\[\033[37m\]"
RED="\[\033[31m\]"
GREEN="\[\033[32m\]"
YELLOW="\[\033[33m\]"
BLUE="\[\033[34m\]"
MAGENTA="\[\033[35m\]"
CYAN="\[\033[36m\]"
WHITE="\[\033[97m\]"

LBLUE="\[\033[94m\]"

NOCOLOR="\[\033[0m\]"
BOLD="\[\033[1m\]"

### completion ###
# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# spotify-tui completion TODO: automatic download
if [ -f ~/.config/spotify-tui/completion ]; then
    source "$HOME/.config/spotify-tui/completion"
fi

# git completion
if [ -f /usr/share/git/completion/git-completion.bash ]; then
    source /usr/share/git/completion/git-completion.bash
    __git_complete config __git_main
fi

### prompt ###
USERCOLOR=""
if [[ $EUID != 0 ]]; then
    USERCOLOR=$GREEN # Normal user
else
    USERCOLOR=$RED # Root user
fi

# git-prompt
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    source /usr/share/git/completion/git-prompt.sh
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWCOLORHINTS=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM="auto"
    export GIT_PS1_SHOWSTASHSTATE=1
fi

if [ "$TERM" = "linux" ]; then
    if [ -f /usr/share/git/completion/git-prompt.sh ]; then
        PROMPT_COMMAND='__git_ps1 "${RED}[${NOCOLOR}${USERCOLOR}\u${NOCOLOR}${GREEN}@\h${NOCOLOR}${WHITE}:${NOCOLOR}${LBLUE}\w${NOCOLOR}${RED}]${NOCOLOR}" " " "${RED}[${NOCOLOR}%s${RED}]${NOCOLOR}"'
    else
        PS1="${RED}[${NOCOLOR}${USERCOLOR}\u${NOCOLOR}${GREEN}@\h${NOCOLOR}${WHITE}:${NOCOLOR}${LBLUE}\w${NOCOLOR}${RED}]${NOCOLOR} "
    fi
else
    if [ -f /usr/share/git/completion/git-prompt.sh ]; then
        PROMPT_COMMAND='__git_ps1 "${RED}[${NOCOLOR}${USERCOLOR}\u${NOCOLOR}${GREEN}@\h${NOCOLOR}${WHITE}:${NOCOLOR}${BLUE}\w${NOCOLOR}${RED}]${NOCOLOR}" " " "${RED}[${NOCOLOR}%s${RED}]${NOCOLOR}"'
    else
        PS1="${RED}[${NOCOLOR}${USERCOLOR}\u${NOCOLOR}${GREEN}@\h${NOCOLOR}${WHITE}:${NOCOLOR}${BLUE}\w${NOCOLOR}${RED}]${NOCOLOR} "
    fi
fi

# prompt emojis
# 🦄
# 🔥

### alias ###
source "$HOME/.config/bash/aliases.sh"

### GPG ###
tty_val=$(tty)
export GPG_TTY=$tty_val
gpg-connect-agent updatestartuptty /bye >&/dev/null

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    socket=$(gpgconf --list-dirs agent-ssh-socket)
    export SSH_AUTH_SOCK=$socket
fi

### lf ###
lfcd()
{
    tmp="$(mktemp)"
    fid="$(mktemp)"
    lf.sh -command '$printf $id > '"$fid"'' -last-dir-path="$tmp" "$@"
    id="$(cat "$fid")"
    archivemount_dir="/tmp/__lf_archivemount_$id"
    if [ -f "$archivemount_dir" ]; then
        cat "$archivemount_dir" |
            while read -r line; do
                umount "$line"
                rmdir "$line"
            done
        rm -f "$archivemount_dir" 1>/dev/null
    fi
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" 1>/dev/null
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir" || return
            fi
        fi
    fi
    printf "\033]0; %s\007" "$TERMINAL" >/dev/tty
}

### functions ###
cl()
{
    if [ -d "$*" ]; then
        cd "$@" && la
    else
        echo "'$1' not a dir..."
    fi
}

pacin()
{
    pacman -Sl | awk '{print $2($4=="" ? "" : "*")}' | fzf --multi --preview 'echo {1} | tr -d "*" | xargs -r pacman -Si' | tr -d "*" | xargs -ro doas pacman -S
}

pacdel()
{
    pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro doas pacman -Rncs
}

pacs()
{
    pacman -Sl | awk '{print $2($4=="" ? "" : "*")}' | fzf --multi --preview 'echo {1} | tr -d "*" | xargs -r pacman -Si' | tr -d "*"
}

yayin()
{
    paru -Sl | awk '{print $2($4=="" ? "" : "*")}' | fzf --multi --preview 'echo {1} | tr -d "*" | xargs -r paru -Si' | tr -d "*" | xargs -ro paru --sudo doas --sudoflags -- -S
}

yaydel()
{
    paru -Qq | fzf --multi --preview 'paru -Qi {1}' | xargs -ro paru --sudo doas --sudoflags -- -Rncs
}

yays()
{
    paru -Sl | awk '{print $2($4=="" ? "" : "*")}' | fzf --multi --preview 'echo {1} | tr -d "*" | xargs -r paru -Si' | tr -d "*"
}

se()
{
    local s
    s=$(find "$SCRIPT_DIR"/ -type f | sed -n "s@$SCRIPT_DIR/@@p" | fzf --preview "highlight -i $SCRIPT_DIR/{1} --stdout --out-format=ansi -q --force")
    [ -n "$s" ] && $EDITOR "$SCRIPT_DIR/$s"
}

fkill()
{
    ps auxh | fzf -m --reverse --tac --bind='ctrl-r:reload(ps auxh)' --header=$'Press CTRL-R to reload\n' | awk '{print $2}' | xargs -r kill -"${1:-9}"
}

fman()
{
    man -k . | fzf --prompt='Man> ' | awk '{print $1}' | xargs -r man
}

dot()
{
    configlist | fzf --preview "highlight -i $HOME/{1} --stdout --out-format=ansi -q --force" | sed "s@^@$HOME/@" | xargs -ro "$EDITOR"
}

getClassString()
{
    #xprop WM_CLASS | grep -o '"[^"]*"' | head -n 1
    xprop | grep WM_CLASS
}

getMime()
{
    file --mime-type "$@" -bL
}

key()
{
    xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
}

# dirBook
source "$SCRIPT_DIR/util/dirBook.sh"

# start fish
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} ]]; then
    exec fish
fi

#if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
#    exec tmux
#fi
