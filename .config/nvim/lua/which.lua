-- ==================== which-key ==================== --
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

which_key.setup({
    plugins = {
        spelling = {
            enabled = true,
            suggestions = 20,
        },
    },
    window = {
        border = "single",
        position = "bottom",
        margin = { 0, 0, 0, 0 },
        padding = { 0, 0, 0, 0 },
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 4 },
        width = { min = 20, max = 50 },
        spacing = 2,
        align = "left",
    },
    disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt", "alpha" },
    },
})
