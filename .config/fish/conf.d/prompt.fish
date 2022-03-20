## ==================== prompt ==================== ##

if not  status is-interactive
    exit
end

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
