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
