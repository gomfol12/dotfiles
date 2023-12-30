-- ==================== Additional plugin configuration ==================== --

local utils = require("utils")

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
local ibl_ok, ibl = pcall(require, "ibl")
if ibl_ok then
    -- local highlight = {
    --     "RainbowRed",
    --     "RainbowYellow",
    --     "RainbowBlue",
    --     "RainbowOrange",
    --     "RainbowGreen",
    --     "RainbowViolet",
    --     "RainbowCyan",
    -- }
    -- local hooks = require("ibl.hooks")

    -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    --     vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    --     vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    --     vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    --     vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    --     vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    --     vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    --     vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    -- end)
    -- vim.g.rainbow_delimiters = { highlight = highlight }
    ibl.setup({
        scope = {
            -- highlight = highlight,
            show_start = false,
            show_end = false,
        },
        indent = {
            char = "▏",
        },
    })
    -- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
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

-- inc-rename
local inc_rename_ok, inc_rename = pcall(require, "inc_rename")
if inc_rename_ok then
    inc_rename.setup()
end

-- numb.nvim
local numb_ok, numb = pcall(require, "numb")
if numb_ok then
    numb.setup()
end

-- multicursors.nvim
local multicursors_ok, multicursors = pcall(require, "multicursors")
if multicursors_ok then
    multicursors.setup({})
end

-- stay-in-place.nvim
local stay_in_place_ok, stay_in_place = pcall(require, "stay-in-place")
if stay_in_place_ok then
    stay_in_place.setup()
end

-- image.nvim
local image_ok, image = pcall(require, "image")
if image_ok and utils.dir_exists(os.getenv("NVIM_LUA_VENV_DIR")) then
    image.setup({
        backend = "ueberzug",
        integrations = {
            markdown = {
                enabled = false,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = false,
                filetypes = { "markdown", "vimwiki" },
            },
        },
        max_width = 100,
        max_height = 12,
        max_height_window_percentage = math.huge,
        max_width_window_percentage = math.huge,
        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
    })
end

-- clipboard-image.nvim
local clipboard_image_ok, clipboard_image = pcall(require, "clipboard-image")
if clipboard_image_ok then
    clipboard_image.setup({
        default = {
            img_dir = { "res" },
            img_dir_txt = "res",
            img_name = function()
                return os.date("%d.%m.%Y-%H-%M-%S")
            end,
            affix = "![](%s)", -- Multi lines affix
        },
        -- FileType specific config
        -- pandoc = {
        --     img_dir = { "res" },
        --     img_dir_txt = "~/res",
        -- },
    })
end
