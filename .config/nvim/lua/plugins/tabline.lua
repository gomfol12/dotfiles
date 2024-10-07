local theme = {
    fill = "TabLineFill",
    -- fill = { fg = "#b2b2b2", bg = "#080808", style = "italic" },
    head = "TabLine",
    current_tab = "TabLineSel",
    tab = "TabLine",
    win = "TabLine",
    tail = "TabLine",
}

return {
    "nanozuki/tabby.nvim",
    event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        require("tabby.tabline").set(function(line)
            return {
                line.tabs().foreach(function(tab)
                    local hl = tab.is_current() and theme.current_tab or theme.tab
                    return {
                        " " .. tab.number() .. " [" .. #vim.api.nvim_tabpage_list_wins(tab.id) .. "] ",
                        hl = hl,
                    }
                end),
                line.spacer(),
                line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
                    local hl = win.is_current() and theme.current_tab or theme.tab
                    return {
                        " "
                            .. vim.api.nvim_win_get_buf(win.id)
                            .. ": "
                            .. win.buf_name()
                            .. " "
                            .. (
                                vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win.id), "modified") and "[+] "
                                or ""
                            ),
                        hl = hl,
                    }
                end),
                hl = theme.fill,
            }
        end)
    end,
}
