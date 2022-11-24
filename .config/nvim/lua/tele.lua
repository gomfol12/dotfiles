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
    },
})

telescope.load_extension("ui-select")
