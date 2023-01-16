-- ==================== Additional plugin configuration ==================== --

-- leap.nvim
local leap_ok, leap = pcall(require, "leap")
if leap_ok then
    leap.add_default_mappings()
    vim.cmd("autocmd ColorScheme * lua require('leap').init_highlight(true)")
end

-- leap-spooky.nvim
-- mappings for all native text objects for leap
local leap_spooky_ok, leap_spooky = pcall(require, "leap-spooky")
if leap_spooky_ok then
    leap_spooky.setup({
        affixes = {
            remote = { window = "r", cross_window = "R" },
            magnetic = { window = "m", cross_window = "M" },
        },
        -- automatically pasted yanked text at cursor position, if unnamed register is set
        paste_on_remote_yank = false,
    })
end

-- flit.nvim
local flit_ok, flit = pcall(require, "flit")
if flit_ok then
    flit.setup({
        keys = { f = "f", F = "F", t = "t", T = "T" },
        labeled_modes = "v",
        multiline = true,
        opts = {},
    })
end

-- tmux.nvim
local tmux_ok, tmux = pcall(require, "tmux")
if tmux_ok then
    tmux.setup({
        copy_sync = {
            enable = false,
        },
    })
end

-- indent-blankline.nvim
local blankline_ok, blankline = pcall(require, "indent_blankline")
if blankline_ok then
    blankline.setup()
end

-- fidget.nvim
local fidget_ok, fidget = pcall(require, "fidget")
if fidget_ok then
    fidget.setup()
end

-- neogen
local neogen_ok, neogen = pcall(require, "neogen")
if neogen_ok then
    neogen.setup({ snippet_engine = "luasnip" })
end

-- Goyo
vim.cmd([[
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
]])

-- Dressing
local dressing_ok, dressing = pcall(require, "dressing")
if dressing_ok then
    dressing.setup({
        input = {
            get_config = function(opts)
                -- require("notify")(vim.inspect(opts))
                if opts.completion == "file" or opts.prompt == 'Delete session "test"? [y/N] ' then
                    return {
                        enabled = false,
                    }
                end
            end,
        },
    })
end
