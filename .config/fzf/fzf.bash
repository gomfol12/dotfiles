# Setup fzf
_ble_contrib_fzf_base=~/.local/src/fzf
if [[ ! "$PATH" == *"$_ble_contrib_fzf_base/bin"* ]]; then
    export PATH="${PATH:+${PATH}:}$_ble_contrib_fzf_base/bin"
fi

# Auto-completion
#if [[ ${BLE_VERSION-} ]]; then
#    ble-import -d contrib/fzf-completion
#else
#    [[ $- == *i* ]] && source "$_ble_contrib_fzf_base/shell/completion.bash" 2> /dev/null
#fi

# Keybindings
#if [[ ${BLE_VERSION-} ]]; then
#    ble-import -d contrib/fzf-key-bindings
#else
#    source "$_ble_contrib_fzf_base/shell/key-bindings.bash"
#fi

# fzf-git
if [[ ${BLE_VERSION-} ]]; then
  _ble_contrib_fzf_git_config=key-binding:sabbrev:arpeggio
  ble-import -d contrib/fzf-git
fi
