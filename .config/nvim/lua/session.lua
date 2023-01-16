-- ==================== Session Manager (possession) ==================== --

local status_ok, p = pcall(require, "possession")
if not status_ok then
    return
end

local Path = require("plenary.path")

p.setup({
    session_dir = (Path:new(vim.fn.stdpath("data")) / "possession"):absolute(),
    silent = false,
    load_silent = true,
    prompt_no_cr = false,
    autosave = {
        current = true,
        tmp = false,
        tmp_name = "tmp",
        on_load = true,
        on_quit = true,
    },
    commands = {
        save = "Ssave",
        load = "Sload",
        close = "Sclose",
        delete = "Sdelete",
        show = "Sshow",
        list = "Slist",
        migrate = "Smigrate",
    },
})
