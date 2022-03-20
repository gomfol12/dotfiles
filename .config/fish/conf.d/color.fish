## ==================== colors(syntax highlighting and pager) ==================== ##

if not  status is-interactive
    exit
end

### syntax highlighting ###
set fish_color_normal normal                                    #default color
set fish_color_command green                                    #commands like echo
set fish_color_keyword green                                    #keywords like if - this falls back on the command color if unset
set fish_color_quote CE9178                                     #quoted text like "abc"
set fish_color_redirection blue                                 #IO redirections like >/dev/null
set fish_color_end blue --bold                                  #process separators like ';' and '&'
set fish_color_error red                                        #syntax errors
set fish_color_param cyan                                       #ordinary command parameters
set fish_color_comment 6A9955                                   #comments like '# important'
set fish_color_selection black --background brblack             #selected text in vi visual mode
set fish_color_operator blue                                    #parameter expansion operators like '*' and '~'
set fish_color_escape CE9178                                    #character escapes like 'n' and 'x70'
set fish_color_autosuggestion brblack                           #autosuggestions (the proposed rest of a command)
set fish_color_cwd blue                                         #the current working directory in the default prompt
set fish_color_user green                                       #the username in the default prompt
set fish_color_host green                                       #the hostname in the default prompt
set fish_color_host_remote green                                #the hostname in the default prompt for remote sessions (like ssh)
set fish_color_cancel -r                                        #the '^C' indicator on a canceled command
set fish_color_search_match magenta                             #history search matches and selected pager items (background only)
set fish_color_valid_path --underline
#set fish_color_match
#set fish_color_history_current

### pager colors ###
set fish_pager_color_progress black --background yellow         #the progress bar at the bottom left corner
#set fish_pager_color_background                                #the background color of a line
set fish_pager_color_prefix blue                                #the prefix string, i.e. the string that is to be completed
set fish_pager_color_completion blue                            #the completion itself, i.e. the proposed rest of the string
set fish_pager_color_description magenta                        #the completion description
set fish_pager_color_selected_background --background white     #background of the selected completion
set fish_pager_color_selected_prefix black                      #prefix of the selected completion
set fish_pager_color_selected_completion black                  #suffix of the selected completion
set fish_pager_color_selected_description black                 #description of the selected completion
#set fish_pager_color_secondary_background                      #background of every second unselected completion
set fish_pager_color_secondary_prefix blue                      #prefix of every second unselected completion
set fish_pager_color_secondary_completion blue                  #suffix of every second unselected completion
set fish_pager_color_secondary_description magenta              #description of every second unselected completion
