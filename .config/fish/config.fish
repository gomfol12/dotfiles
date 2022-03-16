# TODO: history, completion, key bindings, ble keybinds, autocd, cdspell, fancy git stuff
# TODO: keybind list (fish doc interactive shared bindings)

if status is-interactive
    set fish_greeting

    ### syntax highlighting ###
    set fish_color_normal normal #default color
    set fish_color_command green #commands like echo
    set fish_color_keyword green #keywords like if - this falls back on the command color if unset
    set fish_color_quote CE9178 #quoted text like "abc"
    set fish_color_redirection blue #IO redirections like >/dev/null
    set fish_color_end blue --bold #process separators like ';' and '&'
    set fish_color_error red #syntax errors
    set fish_color_param cyan #ordinary command parameters
    set fish_color_comment 6A9955 #comments like '# important'
    set fish_color_selection black --background brblack #selected text in vi visual mode
    set fish_color_operator blue #parameter expansion operators like '*' and '~'
    set fish_color_escape CE9178 #character escapes like 'n' and 'x70'
    set fish_color_autosuggestion brblack #autosuggestions (the proposed rest of a command)
    set fish_color_cwd blue #the current working directory in the default prompt
    set fish_color_user green #the username in the default prompt
    set fish_color_host green #the hostname in the default prompt
    set fish_color_host_remote green #the hostname in the default prompt for remote sessions (like ssh)
    set fish_color_cancel -r #the '^C' indicator on a canceled command
    set fish_color_search_match magenta #history search matches and selected pager items (background only)
    set fish_color_valid_path --underline
    #set fish_color_match
    #set fish_color_history_current

    ### pager colors ###
    set fish_pager_color_progress black --background yellow #the progress bar at the bottom left corner
    #set fish_pager_color_background #the background color of a line
    set fish_pager_color_prefix blue #the prefix string, i.e. the string that is to be completed
    set fish_pager_color_completion blue #the completion itself, i.e. the proposed rest of the string
    set fish_pager_color_description magenta #the completion description
    set fish_pager_color_selected_background --background white #background of the selected completion
    set fish_pager_color_selected_prefix black #prefix of the selected completion
    set fish_pager_color_selected_completion black #suffix of the selected completion
    set fish_pager_color_selected_description black #description of the selected completion
    #set fish_pager_color_secondary_background #background of every second unselected completion
    set fish_pager_color_secondary_prefix blue #prefix of every second unselected completion
    set fish_pager_color_secondary_completion blue #suffix of every second unselected completion
    set fish_pager_color_secondary_description magenta #description of every second unselected completion

    ### abbreviations ###
    # git
    abbr -a gs "git status"
    abbr -a gb "git branch"
    abbr -a gco "git checkout"
    abbr -a gc "git commit"

    abbr -a L "less"
    abbr -a G "grep -i"

    ### prompt ###
    function fish_mode_prompt
        if test "$fish_key_bindings" = "fish_vi_key_bindings"
            switch $fish_bind_mode
                case default
                    set_color white
                    echo '[N]'
                case insert
                    set_color white
                    echo '[I]'
                case replace_one
                    set_color white
                    echo '[R]'
                case visual
                    set_color white
                    echo '[V]'
                case '*'
                    set_color white
                    echo '[?]'
            end
            set_color normal
            echo ' '
        end
    end

    # temporary/permanent fix
    function fish_git_custom_prompt
        set -l git_prompt (fish_git_prompt %s)
        if test -n "$git_prompt"
            printf "%s[%s%s%s]%s" \
            (set_color red) \
            (set_color normal) \
            $git_prompt \
            (set_color red) \
            (set_color normal)
        end
    end

    function fish_status_prompt
        if test "$argv[1]" != 0
            printf "exit:%s" $argv[1]
        end
    end

    function fish_duration_prompt
        if test $CMD_DURATION -gt 1000
            printf "time:%.3fs" (math $CMD_DURATION / 1000)
        end
    end

    function postexec --on-event fish_postexec
        set -l exit_status (fish_status_prompt $status)
        set -l duration (fish_duration_prompt)

        if test -n "$exit_status"
            and test -n "$duration"
            printf "%s[%s%s %s%s]%s\n" \
            (set_color red) \
            (set_color yellow) \
            $exit_status \
            $duration \
            (set_color red) \
            (set_color normal)
            return 0
        end

        if test -n "$exit_status"
            printf "%s[%s%s%s]%s\n" \
            (set_color red) \
            (set_color yellow) \
            $exit_status \
            (set_color red) \
            (set_color normal)
            return 0
        end

        if test -n "$duration"
            printf "%s[%s%s%s]%s\n" \
            (set_color red) \
            (set_color yellow) \
            $duration \
            (set_color red) \
            (set_color normal)
            return 0
        end
    end

    function fish_prompt
        set -g fish_prompt_pwd_dir_length 0

        # git
        set -g __fish_git_prompt_showdirtystate 1
        set -g __fish_git_prompt_showcolorhints 1
        set -g __fish_git_prompt_showuntrackedfiles 1
        set -g __fish_git_prompt_showupstream auto
        set -g __fish_git_prompt_showstashstate 1
        set -g __fish_git_prompt_color_flags red

        set -l usercolor "green"
        if fish_is_root_user
            set usercolor "red"
        end

        printf "%s[%s%s%s@%s%s:%s%s%s]%s%s " \
        (set_color red) \
        (set_color $usercolor) \
        $USER \
        (set_color green) \
        (prompt_hostname) \
        (set_color white) \
        (set_color $fish_color_cwd) \
        (prompt_pwd) \
        (set_color red) \
        (set_color normal) \
        (fish_git_custom_prompt)
    end

    ### command not found
    function fish_command_not_found
        echo "fish: $argv[1]: command not found"
    end

    ### keybinds ###
    function fzf_search_history
        commandline -r (history | fzf --reverse)
    end

    function fzf_search_dir
        commandline -i (ls -A | fzf --reverse)
    end

    function fish_user_key_bindings
        fish_vi_key_bindings

        # keybinds in all modes
        for mode in default insert visual
            bind -M $mode \cd exit
            # generates ugly output
            bind -M $mode \ce edit_command_buffer
            bind -M $mode \cr fzf_search_history
            bind -M $mode \ct fzf_search_dir
        end

        bind -M insert \cf accept-autosuggestion
        bind -M insert \cj accept-autosuggestion execute
        bind -M insert -k up history-search-backward
        bind -M insert -k down history-search-forward
        bind -M insert \cp history-search-backward
        bind -M insert \cn history-search-forward
        bind -k ppage history-search-backward
        bind -k npage history-search-forward
        # TODO: change to control+return
        #bind -M insert \c\r insert-line-under
    end

    ### cursor ###
    set fish_cursor_default block blink
    set fish_cursor_insert block blink
    set fish_cursor_replace_one block blink
    set fish_cursor_visual block blink

    ### aliases ###
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
    alias config="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
    alias configlist="config -C $HOME ls-tree -r master --name-only"
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

    alias v="$EDITOR"
    alias vi="$EDITOR"
    alias vim="$EDITOR"
    alias nvim="$EDITOR"

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

    ### HOME cleanup ###
    #alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
    alias nvidia-settings="nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings"

    ### GPG ###
    set -g GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null

    ### lf ###
    function lfcd
        set -l tmp (mktemp)
        set -l fid (mktemp)
        lf.sh -command '$printf $id > '"$fid"'' -last-dir-path="$tmp" "$argv"
        set -l id (cat "$fid")
        set -l archivemount_dir "/tmp/__lf_archivemount_$id"
        if [ -f "$archivemount_dir" ]
            cat "$archivemount_dir" |
                while read line
                    umount "$line"
                    rmdir "$line"
                end
            rm -f "$archivemount_dir" 1>/dev/null
        end
        if [ -f "$tmp" ]
            set -l dir (cat "$tmp")
            rm -f "$tmp" 1>/dev/null
            if [ -d "$dir" ]
                if [ "$dir" != (pwd) ]
                    cd "$dir"
                end
            end
        end
        printf "\033]0; $TERMINAL\007" >/dev/tty
    end

    ### functions/aliases ###
    function cl
        if [ -n "$argv" ]
            if [ -d "$argv" ]
                cd "$argv" && la
            else
                printf "'$argv[1]' not a dir...\n"
            end
        else
            printf "no arguments provided\n"
        end
    end

    function pacin
        pacman -Sl | \
        awk '{print $2($4=="" ? "" : "*")}' | \
        fzf --multi --preview 'echo {1} | tr -d "*" | xargs -r pacman -Si' | \
        tr -d "*" | \
        xargs -ro doas pacman -S
    end

    function pacdel
        pacman -Qq | \
        fzf --multi --preview 'pacman -Qi {1}' | \
        xargs -ro doas pacman -Rncs
    end

    function pacs
        pacman -Sl | \
        awk '{print $2($4=="" ? "" : "*")}' | \
        fzf --multi --preview 'echo {1} | tr -d "*" | xargs -r pacman -Si' | \
        tr -d "*"
    end

    function yayin
        paru -Sl | \
        awk '{print $2($4=="" ? "" : "*")}' | \
        fzf --multi --preview 'echo {1} | tr -d "*" | xargs -r paru -Si' | \
        tr -d "*" | \
        xargs -ro paru --sudo doas --sudoflags -- -S
    end

    function yaydel
        paru -Qq | \
        fzf --multi --preview 'paru -Qi {1}' | \
        xargs -ro paru --sudo doas --sudoflags -- -Rncs
    end

    function yays
        paru -Sl | \
        awk '{print $2($4=="" ? "" : "*")}' | \
        fzf --multi --preview 'echo {1} | tr -d "*" | xargs -r paru -Si' | \
        tr -d "*"
    end

    function se
        set -l s (find "$SCRIPT_DIR"/ -type f | \
        sed -n "s@$SCRIPT_DIR/@@p" | \
        fzf --preview "highlight -i $SCRIPT_DIR/{1} --stdout --out-format=ansi -q --force")

        [ -n "$s" ] && $EDITOR "$SCRIPT_DIR/$s"
    end

    function fkill
        ps auxh | \
        fzf -m --reverse --tac --bind='ctrl-r:reload(ps auxh)' --header='Press CTRL-R to reload\n' | \
        awk '{print $2}' | \
        xargs -r kill -9
    end

    function fman
        man -k . | \
        fzf --prompt='Man> ' | \
        awk '{print $1}' | \
        xargs -r man
    end

    function dot
        configlist | \
        fzf --preview "highlight -i $HOME/{1} --stdout --out-format=ansi -q --force" | \
        sed "s@^@$HOME/@" | \
        xargs -ro $EDITOR
    end

    function getClassString
        #xprop WM_CLASS | grep -o '"[^"]*"' | head -n 1
        xprop | grep WM_CLASS
    end

    function getMime
        file --mime-type "$argv" -bL
    end

    function key
        xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
    end

    # title
    function fish_title
        echo "st" (pwd | sed "s@/home/$USER@~@")
    end

end
