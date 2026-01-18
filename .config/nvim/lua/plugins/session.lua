-- ==================== Session (possession.nvim) ==================== --

return {
    {
        "stevearc/resession.nvim",
        config = function()
            local resession = require("resession")
            resession.setup({
                autosave = {
                    enabled = true,
                    interval = 60,
                    notify = true,
                },
            })

            vim.keymap.set("n", "<leader>ps", resession.save)
            vim.keymap.set("n", "<leader>pl", resession.load)
            vim.keymap.set("n", "<leader>pd", resession.delete)
        end,
    },
}
