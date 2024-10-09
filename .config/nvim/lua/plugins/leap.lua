-- ==================== Leap.nvim, ... ==================== --

return {
    "ggandor/leap.nvim",
    dependencies = {
        { "tpope/vim-repeat" },
        {
            "ggandor/leap-spooky.nvim",
            opts = {
                affixes = {
                    remote = { window = "r", cross_window = "R" },
                    magnetic = { window = "m", cross_window = "M" },
                },
                -- automatically pasted yanked text at cursor position, if unnamed register is set
                paste_on_remote_yank = false,
            },
        },
        {
            "ggandor/flit.nvim",
            opts = {
                keys = { f = "f", F = "F", t = "t", T = "T" },
                labeled_modes = "v",
                multiline = true,
                opts = {},
            },
        },
        { "ggandor/leap-ast.nvim" },
    },
    config = function()
        require("leap").add_default_mappings()
        vim.cmd("autocmd ColorScheme * lua require('leap').init_highlight(true)")
    end,
}
