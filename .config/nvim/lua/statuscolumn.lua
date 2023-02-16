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

    local git
    if sign.git and sign.git.texthl and sign.git.text then
        git = "%#" .. sign.git.texthl .. "#" .. sign.git.text .. "%*"
    else
        git = "  "
    end

    local diagnostics
    if sign.diagnostics and sign.diagnostics.texthl and sign.diagnostics.text then
        diagnostics = "%#" .. sign.diagnostics.texthl .. "#" .. sign.diagnostics.text .. "%*"
    else
        diagnostics = "  "
    end

    local content = {
        git,
        diagnostics,
        "%=", -- sep
        "%{(v:virtnum == 0)?(&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''):''}", --num
        " ",
        "%C", -- fold
    }

    return table.concat(content, "")
end
