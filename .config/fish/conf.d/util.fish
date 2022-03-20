function cl
    if [ -n "$argv" ]
        if [ -d "$argv" ]
            cd "$argv" && la
        else
            printf "'$argv' not a dir...\n"
        end
    else
        printf "no arguments provided\n"
    end
end

function mc
    mkdir $argv && cd $argv
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
