-- ==================== VimTex ==================== --

return {
    "lervag/vimtex",
    lazy = true,
    ft = { "tex", "pandoc" },
    init = function()
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_engine = "lualatex"
        vim.g.vimtex_compiler_latexmk = {
            out_dir = "build",
            options = {
                "-pdf",
                "-shell-escape",
                "-verbose",
                "-file-line-error",
                "-synctex=1",
                "-interaction=nonstopmode",
            },
        }
        vim.g.vimtex_toc_config = {
            name = "TOC",
            split_width = 30,
            todo_sorted = 0,
            show_help = 0,
            show_numbers = 1,
            mode = 2,
        }
        vim.g.vimtex_fold_enabled = true
        -- vim.g.vimtex_quickfix_open_on_warning = 0
        vim.g.vimtex_syntax_conceal_disable = 1

        vim.opt.makeprg = "latexmk -pdf -shell-escape -verbose -file-line-error -output-directory="
            .. vim.fn.expand("%:h")
            .. "/build"
    end,
    keys = {
        { "<leader>li", ":VimtexInfo<CR>", desc = "Vimtex info" },
        { "<leader>lt", ":VimtexTocToggle<CR>", desc = "Vimtex toc toggle" },
        { "<leader>ll", ":VimtexCompile<CR>", desc = "Vimtex compile" },
        { "<leader>ls", ":VimtexStop<CR>", desc = "Vimtex stop" },
        { "<leader>lc", ":VimtexClean<CR>", desc = "Vimtex clean" },
        { "<leader>le", ":VimtexErrors<CR>", desc = "Vimtex errors" },
        { "<leader>lv", ":VimtexView<CR>", desc = "Vimtex view" },
    },
    config = function()
        vim.cmd(":autocmd BufNewFile,BufRead *.tex VimtexCompile")
    end,
}
