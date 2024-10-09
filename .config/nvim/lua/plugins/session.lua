-- ==================== Session (possession.nvim) ==================== --

return {
    "jedrzejboczar/possession.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>pl", ":SLoad", desc = "Load session" },
        { "<leader>ps", ":SSave", desc = "Save session" },
        { "<leader>pc", ":SClose", desc = "Close session" },
        { "<leader>pd", ":SDelete", desc = "Delete session" },
        {
            "<leader>pp",
            function()
                require("telescope").extensions.possession.list()
            end,
            desc = "List sessions",
        },
    },
    opts = {
        commands = {
            save = "SSave",
            load = "SLoad",
            save_cwd = "SSaveCwd",
            load_cwd = "SLoadCwd",
            rename = "SRename",
            close = "SClose",
            delete = "SDelete",
            show = "SShow",
            list = "SList",
            list_cwd = "SListCwd",
            migrate = "SMigrate",
        },
    },
}
