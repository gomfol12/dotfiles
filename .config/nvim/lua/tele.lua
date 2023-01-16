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
    },
})

telescope.load_extension("ui-select")
telescope.load_extension("fzf")
telescope.load_extension("frecency")
telescope.load_extension("possession")
