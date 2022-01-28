#!/bin/bash
#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### setup ###
# install ble.sh if it is missing
if [ ! -d $HOME/.local/share/blesh/ ]; then
    if [ ! -d $HOME/.local/src/ ]; then
        mkdir -p $HOME/.local/src/
    fi
    cd $HOME/.local/src

    git clone --recursive https://github.com/akinomyoga/ble.sh.git
    make -C ble.sh install PREFIX=~/.local
    cd $HOME
fi

# install fzf if it is missing
if [ ! -d $HOME/.local/src/fzf/ ]; then
    if [ ! -d $HOME/.local/src/ ]; then
        mkdir -p $HOME/.local/src/
    fi
    cd $HOME/.local/src

    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.local/src/fzf
    $HOME/.local/src/fzf/install --bin
    cd $HOME
fi

### ble.sh top ###
[[ $- == *i* ]] && source $HOME/.local/share/blesh/ble.sh --noattach

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
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;39m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

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

# pywal
#if [ -f $HOME/.cache/wal/sequences ]; then
#    cat ~/.cache/wal/sequences
#fi

if [ "$TERM" = "linux" ]; then
    source ~/.cache/wal/colors-tty.sh
fi

### completion ###
# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# spotify-tui completion TODO: automatic download
if [ -f ~/.config/spotify-tui/completion ]; then
    source ~/.config/spotify-tui/completion
fi

# git completion
if [ -f /usr/share/git/completion/git-completion.bash ]; then
    source /usr/share/git/completion/git-completion.bash
    __git_complete config __git_main
fi

# fzf
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
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
alias sudo="doas"
alias sudoedit="doasedit.sh"
alias doasedit="doasedit.sh"
alias de="doasedit.sh"
alias yay="paru --sudo doas --sudoflags --"
alias y="yay"

alias ls="ls -F -h --color=auto --group-directories-first"
alias grep="grep --color=auto"

alias ll="ls -Al"
alias la="ls -A"
alias l="la"

alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -v"
alias rmd="rm -rf"
alias mkdir="mkdir -pv"
alias md="mkdir"

alias c="clear"
alias sysctl="sudo systemctl"
alias myip="echo $(curl -s ipinfo.io/ip)"
alias ka="killall"
alias g="git"
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias configlist='config -C $HOME ls-tree -r master --name-only'
alias sdn="shutdown -h now"

alias p="sudo pacman"
alias pacorp="pacman -Qtdq | doas pacman -Rns -"

alias untar="tar -xvf"
alias ungz="tar -zxvf"
alias unbz2="tar -xjvf"
alias mktar="tar -cvf"
alias mkgz="tar -cvzf"
alias mkbz2="tar -cjvf"
alias mkzip="zip -r"

alias iv="sxiv.sh"
alias sxiv="sxiv.sh"

alias yt="youtube-dl --add-metadata"
alias yta="yt -f bestaudio/best"

alias f="lfcd"
alias ca="cal -m -3"
alias bc="bc -l -q"
alias da="date +'%a %d %B %Y, %R'"
alias pl="ps axcf"
alias ping="ping -c 4"

alias home="cd ~"
alias h="home"
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias pu="pushd"
alias po="popd"

alias ch="chmod"
alias sch="sudo ch"
alias mx="ch +x"

if [ "$TERM" != "linux" ]; then
    [ -z $EDITOR ] && EDITOR=nvim
    alias v="$EDITOR"
    alias vi="$EDITOR"
    alias vim="$EDITOR"
    alias nvim="$EDITOR"
fi

alias mem="free -mth"
alias foldersize="du -ach --max-depth=1 | sort -h"
alias df="df -Th --total"

alias su="su -m"

alias transende="trans :de -s en"
alias transesde="trans :de -s es"
alias transdeen="trans :en -s de"
alias transdees="trans :es -s de"

alias listfonts="fc-list  | cut -d : -f1"
alias displayfont="fontviewer.sh"

alias realfetch="neofetch --source ~/doc/bilder/ascii/profilepic.ans --gap -76"

alias th="touch"

alias ccopy="xclip -selection clipboard"
alias cpaste="xclip -selection clipboard -o"

alias pw="pw.sh"

alias pin="pacin"
alias yin="yayin"
alias pas="pacs"
alias ys="yays"
alias pdel="pacdel"

### HOME cleanup ###
#alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'

### GPG ###
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >&/dev/null

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
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
                cd "$dir"
            fi
        fi
    fi
    printf "\033]0; $TERMINAL\007" >/dev/tty
}

### functions ###
cl()
{
    if [ -d "$@" ]; then
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
    s=$(find $SCRIPT_DIR/ -type f | sed -n "s@$SCRIPT_DIR/@@p" | fzf --preview "highlight -i $SCRIPT_DIR/{1} --stdout --out-format=ansi -q --force")
    [ -n "$s" ] && $EDITOR "$SCRIPT_DIR/$s"
}

fkill()
{
    ps auxh | fzf -m --reverse --tac --bind='ctrl-r:reload(ps auxh)' --header=$'Press CTRL-R to reload\n' | awk '{print $2}' | xargs -r kill -${1:-9}
}

fman()
{
    man -k . | fzf --prompt='Man> ' | awk '{print $1}' | xargs -r man
}

dot()
{
    configlist | fzf --preview "highlight -i $HOME/{1} --stdout --out-format=ansi -q --force" | sed "s@^@$HOME/@" | xargs -ro $EDITOR
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

### ble.sh bottom ###
[[ ${BLE_VERSION-} ]] && ble-attach

#if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" && -z ${BASH_EXECUTION_STRING} ]]; then
#    exec fish
#fi
