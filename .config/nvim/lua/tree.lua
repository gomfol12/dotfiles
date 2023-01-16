-- ==================== Filetree (nvim-tree) ==================== --
-- TODO: configure keymappings

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

nvim_tree.setup({
    disable_netrw = true,
    view = {
        adaptive_size = true,
        centralize_selection = true,
        number = true,
        relativenumber = true,
        mappings = {
            list = {
                { key = { "<CR>", "o", "<2-LeftMouse>", "l" }, action = "edit" },
                { key = { "<BS>", "h" }, action = "close_node" },
                { key = "H", action = "" },
                { key = ".", action = "toggle_dotfiles" },
                { key = "d", action = "trash" },
                { key = "D", action = "remove" },
                { key = "<C-k>", action = "" },
                { key = "i", action = "toggle_file_info" },
                { key = "<C-v>", action = "vsplit" },
                { key = "<C-s>", action = "split" },
            },
        },
    },
    renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = "all",
    },
    update_focused_file = {
        enable = true,
    },

    diagnostics = {
        enable = true,
        show_on_dirs = true,
    },
    actions = {
        change_dir = {
            enable = false,
        },
    },
})

-- auto close
local function is_modified_buffer_open(buffers)
    for _, v in pairs(buffers) do
        if v.name:match("NvimTree_") == nil then
            return true
        end
    end
    return false
end

vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        if
            #vim.api.nvim_list_wins() == 1
            and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil
            and is_modified_buffer_open(vim.fn.getbufinfo({ bufmodified = 1 })) == false
        then
            vim.cmd("quit")
        end
    end,
})

-- Default mappings
-- { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
-- { key = "<C-e>",                          action = "edit_in_place" },
-- { key = "O",                              action = "edit_no_picker" },
-- { key = { "<C-]>", "<2-RightMouse>" },    action = "cd" },
-- { key = "<C-v>",                          action = "vsplit" },
-- { key = "<C-x>",                          action = "split" },
-- { key = "<C-t>",                          action = "tabnew" },
-- { key = "<",                              action = "prev_sibling" },
-- { key = ">",                              action = "next_sibling" },
-- { key = "P",                              action = "parent_node" },
-- { key = "<BS>",                           action = "close_node" },
-- { key = "<Tab>",                          action = "preview" },
-- { key = "K",                              action = "first_sibling" },
-- { key = "J",                              action = "last_sibling" },
-- { key = "I",                              action = "toggle_git_ignored" },
-- { key = "H",                              action = "toggle_dotfiles" },
-- { key = "U",                              action = "toggle_custom" },
-- { key = "R",                              action = "refresh" },
-- { key = "a",                              action = "create" },
-- { key = "d",                              action = "remove" },
-- { key = "D",                              action = "trash" },
-- { key = "r",                              action = "rename" },
-- { key = "<C-r>",                          action = "full_rename" },
-- { key = "x",                              action = "cut" },
-- { key = "c",                              action = "copy" },
-- { key = "p",                              action = "paste" },
-- { key = "y",                              action = "copy_name" },
-- { key = "Y",                              action = "copy_path" },
-- { key = "gy",                             action = "copy_absolute_path" },
-- { key = "[e",                             action = "prev_diag_item" },
-- { key = "[c",                             action = "prev_git_item" },
-- { key = "]e",                             action = "next_diag_item" },
-- { key = "]c",                             action = "next_git_item" },
-- { key = "-",                              action = "dir_up" },
-- { key = "s",                              action = "system_open" },
-- { key = "f",                              action = "live_filter" },
-- { key = "F",                              action = "clear_live_filter" },
-- { key = "q",                              action = "close" },
-- { key = "W",                              action = "collapse_all" },
-- { key = "E",                              action = "expand_all" },
-- { key = "S",                              action = "search_node" },
-- { key = ".",                              action = "run_file_command" },
-- { key = "<C-k>",                          action = "toggle_file_info" },
-- { key = "g?",                             action = "toggle_help" },
-- { key = "m",                              action = "toggle_mark" },
-- { key = "bmv",                            action = "bulk_move" },
