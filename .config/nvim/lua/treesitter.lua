-- ==================== Treesitter (nvim-treesitter) ==================== --
-- TODO: textopjects

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup({
    ensure_installed = {
        "c",
        "cpp",
        "lua",
        "python",
        "rust",
        "bash",
        "bibtex",
        "cmake",
        "make",
        "comment",
        "css",
        "diff",
        "dockerfile",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        -- "help",
        "html",
        "http",
        "java",
        "json",
        "kotlin",
        "latex",
        "markdown",
        "markdown_inline",
        "ninja",
        "php",
        "perl",
        "racket",
        "regex",
        "scheme",
        "scss",
        "sql",
        "toml",
        "vim",
        "yaml",
    },
    sync_install = false,
    highlight = {
        enable = true,
        disable = { "latex" },
    },
    indent = {
        enable = false,
    },
    context_commentstring = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ib"] = { query = "@block.inner", desc = "in block" },
            },
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
        lsp_interop = {
            enable = true,
            border = "none",
            peek_definition_code = {
                ["<leader>df"] = "@function.outer",
                ["<leader>dF"] = "@class.outer",
            },
        },
    },
    matchup = {
        enable = true,
    },
})

-- disable for pandoc only method that works
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "pandoc", "vimwiki" },
    callback = function()
        require("nvim-treesitter.configs").setup({
            highlight = {
                enable = false,
            },
        })
    end,
})
