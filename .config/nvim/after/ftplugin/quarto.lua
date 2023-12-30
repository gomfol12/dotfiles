local status, quarto = pcall(require, "quarto")
if not status then
    print("Failed to load quarto: " .. quarto)
    return
end

quarto.setup({
    debug = false,
    closePreviewOnExit = true,
    lspFeatures = {
        enabled = true,
        languages = { "r", "python", "julia", "bash" },
        chunks = "curly", -- 'curly' or 'all'
        diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
        },
        completion = {
            enabled = true,
        },
    },
    codeRunner = {
        enabled = true,
        default_method = "molten",
        ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
        -- Takes precedence over `default_method`
        never_run = { "yaml" }, -- filetypes which are never sent to a code runner
    },
    keymap = {
        hover = "K",
        definition = "gd",
        rename = "F2",
        references = "gr",
    },
})

vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, { desc = "QMD: Preview", silent = true, noremap = true })

local runner = require("quarto.runner")
vim.keymap.set("n", "<leader>rc", runner.run_cell, { desc = "QMD: run cell", silent = true })
vim.keymap.set("n", "<leader>ra", runner.run_above, { desc = "QMD: run cell and above", silent = true })
vim.keymap.set("n", "<leader>rA", runner.run_all, { desc = "QMD: run all cells", silent = true })
vim.keymap.set("n", "<leader>rl", runner.run_line, { desc = "QMD: run line", silent = true })
vim.keymap.set("v", "<leader>r", runner.run_range, { desc = "QMD: run visual range", silent = true })
vim.keymap.set("n", "<leader>RA", function()
    runner.run_all(true)
end, { desc = "run all cells of all languages", silent = true })
