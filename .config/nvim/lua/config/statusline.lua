-- ==================== Statusline ==================== --

local cmd = vim.cmd

vim.o.statusline = "%!v:lua.StatusLine()"

function _G.StatusLine()
    local width = vim.api.nvim_win_get_width(0)
    local is_small = width <= 120
    local is_smaller = width <= 80

    local git = ""
    local gs = vim.b.gitsigns_status_dict
    if not is_small then
        if gs then
            git = string.format("[%s:+%d~%d-%d]", gs.head or "none", gs.added or 0, gs.changed or 0, gs.removed or 0)
        elseif vim.fn.exists("*FugitiveStatusline") == 1 then
            local fugitive = vim.fn.FugitiveStatusline()
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
    local diag = vim.diagnostic.get(0)
    if #diag > 0 then
        local errors, warnings, hints, info = 0, 0, 0, 0

        for _, d in ipairs(diag) do
            local t = d.severity
            if t == vim.diagnostic.severity.ERROR then
                errors = errors + 1
            elseif t == vim.diagnostic.severity.WARN then
                warnings = warnings + 1
            elseif t == vim.diagnostic.severity.HINT then
                hints = hints + 1
            elseif t == vim.diagnostic.severity.INFO then
                info = info + 1
            end
        end

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

    local parts = {
        " %M", -- modified flag
        " %y", -- filetype
        vim.bo.readonly and " [RO]" or nil,
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
