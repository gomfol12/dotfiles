-- ==================== Spellcheck (spellsitter.nvim) ==================== --

local status_ok, spellsitter = pcall(require, "spellsitter")
if not status_ok then
    return
end

vim.opt.spell = false
-- de is slow af
vim.opt.spelllang = { "de_de", "en_us" }
vim.opt.spellsuggest = { "best", 10 }

spellsitter.setup({
    enable = true,
})
