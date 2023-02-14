function _G.get_signs()
    local signs = {}
    local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

    signs = vim.tbl_map(function(sign)
        return vim.fn.sign_getdefined(sign.name)[1]
    end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)

    local sign, git_sign
    for _, s in ipairs(signs) do
        if s.name:find("GitSign") then
            git_sign = s
        else
            sign = s
        end
    end

    return { diagnostics = sign, git = git_sign }
end

_G.get_statuscolumn = function()
    local sign = get_signs()

    local content = {
        sign.git and ("%#" .. sign.git.texthl .. "#" .. sign.git.text .. "%*") or "  ", -- git
        sign.diagnostics and ("%#" .. sign.diagnostics.texthl .. "#" .. sign.diagnostics.text .. "%*") or "  ", -- diagnostics
        "%=", -- sep
        "%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''}", --num
        " ",
        "%C", -- fold
    }

    return table.concat(content, "")
end
