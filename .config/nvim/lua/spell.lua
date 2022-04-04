-- ==================== Spellcheck (spellsitter.nvim) ==================== --

local status_ok, spellsitter = pcall(require, "spellsitter")
if not status_ok then
    return
end

local cmd = vim.cmd

-- activate spell in a vimwiki buffer
cmd([[
    augroup spell
        autocmd!
        autocmd FileType vimwiki setlocal spell
        autocmd FileType tex setlocal spell
    augroup end
]])
-- autocmd BufRead,BufNewFile *.md setlocal spell

vim.opt.spell = false
vim.opt.spelllang = { "de_de", "en_us" }
vim.opt.spellsuggest = { "best", 10 }

spellsitter.setup({
    enable = true,
})
