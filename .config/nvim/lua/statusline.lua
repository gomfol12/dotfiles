-- ==================== Statusline ==================== --

local cmd = vim.cmd
cmd([[ set statusline= ]])
cmd([[ set statusline+=\ %M ]])
cmd([[ set statusline+=\ %y ]])
cmd([[ set statusline+=\ %r ]])
cmd([[ set statusline+=\ %F ]])
cmd([[ set statusline+=%= " Right side settings ]])
cmd([[ set statusline+=\ %{FugitiveStatusline()} ]])
cmd([[ set statusline+=\ %c:%l/%L ]])
cmd([[ set statusline+=\ %p%% ]])
cmd([[ set statusline+=\ [%n] ]])
cmd([[ set statusline+=\ [%{&fileencoding},%{&ff}] ]])
-- cmd([[ set statusline+=\ [%{get(b:,'gitsigns_status','')}] ]])

-- disable statusline in the NvimTree window
cmd([[
function! DisableST()
  return " "
endfunction
au BufEnter NvimTree* setlocal statusline=%!DisableST()
]])
