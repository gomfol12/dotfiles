-- ==================== git (gitsigns) ==================== --

local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
    return
end

gitsigns.setup({
    signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
        follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
    },
    current_line_blame_formatter = "<author> • <author_time:%d.%m.%Y %H:%M> • <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, desc = "Git: next hunk" })

        map("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, desc = "Git: prev hunk" })

        -- Actions
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Git: stage hunk" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Git: undo stage hunk" })
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Git: reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Git: stage buffer" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "Git: reset buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Git: preview buffer" })
        map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
        end, { desc = "Git: blame line" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Git: toggle blame line" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Git: diff this" })
        map("n", "<leader>hD", function()
            gs.diffthis("~")
        end, { desc = "Git: diff this reverse" })
        map("n", "<leader>td", gs.toggle_deleted, { desc = "Git: toggle deleted" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: select hunk" })
    end,
})

-- work around for gitsigns not attaching to buffer
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        require("gitsigns").attach()
    end,
})
