#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi # vi keybinds
stty -ixon #Disable ctrl-s and ctrl-q
shopt -s autocd #Allows you to cd into directory merely by typing directory name
shopt -s checkwinsize # Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s cdspell # make cd ignore case and small typos

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

HISTSIZE=HISTFILESIZE #Infinite history

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
fi

# spotify-tui completion
if [ -f ~/.config/spotify-tui/completion ]; then
    . ~/.config/spotify-tui/completion
fi

# git completion
source /usr/share/git/completion/git-completion.bash

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
# Write & read history after every command (reduces problems with multiple terminal sessions)
PROMPT_COMMAND="history -a; history -n"

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

# setting prompt
USERCOLOR=""
if [[ $EUID != 0 ]]; then
	USERCOLOR=$GREEN # Normal user
else
	USERCOLOR=$RED # Root user
fi

# git-prompt
source /usr/share/git/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWSTASHSTATE=1

if [ "$TERM" = "linux" ]; then
	#PS1="${WHITE}[${USERCOLOR}\u${GREEN}@\h${WHITE}:${LBLUE}\w${WHITE}] ${NOCOLOR}"
	PROMPT_COMMAND='__git_ps1 "${RED}[${USERCOLOR}\u${GREEN}@\h${WHITE}:${LBLUE}\w${RED}]${NOCOLOR}" " " "[%s]"'
else
	#PS1="${WHITE}[${USERCOLOR}\u${GREEN}@\h${WHITE}:${BLUE}\w${WHITE}]${NOCOLOR}🦄 "
	PROMPT_COMMAND='__git_ps1 "${RED}[${USERCOLOR}\u${GREEN}@\h${WHITE}:${BLUE}\w${RED}]${NOCOLOR}" "🦄 " "${RED}[${NOCOLOR}%s${RED}]${NOCOLOR}"'
fi

#alias
alias sudo="doas"
alias yay="paru --sudo doas --sudoflags --"

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

alias c="clear"
alias p="sudo pacman"
alias sysctl="sudo systemctl"
alias myip="curl -s ipinfo.io/ip | awk '{print}'"
alias ka="killall"
alias g="git"
alias sdn="shutdown -h now"

alias untar="tar -xvf"
alias ungz="tar -zxvf"
alias unbz2="tar -xjvf"
alias mktar="tar -cvf"
alias mkgz="tar -cvzf"
alias mkbz2="tar -cjvf"
alias mkzip="zip -r"

alias iv="sxiv.sh"

alias yt="youtube-dl --add-metadata"
alias yta="yt -f bestaudio/best"

alias f="lfcd"
alias spt="spt.sh"
alias ca="cal -m -3"
alias bc="bc -l -q"
alias da="date +'%a %d %B %Y, %R'"
alias ps="ps axcf"
alias ping="ping -c 4"

alias home="cd ~"
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias pu="pushd"
alias po="popd"

alias mx="chmod +x"

if [ "$TERM" != "linux" ]; then
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

#alias neofetch="neofetch | lolcat"

#colorscript
#[ ! "$TERM" = "linux" ] && colorscript random

# HOME cleanup
#alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'

# lf
lfcd ()
{
	tmp="$(mktemp)"
	fid="$(mktemp)"
	lf -command '$printf $id > '"$fid"'' -last-dir-path="$tmp" "$@"
	id="$(cat "$fid")"
	archivemount_dir="/tmp/__lf_archivemount_$id"
	if [ -f "$archivemount_dir" ]; then
		cat "$archivemount_dir" | \
			while read -r line; do
				sudo umount "$line"
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
}

cl()
{
	if [ -d "$@" ]; then
		cd "$@" && la
	else
		echo "'$1' not a dir..."
	fi
}
