-- ==================== Statusline ==================== --

local cmd = vim.cmd

vim.o.statusline = "%!v:lua.StatusLine()"

function _G.StatusLine()
    local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(winid)

    local width = vim.api.nvim_win_get_width(winid)
    local is_small = width <= 120
    local is_smaller = width <= 80

    local git = ""
    if not is_small then
        local ok, gs = pcall(vim.api.nvim_buf_get_var, bufnr, "gitsigns_status_dict")
        if ok and gs then
            git = string.format("[%s:+%d~%d-%d]", gs.head or "none", gs.added or 0, gs.changed or 0, gs.removed or 0)
        elseif vim.fn.exists("*FugitiveStatusline") == 1 then
            local fugitive
            vim.api.nvim_win_call(winid, function()
                fugitive = vim.fn.FugitiveStatusline()
            end)

            if fugitive ~= "" then
                local branch = fugitive:match("%((.-)%)")
                if branch then
                    git = "[" .. branch .. "]"
                else
                    -- fallback
                    git = fugitive
                end
            end
        end
    end

    local diagnostic = ""
    local diagnostic_counts = vim.diagnostic.count(bufnr)
    if next(diagnostic_counts) then
        local errors = diagnostic_counts[vim.diagnostic.severity.ERROR] or 0
        local warnings = diagnostic_counts[vim.diagnostic.severity.WARN] or 0
        local hints = diagnostic_counts[vim.diagnostic.severity.HINT] or 0
        local info = diagnostic_counts[vim.diagnostic.severity.INFO] or 0

        local parts = {}

        local function add(count, hl, icon)
            if count > 0 then
                table.insert(parts, "%#" .. hl .. "#" .. icon .. " " .. count .. "%*")
            end
        end

        local icons = vim.diagnostic.config().signs.text
        add(errors, "DiagnosticError", icons[vim.diagnostic.severity.ERROR])
        add(warnings, "DiagnosticWarn", icons[vim.diagnostic.severity.WARN])
        add(hints, "DiagnosticHint", icons[vim.diagnostic.severity.HINT])
        add(info, "DiagnosticInfo", icons[vim.diagnostic.severity.INFO])

        diagnostic = " " .. table.concat(parts, "")
    end

    local readonly = vim.api.nvim_get_option_value("readonly", { buf = bufnr })

    local parts = {
        " %M", -- modified flag
        " %y", -- filetype
        readonly and " [RO]" or nil,
        is_smaller and " %t" or (is_small and " %f" or " %F"), -- file name
        "%=", -- right align
        git,
        diagnostic,
        " %c:%l/%L", -- character:line/total lines
        " %p%%", -- percentage through file
        " [%n]", -- buffer number
        not is_smaller and " [%{&fileencoding},%{&ff}]", -- file encoding and format
    }

    return table.concat(
        vim.tbl_filter(function(x)
            return x and x ~= ""
        end, parts),
        ""
    )
end

-- disable statusline in the NvimTree window
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "NvimTree*",
    callback = function()
        vim.opt_local.statusline = "%!v:lua.DisableST()"
    end,
})

function _G.DisableST()
    return ""
end
