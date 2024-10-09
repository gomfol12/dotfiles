-- ==================== Oil.nvim ==================== --

return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        {
            "<leader>o",
            function()
                vim.cmd((vim.bo.filetype == "oil") and "bd" or "Oil --float")
            end,
        },
    },
    opts = {
        view_options = {
            show_hidden = true,
        },
        keymaps_help = {
            border = "single",
        },
        float = {
            border = "single",
        },
    },
}
