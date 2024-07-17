-- ==================== which-key (which-key.nvim) ==================== --
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

which_key.setup({
    preset = "modern",
    win = {
        border = "single",
        padding = { 0, 0, 0, 0 },
    },
    layout = {
        spacing = 2,
        align = "left",
    },
    disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt", "alpha" },
    },
})
