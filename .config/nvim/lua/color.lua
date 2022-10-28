-- ==================== colorizer (nvim-colorizer) ==================== --

local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
    return
end

colorizer.setup({
    filetypes = {
        "*",
        css = { css = true },
        html = { names = false },
        java = { names = false },
    },
})
