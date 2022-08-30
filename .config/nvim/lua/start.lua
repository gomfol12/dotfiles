-- ==================== Startpage (alpha-nvim) ==================== --
-- TODO: rework

local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
    return
end

local header = {
    type = "text",
    val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
    },
    opts = {
        position = "center",
        hl = "AlphaHeader",
    },
}

local dateCommand = io.popen("date +'%a %d %B, %R' | tr -d '\n'")
local date = dateCommand:read("*a")
dateCommand:close()

local heading = {
    type = "text",
    val = "┌─   Today is " .. date .. " ─┐",
    opts = {
        position = "center",
        hl = "AlphaHeader",
    },
}

-- a solution ...
local footerText = "└─"
for i = 1, #heading.val - 14 do
    footerText = footerText .. " "
end
footerText = footerText .. "─┘"

local footer = {
    type = "text",
    val = footerText,
    opts = {
        position = "center",
        hl = "AlphaFooter",
    },
}

local function button(sc, txt, keybind)
    local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

    local opts = {
        position = "center",
        text = txt,
        shortcut = sc,
        cursor = 5,
        width = 24,
        align_shortcut = "right",
        hl = "AlphaButtons",
    }

    if keybind then
        opts.keymap = { "n", sc_, keybind, { silent = true } }
    end

    return {
        type = "button",
        val = txt,
        on_press = function()
            local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
            vim.api.nvim_feedkeys(key, "normal", false)
        end,
        opts = opts,
    }
end

local buttons = {
    type = "group",
    val = {
        button("e", " > New file", ":ene <bar> startinsert <cr>"),
        button("f", " > Find file", ":cd $HOME | Telescope find_files<cr>"),
        button("r", " > Recent files", ":Telescope oldfiles<cr>"),
        button("v", "漣> NVIM config", ":e ~/.config/nvim/init.lua<cr>"),
        button("q", " > Quit NVIM", ":qa<cr>"),
    },
    opts = {
        spacing = 1,
    },
}

local section = {
    header = header,
    buttons = buttons,
    heading = heading,
    footer = footer,
}

local opts = {
    layout = {
        { type = "padding", val = 2 },
        section.header,
        { type = "padding", val = 1 },
        section.heading,
        { type = "padding", val = 1 },
        section.buttons,
        section.footer,
    },
    opts = {
        margin = 5,
    },
}

alpha.setup(opts)
