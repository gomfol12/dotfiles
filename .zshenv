#!/bin/zsh

### XDG ###
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_MUSIC_DIR=${XDG_MUSIC_DIR:="$HOME/doc/music"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}

### General ###
export SCRIPT_DIR="$HOME/.local/scripts"
export ZDOTDIR="$HOME/.config/zsh"
export HISTFILE="$ZDOTDIR/history"
export HISTSIZE=2147483647
export SAVEHIST=$HISTSIZE
export HISTTIMEFORMAT="[%F %T] "
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export _JAVA_AWT_WM_NONREPARENTING=1
export LESSHISTFILE=-

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;30m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;31m'

### PATH ###
typeset -U path PATH
path+=(~/.local/bin)
path+=($(find "$SCRIPT_DIR" -not -path "*old*" -not -path "*grub*" -type d))
path+=(~/.local/share/gem/ruby/3.0.0/bin)
export PATH

### HOME cleanup ###
export XINITRC="$XDG_CONFIG_HOME/X11/.xinitrc"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export XAUTHORITY="$XDG_RUNTIME_DIR/.emptty-xauth"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
#export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GOPATH="$XDG_DATA_HOME/go"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"

### pass ###
export PASSWORD_STORE_DIR="$HOME/.local/password-store"
export PASSWORD_STORE_GENERATED_LENGTH=20
export PASSWORD_STORE_CLIP_TIME=30

### FZF ###
export FZF_DEFAULT_OPTS="\
--color="hl:green,gutter:-1,hl+:green,info:gray,prompt:blue,pointer:blue,marker:blue,spinner:blue,header:gray" \
--no-bold \
--preview-window border-sharp \
--bind "ctrl-h:preview-down,ctrl-l:preview-up" \
--no-mouse"

### Monitors ###
export PRIMARY="HDMI-0"
export SECONDARY="DVI-D-0"

### Nvidia ###
export __GL_SYNC_TO_VBLANK=1
export __GL_SYNC_DISPLAY_DEVICE=$PRIMARY
export VDPAU_NVIDIA_SYNC_DISPLAY_DEVICE=$PRIMARY

### git ###
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWSTASHSTATE=1

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
