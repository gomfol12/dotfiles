-- ==================== Startpage (alpha-nvim) ==================== --

-- "                                                     ",
-- "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
-- "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
-- "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
-- "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
-- "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
-- "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
-- "                                                     ",

local header = {
    type = "text",
    val = {
        "                                               //             ",
        "   //////      ////      ////    //      //      //////  //// ",
        "  //    //  ////////  //    //  //      //  //  //    //    //",
        " //    //  //        //    //    //  //    //  //    //    // ",
        "//    //    //////    ////        //      //  //    //    //  ",
    },
    opts = {
        position = "center",
        hl = "AlphaHeader",
    },
}

local dateCommand = io.popen("date +'%a %d %B, %R' | tr -d '\n'")
local date = "N/A"
if dateCommand then
    date = dateCommand:read("*a")
    dateCommand:close()
end

local heading = {
    type = "text",
    val = vim.g.have_nerd_font and "┌─      Today is " .. date .. "     ─┐"
        or "┌─     Today is " .. date .. "     ─┐",
    opts = {
        position = "center",
        hl = "AlphaHeader",
    },
}

local footer = {
    type = "text",
    val = "└─" .. string.rep(" ", #heading.val - 14) .. "─┘",
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
        cursor = 3,
        width = 40,
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
    val = vim.g.have_nerd_font and {
        button("e", "  New file", ":ene <bar> startinsert <cr>"),
        button("SPC s f", "  Find file", ":cd $HOME | Telescope find_files<cr>"),
        button("SPC s h", "  Recent files", ":Telescope oldfiles<cr>"),
        button("SPC c c", "  NVIM config", ":e ~/.config/nvim/init.lua<cr>"),
        button("q", "󰗼  Quit NVIM", ":qa<cr>"),
    } or {
        button("e", "New file", ":ene <bar> startinsert <cr>"),
        button("SPC s f", "Find file", ":cd $HOME | Telescope find_files<cr>"),
        button("SPC s h", "Recent files", ":Telescope oldfiles<cr>"),
        button("SPC c c", "NVIM config", ":e ~/.config/nvim/init.lua<cr>"),
        button("q", "Quit NVIM", ":qa<cr>"),
    },
    opts = {
        spacing = 1,
    },
}

local section = {
    header = header,
    heading = heading,
    buttons = buttons,
    footer = footer,
}

return {
    "goolord/alpha-nvim",
    opts = {
        layout = {
            { type = "padding", val = 2 },
            section.header,
            { type = "padding", val = 3 },
            section.heading,
            { type = "padding", val = 1 },
            section.buttons,
            section.footer,
        },
        opts = {
            margin = 5,
        },
    },
}
