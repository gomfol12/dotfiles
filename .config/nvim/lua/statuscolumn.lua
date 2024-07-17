-- ==================== statuscol (statuscol) ==================== --
-- NOTE: get names :lua print(dump(vim.fn.sign_getdefined()))

local status_ok, statuscol = pcall(require, "statuscol")
if not status_ok then
    return
end

local builtin = require("statuscol.builtin")
statuscol.setup({
    relculright = true,
    segments = {
        {
            sign = { namespace = { "gitsigns" }, colwidth = 1, wrap = true },
            click = "v:lua.ScLa",
        },
        {
            sign = { namespace = { "diagnostic/signs" }, colwidth = 2 },
            click = "v:lua.ScLa",
        },
        {
            sign = { name = { "Dap" }, colwidth = 1 },
            click = "v:lua.ScLa",
        },
        {
            text = { builtin.lnumfunc },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
        },
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
    },
})

--old
-- function _G.get_signs()
--     local signs = {}
--     local buf = vim.api.nvim_win_get_buf(0)

--     signs = vim.tbl_map(function(sign)
--         return vim.fn.sign_getdefined(sign.name)[1]
--     end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)

--     local sign, git_sign
--     for _, s in ipairs(signs) do
--         if s.name:find("GitSign") then
--             git_sign = s
--         else
--             sign = s
--         end
--     end

--     return { diagnostics = sign, git = git_sign }
-- end

-- _G.get_statuscolumn = function()
--     local sign = get_signs()

--     local git
--     if sign.git and sign.git.texthl and sign.git.text then
--         git = "%#" .. sign.git.texthl .. "#" .. sign.git.text .. "%*"
--     else
--         git = "  "
--     end

--     local diagnostics
--     if sign.diagnostics and sign.diagnostics.texthl and sign.diagnostics.text then
--         diagnostics = "%#" .. sign.diagnostics.texthl .. "#" .. sign.diagnostics.text .. "%*"
--     else
--         diagnostics = "  "
--     end

--     local content = {
--         git,
--         diagnostics,
--         "%=", -- sep
--         "%{(v:virtnum == 0)?(&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''):''}", --num
--         " ",
--         "%C", -- fold
--     }

--     return table.concat(content, "")
-- end
