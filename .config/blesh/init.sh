#!/bin/bash

### general ###
bleopt char_width_mode=auto
bleopt input_encoding=UTF-8
bleopt pager=less
#bleopt history_share=1

### graphic ###
bleopt tab_width=4
bleopt indent_offset=4
bleopt indent_tabs=0
bleopt filename_ls_colors="$LS_COLORS"
bleopt highlight_timeout_sync=100
bleopt highlight_timeout_async=1000
bleopt syntax_eval_polling_interval=10

# keymaps
# C-x C-v for Vim mode
VISUAL='nvim -X'
ble-bind -m vi_imap -f 'C-x C-v' 'edit-and-execute-command'
ble-bind -m vi_nmap -f 'C-x C-v' 'vi-command/edit-and-execute-command'
ble-bind -m vi_imap -s 'S-SP' ' '
ble-bind -m vi_nmap -s 'S-SP' ' '

# color
#TODO: finish
#ble-face argument_option=fg=teal
ble-face auto_complete=fg=black,bg=white
#ble-face blerc_git_commit_id=fg=navy
ble-face cmdinfo_cd_cdpath=fg=teal,bg=green
#ble-face command_alias=fg=teal
#ble-face command_builtin=fg=red
#ble-face command_builtin_dot=fg=red,bold
ble-face command_directory=fg=blue
#ble-face command_file=fg=green
ble-face command_function=fg=magenta
#ble-face command_jobs=fg=red,bold
#ble-face command_keyword=fg=blue
ble-face disabled=fg=gray
#ble-face filename_block=fg=yellow,bg=black,underline
#ble-face filename_character=fg=white,bg=black,underline
#ble-face filename_directory=fg=blue,bold
ble-face filename_directory_sticky=fg=white,bg=blue,underline
ble-face filename_executable=fg=green
#ble-face filename_link=fg=teal,underline
#ble-face filename_ls_colors=underline
ble-face filename_orphan=fg=white,bg=red,underline
#ble-face filename_other=underline
#ble-face filename_pipe=fg=lime,bg=black,underline
ble-face filename_setgid=fg=black,bg=191,underline
ble-face filename_setuid=fg=black,bg=220,underline
ble-face filename_socket=fg=cyan,bg=black,underline
ble-face filename_url=fg=blue,underline
ble-face filename_warning=fg=red,underline
###ble-face menu_filter_fixed=bold
###ble-face menu_filter_input=fg=16,bg=229
ble-face overwrite_mode=fg=black,bg=51
ble-face prompt_status_line=fg=231,bg=240
ble-face region=fg=white,bg=60
ble-face region_insert=fg=blue,bg=252
ble-face region_match=fg=white,bg=55
ble-face region_target=fg=black,bg=153
ble-face syntax_brace=fg=37,bold
ble-face syntax_command=fg=brown
ble-face syntax_comment=fg=242
ble-face syntax_default=none
ble-face syntax_delimiter=bold
ble-face syntax_document=fg=94
ble-face syntax_document_begin=fg=94,bold
ble-face syntax_error=fg=231,bg=203
ble-face syntax_escape=fg=magenta
ble-face syntax_expr=fg=26
ble-face syntax_function_name=fg=92,bold
ble-face syntax_glob=fg=198,bold
ble-face syntax_history_expansion=fg=231,bg=94
ble-face syntax_param_expansion=fg=purple
ble-face syntax_quotation=fg=green,bold
ble-face syntax_quoted=fg=green
ble-face syntax_tilde=fg=navy,bold
ble-face syntax_varname=fg=orange
ble-face varname_array=fg=orange,bold
ble-face varname_empty=fg=31
ble-face varname_export=fg=200,bold
ble-face varname_expr=fg=92,bold
ble-face varname_hash=fg=70,bold
ble-face varname_number=fg=64
ble-face varname_readonly=fg=200
ble-face varname_transform=fg=29,bold
ble-face varname_unset=fg=124
ble-face vbell=reverse
ble-face vbell_erase=bg=252
ble-face vbell_flash=fg=green,reverse

### prompt ###
bleopt prompt_eol_mark=$'\e[94m[EOF]\e[m'
bleopt exec_errexit_mark=$'\e[91m[%d]\e[m'

#function ble/prompt/backslash:time
#{
#    time="$(date +'%R')"
#    ble/prompt/print $time
#    ble/prompt/unit/add-hash '$time'
#}

#bleopt prompt_rps1="\q{time}"
#bleopt prompt_rps1_final=
#bleopt prompt_rps1_transient=1

#bleopt prompt_ruler=$'\e[94m-' # blue line after command
#bleopt info_display=bottom

### vim mode ###
#TODO: airline ?
function blerc/vim-load-hook
{
    ((_ble_bash>=40300)) && builtin bind 'set keyseq-timeout 1'

    # history search with arrow keys
    ble-bind -m vi_imap -f 'down' 'history-search-forward hide-status:immediate-accept:point=end:history-move'
    ble-bind -m vi_imap -f 'up' 'history-search-backward hide-status:immediate-accept:point=end:history-move'

    bleopt keymap_vi_mode_show=1
    bleopt keymap_vi_mode_string_nmap:=$'\e[1m-- NORMAL --\e[m'

    bleopt keymap_vi_imap_undo=more

    # search history with fzf
    function ble/widget/fzf_histroy
    {
        ble/widget/vi_xmap/delete-lines # found it somewhere and it works
        h=$(history | fzf --reverse --tac | sed "s@^[ ]*[0123456789]*[ ]*@@")
        ble/widget/insert-string "$h" # same here
    }
    ble-bind -m vi_imap -f 'C-S-r' 'fzf_histroy'

    # search file in current directory and insert into prompt
    function ble/widget/fzf_cur_dir_list
    {
        l=$(ls -A | fzf --reverse)
        ble/widget/insert-string "$l"
    }
    ble-bind -m vi_imap -f 'C-t' 'fzf_cur_dir_list'
}
blehook/eval-after-load keymap_vi blerc/vim-load-hook

### completion ###
function my/complete-load-hook
{
    bleopt complete_auto_delay=1
    bleopt complete_polling_cycle=10
    bleopt complete_timeout_auto=1000
    bleopt complete_timeout_compvar=100

    ble-sabbrev 'L'='| less'
    ble-sabbrev 'G'='| grep -i'
}
blehook/eval-after-load complete my/complete-load-hook

### sabbrev ###
# insert date or time through sabbrev \date or \time
function blerc/define-sabbrev-time
{
    ble-sabbrev -m '\date'='ble/util/assign COMPREPLY "date +%F"'
    ble-sabbrev -m '\d'='ble/util/assign COMPREPLY "date +%F"'
    ble-sabbrev -m '\time'='ble/util/assign COMPREPLY "date +%R"'
    ble-sabbrev -m '\t'='ble/util/assign COMPREPLY "date +%R"'
}
blehook/eval-after-load complete blerc/define-sabbrev-time

# insert pid through fzf and sabbrev with \pid
function blerc/define-sabbrev-pid
{
    function blerc/sabbrev-pid
    {
        pid=$(ps auxh | fzf --reverse --tac --bind='ctrl-r:reload(ps auxh)' --header=$'Press CTRL-R to reload\n' | awk '{print $2}')
        ble/util/assign COMPREPLY "echo $pid"
    }
    ble-sabbrev -m '\pid'=blerc/sabbrev-pid
    ble-sabbrev -m '\p'=blerc/sabbrev-pid
}
blehook/eval-after-load complete blerc/define-sabbrev-pid

# insert git branch name from menu through sabbrev \branch
function blerc/define-sabbrev-branch
{
    function blerc/sabbrev-git-branch
    {
        ble/util/assign-array COMPREPLY "git branch | sed 's/^\*\{0,1\}[[:space:]]*//'" 2>/dev/null
    }
    ble-sabbrev -m '\branch'=blerc/sabbrev-git-branch
    ble-sabbrev -m '\b'=blerc/sabbrev-git-branch
}
blehook/eval-after-load complete blerc/define-sabbrev-branch

# insert git commit ID from menu through sabbrev \commit
function blerc/define-sabbrev-commit
{
    ble/color/defface blerc_git_commit_id fg=navy
    ble/complete/action/inherit-from blerc_git_commit_id word
    function ble/complete/action:blerc_git_commit_id/init-menu-item
    {
        local ret
        ble/color/face2g blerc_git_commit_id; g=$ret
    }
    function blerc/sabbrev-git-commit
    {
        bleopt sabbrev_menu_style=desc-raw
        bleopt sabbrev_menu_opts=enter_menu

        local format=$'%h \e[1;32m(%ar)\e[m %s - \e[4m%an\e[m\e[1;33m%d\e[m'
        local arr; ble/util/assign-array arr 'git log --pretty=format:"$format"' &>/dev/null
        local line hash subject
        for line in "${arr[@]}"; do
            builtin read hash subject <<< "$line"
            ble/complete/cand/yield blerc_git_commit_id "$hash" "$subject"
        done
    }
    ble-sabbrev -m '\commit'='blerc/sabbrev-git-commit'
    ble-sabbrev -m '\c'='blerc/sabbrev-git-commit'
}
blehook/eval-after-load complete blerc/define-sabbrev-commit
