#!/bin/bash
#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

### xdg ###
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}

### general ###
export SCRIPT_DIR="$HOME"/.local/scripts
export PATH=$PATH$( find $SCRIPT_DIR -not -path "*old*" -not -path "*grub*" -type d -printf ":%p" )
export PATH=$PATH:$HOME/.local/bin
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="brave"
export _JAVA_AWT_WM_NONREPARENTING=1

# disable less history
export LESSHISTFILE=-

### HOME cleanup ###
export XINITRC="$XDG_CONFIG_HOME"/X11/.xinitrc
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default
#export WGETRC="$XDG_CONFIG_HOME"/wgetrc
#export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc
#export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export GOPATH="$XDG_DATA_HOME"/go
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc

### pass ###
export PASSWORD_STORE_DIR="$HOME"/.local/password-store
export PASSWORD_STORE_GENERATED_LENGTH=20
export PASSWORD_STORE_CLIP_TIME=30

### fzf ###
export FZF_DEFAULT_OPTS="\
--no-mouse \
--color="hl:green,gutter:-1,hl+:green,info:gray,prompt:blue,pointer:blue,marker:blue,spinner:blue,header:gray" \
--no-bold \
--preview-window border-sharp \
--bind "ctrl-h:preview-down,ctrl-l:preview-up""

### lf icons ###
export LF_ICONS="\
di=:\
fi=:\
ln=:\
or=:\
ex=:\
*.c=:\
*.cc=:\
*.clj=:\
*.coffee=:\
*.cpp=:\
*.css=:\
*.d=:\
*.dart=:\
*.erl=:\
*.exs=:\
*.fs=:\
*.go=:\
*.h=:\
*.hh=:\
*.hpp=:\
*.hs=:\
*.html=:\
*.java=:\
*.jl=:\
*.js=:\
*.json=:\
*.lua=:\
*.md=:\
*.php=:\
*.pl=:\
*.pro=:\
*.py=:\
*.rb=:\
*.rs=:\
*.scala=:\
*.ts=:\
*.vim=:\
*.cmd=:\
*.ps1=:\
*.sh=:\
*.bash=:\
*.zsh=:\
*.fish=:\
*.tar=:\
*.tgz=:\
*.arc=:\
*.arj=:\
*.taz=:\
*.lha=:\
*.lz4=:\
*.lzh=:\
*.lzma=:\
*.tlz=:\
*.txz=:\
*.tzo=:\
*.t7z=:\
*.zip=:\
*.z=:\
*.dz=:\
*.gz=:\
*.lrz=:\
*.lz=:\
*.lzo=:\
*.xz=:\
*.zst=:\
*.tzst=:\
*.bz2=:\
*.bz=:\
*.tbz=:\
*.tbz2=:\
*.tz=:\
*.deb=:\
*.rpm=:\
*.jar=:\
*.war=:\
*.ear=:\
*.sar=:\
*.rar=:\
*.alz=:\
*.ace=:\
*.zoo=:\
*.cpio=:\
*.7z=:\
*.rz=:\
*.cab=:\
*.wim=:\
*.swm=:\
*.dwm=:\
*.esd=:\
*.jpg=:\
*.jpeg=:\
*.mjpg=:\
*.mjpeg=:\
*.gif=:\
*.bmp=:\
*.pbm=:\
*.pgm=:\
*.ppm=:\
*.tga=:\
*.xbm=:\
*.xpm=:\
*.tif=:\
*.tiff=:\
*.png=:\
*.svg=:\
*.svgz=:\
*.mng=:\
*.pcx=:\
*.mov=:\
*.mpg=:\
*.mpeg=:\
*.m2v=:\
*.mkv=:\
*.webm=:\
*.ogm=:\
*.mp4=:\
*.m4v=:\
*.mp4v=:\
*.vob=:\
*.qt=:\
*.nuv=:\
*.wmv=:\
*.asf=:\
*.rm=:\
*.rmvb=:\
*.flc=:\
*.avi=:\
*.fli=:\
*.flv=:\
*.gl=:\
*.dl=:\
*.xcf=:\
*.xwd=:\
*.yuv=:\
*.cgm=:\
*.emf=:\
*.ogv=:\
*.ogx=:\
*.aac=:\
*.au=:\
*.flac=:\
*.m4a=:\
*.mid=:\
*.midi=:\
*.mka=:\
*.mp3=:\
*.mpc=:\
*.ogg=:\
*.ra=:\
*.wav=:\
*.oga=:\
*.opus=:\
*.spx=:\
*.xspf=:\
*.pdf=:\
*.nix=:\
"

### startx ###
# run startx on login on tty1
#if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
#	exec startx $XINITRC
#fi
