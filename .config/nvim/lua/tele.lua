-- ==================== Telescope ==================== --

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = false,
                ["<C-k>"] = false,
            },
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
        },
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "ignore_case", -- or "smart_case" or "respect_case"
        },
        advanced_git_search = {
            -- fugitive or diffview
            diff_plugin = "diffview",
            -- customize git in previewer
            -- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
            git_flags = {},
            -- customize git diff in previewer
            -- e.g. flags such as { "--raw" }
            git_diff_flags = {},
        },
    },
})

telescope.load_extension("ui-select")
telescope.load_extension("fzf")
telescope.load_extension("frecency")
telescope.load_extension("possession")
telescope.load_extension("advanced_git_search")
