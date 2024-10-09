-- ==================== Spellcheck ==================== --

local augroup = vim.api.nvim_create_augroup("Spell", { clear = true })

-- disable spellcheck by default
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "*",
    command = ":setlocal nospell",
})

-- set spell when in vimwiki, tex or markdown buffer
for _, k in pairs({ "vimwiki", "tex", "markdown" }) do
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = k,
        command = ":setlocal spell",
    })
end

vim.opt.spell = true
vim.opt.spelllang = { "de_de", "en_us" }
vim.opt.spellsuggest = { "best", 10 }
