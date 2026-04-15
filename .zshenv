#!/bin/zsh

### XDG ###
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_DATA_DIRS=${XDG_DATA_DIRS:="/usr/local/share:/usr/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:="/etc/xdg"}
export XDG_MUSIC_DIR=${XDG_MUSIC_DIR:="$HOME/doc/music"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}

### General ###
export SCRIPT_DIR="$HOME/.local/scripts"
export ZDOTDIR="$HOME/.config/zsh"
export HISTFILE="$ZDOTDIR/history"
export HISTSIZE=2147483647
export SAVEHIST=$HISTSIZE
export HISTTIMEFORMAT="[%F %T] "

if command -v "nvim" >/dev/null 2>&1; then
    export EDITOR="nvim"
elif command -v "vim" >/dev/null 2>&1; then
    export EDITOR="vim"
else
    export EDITOR="vi"
fi

export TERMINAL="kitty"
export BROWSER="firefox"
export _JAVA_AWT_WM_NONREPARENTING=1
export LESSHISTFILE=-
export QT_QPA_PLATFORMTHEME=gtk2
#export QT_QPA_PLATFORMTHEME=qt5ct
export NVIM_PYTHON_VENV_DIR="$HOME/.local/share/nvim/python_venv"
export NVIM_LUA_VENV_DIR="$HOME/.local/share/nvim/lua_venv"
export MANWIDTH=80

# better looking fonts for java apps
export JDK_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

# Color for manpages in less makes manpages a little easier to read
export LESS='-iSrsMF'
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
path+=($(find "$SCRIPT_DIR" -not -path "*old*" -not -path "*grub*" -not -path "*.git*" -type d))
path+=(~/.local/share/gem/ruby/3.0.0/bin)
path+=(~/.local/share/coursier/bin)
path+=(~/.local/share/flutter/bin)
path+=(~/.local/share/luarocks/bin)
export PATH

### HOME cleanup ###
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export WINITRC="$XDG_CONFIG_HOME/wayland/winitrc"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java -Djavafx.cachedir="$XDG_CACHE_HOME"/openjfx -Dsbt.global.base="$XDG_CACHE_HOME"/sbt/ -Dsbt.ivy.home="$XDG_CACHE_HOME"/ivy2/ -Divy.home="$XDG_CACHE_HOME"/ivy2/"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
#export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GOPATH="$XDG_DATA_HOME/go"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export ANDROID_HOME="$XDG_DATA_HOME/android"
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
export ANDROID_AVD_HOME="$XDG_CONFIG_HOME/android/avd"
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export BN_USER_DIRECTORY="$XDG_DATA_HOME/binaryninja"
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME/platformio"

### pass ###
#export PASSWORD_STORE_DIR="$HOME/.local/password-store"
#export PASSWORD_STORE_GENERATED_LENGTH=20
#export PASSWORD_STORE_CLIP_TIME=30

### FZF ###
export FZF_DEFAULT_OPTS="\
--color="hl:green,gutter:-1,hl+:green,info:gray,prompt:blue,pointer:blue,marker:blue,spinner:blue,header:gray" \
--no-bold \
--preview-window border-sharp \
--bind "ctrl-h:preview-down,ctrl-l:preview-up" \
--no-mouse"

### hostname ###
export HOSTNAME_DESKTOP="arch4live"
export HOSTNAME_LAPTOP="laptop"

### git ###
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWSTASHSTATE=1

### lf icons ###
export LF_ICONS="\
di=:\
fi=:\
ln=:\
or=:\
ex=:\
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
*.cmd=:\
*.ps1=:\
*.sh=:\
*.bash=:\
*.zsh=:\
*.fish=:\
*.tar=:\
*.tgz=:\
*.arc=:\
*.arj=:\
*.taz=:\
*.lha=:\
*.lz4=:\
*.lzh=:\
*.lzma=:\
*.tlz=:\
*.txz=:\
*.tzo=:\
*.t7z=:\
*.zip=:\
*.z=:\
*.dz=:\
*.gz=:\
*.lrz=:\
*.lz=:\
*.lzo=:\
*.xz=:\
*.zst=:\
*.tzst=:\
*.bz2=:\
*.bz=:\
*.tbz=:\
*.tbz2=:\
*.tz=:\
*.deb=:\
*.rpm=:\
*.jar=:\
*.war=:\
*.ear=:\
*.sar=:\
*.rar=:\
*.alz=:\
*.ace=:\
*.zoo=:\
*.cpio=:\
*.7z=:\
*.rz=:\
*.cab=:\
*.wim=:\
*.swm=:\
*.dwm=:\
*.esd=:\
*.jpg=:\
*.jpeg=:\
*.mjpg=:\
*.mjpeg=:\
*.gif=:\
*.bmp=:\
*.pbm=:\
*.pgm=:\
*.ppm=:\
*.tga=:\
*.xbm=:\
*.xpm=:\
*.tif=:\
*.tiff=:\
*.png=:\
*.svg=:\
*.svgz=:\
*.mng=:\
*.pcx=:\
*.mov=:\
*.mpg=:\
*.mpeg=:\
*.m2v=:\
*.mkv=:\
*.webm=:\
*.ogm=:\
*.mp4=󰸬:\
*.m4v=󰸬:\
*.mp4v=󰸬:\
*.vob=:\
*.qt=:\
*.nuv=:\
*.wmv=:\
*.asf=:\
*.rm=:\
*.rmvb=:\
*.flc=:\
*.avi=󰸬:\
*.fli=:\
*.flv=:\
*.gl=:\
*.dl=:\
*.xcf=:\
*.xwd=:\
*.yuv=:\
*.cgm=:\
*.emf=:\
*.ogv=:\
*.ogx=:\
*.aac=:\
*.au=:\
*.flac=󰸬:\
*.m4a=:\
*.mid=:\
*.midi=:\
*.mka=:\
*.mp3=󰸪:\
*.mpc=:\
*.ogg=󰸪:\
*.ra=:\
*.wav=󰸪:\
*.oga=:\
*.opus=:\
*.spx=:\
*.xspf=:\
*.pdf=:\
*.nix=:\
"
