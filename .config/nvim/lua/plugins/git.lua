-- ==================== Gitsigns.nvim ==================== --

return {
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function(_, opts)
            require("gitsigns").setup(opts)
        end,
        opts = {
            current_line_blame = true,
            current_line_blame_formatter = vim.g.have_nerd_font
                    and "<author> • <author_time:%a %d %B %Y, %R> • <summary>"
                or "<author>, <author_time:%a %d %B %Y, %R>, <summary>",
            signs = vim.g.have_nerd_font and {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            } or {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "T" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, { desc = "Git: Next hunk" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, { desc = "Git: Previous hunk" })

                -- Actions
                map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git: Stage hunk" })
                map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git: Reset hunk" })
                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Git: Stage hunk" })
                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Git: Reset hunk" })
                map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git: Stage buffer" })
                map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git: Reset buffer" })
                map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git: Preview hunk" })
                map("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end, { desc = "Git: Blame line" })
                map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git: Diff this" })
                map("n", "<leader>hD", function()
                    gitsigns.diffthis("~")
                end, { desc = "Git: Diff this ~" })

                map("n", "<leader>hQ", function()
                    gitsigns.setqflist("all")
                end, { desc = "Git: Set quickfix list (all)" })
                map("n", "<leader>hq", gitsigns.setqflist, { desc = "Git: Set quickfix list" })

                map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Git: Toggle line blame" })
                map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Git: Toggle word diff" })

                -- Text object
                map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Git: Select hunk" })
            end,
        },
    },
}
