-- ==================== Filetree (nvim-tree) ==================== --
-- TODO: trash mapping dont work???

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

vim.g.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
        unstaged = "✗",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = "★",
        deleted = "",
        ignored = "◌",
    },
    folder = {
        arrow_open = "",
        arrow_closed = "",
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
        symlink_open = "",
    },
}

vim.g.nvim_tree_quit_on_open = 0
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_disable_window_picker = 1

vim.g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
}

nvim_tree.setup({
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    auto_close = true,
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = true,
    update_to_buf_dir = {
        enable = true,
        auto_open = true,
    },
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
    },
    system_open = {
        cmd = nil,
        args = {},
    },
    filters = {
        dotfiles = false,
        custom = {},
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view = {
        width = 30,
        height = 30,
        hide_root_folder = false,
        side = "left",
        auto_resize = true,
        mappings = {
            custom_only = false,
            list = {
                { key = { "l", "<CR>", "o" }, action = "edit" },
                { key = { "h", "<BS>" }, action = "close_node" },
                { key = "v", action = "vsplit" },
                { key = "s", action = "split" },
                { key = "O", action = "edit_no_picker" },
                { key = "<C-]>", action = "cd" },
                { key = "t", action = "tabnew" },
                { key = "<", action = "prev_sibling" },
                { key = ">", action = "next_sibling" },
                { key = "P", action = "parent_node" },
                { key = "<Tab>", action = "preview" },
                { key = "K", action = "first_sibling" },
                { key = "J", action = "last_sibling" },
                { key = ".", action = "toggle_ignored" },
                { key = "H", action = "toggle_dotfiles" },
                { key = "R", action = "refresh" },
                { key = "a", action = "create" },
                { key = "D", action = "trash" },
                { key = "d", action = "remove" },
                { key = "r", action = "rename" },
                { key = "<C-r>", action = "full_rename" },
                { key = "x", action = "cut" },
                { key = "c", action = "copy" },
                { key = "p", action = "paste" },
                { key = "y", action = "copy_name" },
                { key = "Y", action = "copy_path" },
                { key = "gy", action = "copy_absolute_path" },
                { key = "[c", action = "prev_git_item" },
                { key = "]c", action = "next_git_item" },
                { key = "-", action = "dir_up" },
                { key = "s", action = "system_open" },
                { key = "q", action = "close" },
                { key = "g?", action = "toggle_help" },
            },
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes",
    },
    trash = {
        cmd = "trash",
        require_confirm = true,
    },
})
