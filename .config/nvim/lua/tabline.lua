-- ==================== Tabline ==================== --

local status_ok, tabby = pcall(require, "tabby")
if not status_ok then
    return
end

local theme = {
    fill = "TabLineFill",
    -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
    head = "TabLine",
    current_tab = "TabLineSel",
    tab = "TabLine",
    win = "TabLine",
    tail = "TabLine",
}

require("tabby.tabline").set(function(line)
    return {
        line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
                tab.is_current() and " " or " ",
                tab.number(),
                tab.name(),
                tab.close_btn(" "),
                hl = hl,
                margin = " ",
            }
        end),
        line.spacer(),
        line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            return {
                win.is_current() and " " or " ",
                win.buf_name(),
                hl = theme.win,
                margin = " ",
            }
        end),
        hl = theme.fill,
    }
end)
