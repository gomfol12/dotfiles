-- ==================== Additional plugin configuration ==================== --

-- leap.nvim
local leap_ok, leap = pcall(require, "leap")
if leap_ok then
    leap.add_default_mappings()
    vim.cmd("autocmd ColorScheme * lua require('leap').init_highlight(true)")
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

-- which-key
local which_key_ok, which_key = pcall(require, "which-key")
if which_key_ok then
    which_key.setup({
        plugins = {
            spelling = {
                enabled = true,
                suggestions = 20,
            },
        },
        window = {
            border = "single",
            position = "bottom",
            margin = { 0, 0, 0, 0 },
            padding = { 0, 0, 0, 0 },
            winblend = 0,
        },
        layout = {
            height = { min = 4, max = 4 },
            width = { min = 20, max = 50 },
            spacing = 2,
            align = "left",
        },
        disable = {
            buftypes = {},
            filetypes = { "TelescopePrompt", "alpha" },
        },
    })
end
