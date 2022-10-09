-- ==================== Spellcheck (spellsitter.nvim) ==================== --

-- set spell when in vimwiki,tex or markdown buffer
local augroup = vim.api.nvim_create_augroup("Spell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "vimwiki",
    command = ":setlocal spell",
})
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "tex",
    command = ":setlocal spell",
})
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "markdown",
    command = ":setlocal spell",
})

vim.opt.spell = false
vim.opt.spelllang = { "de_de", "en_us" }
vim.opt.spellsuggest = { "best", 10 }
