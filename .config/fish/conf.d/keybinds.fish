## ==================== keybinds ==================== ##

if not  status is-interactive
    exit
end

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
        # TODO: fix output
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
