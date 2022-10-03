-- ==================== Filetree (nvim-tree) ==================== --
-- TODO: trash mapping don't work???, unbind keys like "H", rework

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

nvim_tree.setup({
    auto_reload_on_write = true,
    disable_netrw = true,
    hijack_cursor = false,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    ignore_buffer_on_setup = false,
    open_on_setup = false,
    open_on_tab = false,
    sort_by = "name",
    update_cwd = true,
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    ignore_ft_on_setup = {},
    diagnostics = {
        enable = true,
        show_on_dirs = true,
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
        exclude = {},
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 400,
    },
    actions = {
        change_dir = {
            enable = false,
            global = false,
        },
        open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
                enable = true,
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            },
        },
    },
    view = {
        width = 30,
        hide_root_folder = false,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        mappings = {
            custom_only = false,
            list = {
                { key = { "l", "<CR>", "o" }, action = "edit" },
                { key = "<C-e>", action = "edit_in_place" },
                { key = "O", action = "edit_no_picker" },
                { key = "<C-]>", action = "cd" },
                { key = "v", action = "vsplit" },
                { key = "s", action = "split" },
                { key = "t", action = "tabnew" },
                { key = "<", action = "prev_sibling" },
                { key = ">", action = "next_sibling" },
                { key = "P", action = "parent_node" },
                { key = { "h", "<BS>" }, action = "close_node" },
                { key = "<Tab>", action = "preview" },
                { key = "K", action = "first_sibling" },
                { key = "J", action = "last_sibling" },
                { key = "I", action = "toggle_git_ignored" },
                { key = ".", action = "toggle_dotfiles" },
                { key = "R", action = "refresh" },
                { key = "a", action = "create" },
                { key = "d", action = "remove" },
                { key = "D", action = "trash" },
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
                { key = "u", action = "system_open" },
                { key = "q", action = "close" },
                { key = "g?", action = "toggle_help" },
                { key = "W", action = "collapse_all" },
                { key = "S", action = "search_node" },
                { key = "<C-k>", action = "toggle_file_info" },
                { key = "fc", action = "run_file_command" },
            },
        },
    },
    trash = {
        cmd = "trash",
        require_confirm = true,
    },
    renderer = {
        highlight_git = true,
        icons = {
            show = {
                git = true,
                folder = true,
                file = true,
                folder_arrow = true,
            },
            glyphs = {
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
            },
        },
    },
})

-- auto close
vim.cmd([[
    autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])
