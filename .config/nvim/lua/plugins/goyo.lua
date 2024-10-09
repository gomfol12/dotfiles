-- ==================== Goyo.vim ==================== --

return {
    "junegunn/goyo.vim",
    init = function()
        vim.g.goyo_width = 100
    end,
    config = function()
        local function goyo_enter()
            if vim.fn.executable("tmux") == 1 and vim.fn.strlen(vim.env.TMUX) > 0 then
                vim.fn.system("tmux set status off")
                local tmux_panes = vim.fn.systemlist("tmux list-panes -F '#F'")
                local zoomed = false
                for _, pane in ipairs(tmux_panes) do
                    if pane == "Z" then
                        zoomed = true
                        break
                    end
                end
                if not zoomed then
                    vim.fn.system("tmux resize-pane -Z")
                end
            end
            vim.opt.showmode = false
            vim.opt.showcmd = false
        end

        local function goyo_leave()
            if vim.fn.executable("tmux") == 1 and vim.fn.strlen(vim.env.TMUX) > 0 then
                vim.fn.system("tmux set status on")
                local tmux_panes = vim.fn.systemlist("tmux list-panes -F '#F'")
                for _, pane in ipairs(tmux_panes) do
                    if pane == "Z" then
                        vim.fn.system("tmux resize-pane -Z")
                        break
                    end
                end
            end
            vim.opt.showmode = true
            vim.opt.showcmd = true
        end

        vim.api.nvim_create_autocmd("User", {
            pattern = "GoyoEnter",
            nested = true,
            callback = goyo_enter,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "GoyoLeave",
            nested = true,
            callback = goyo_leave,
        })
    end,
}
