#!/bin/bash

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
alias myip="echo (curl -s ipinfo.io/ip)"
alias ka="killall"
alias g="git"
alias config="git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME"
alias configlist="config -C \$HOME ls-tree -r master --name-only"
alias sdn="shutdown -h now"

alias p="sudo pacman"
alias pacorp="pacman -Qtdq | doas pacman -Rns -"

alias ex="unarchive.sh"
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

alias v="\$EDITOR"
alias vi="\$EDITOR"
alias vim="\$EDITOR"
alias nvim="\$EDITOR"

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

alias calc="qalc"

# because i am stupid
alias :q="exit"
alias al="la"

alias bm="bashmount"

alias b="dirBook"

### HOME cleanup ###
#alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'