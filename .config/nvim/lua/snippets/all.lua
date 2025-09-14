-- ==================== Snippets (all) ==================== --

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local _snippets = {
    s("nvim_config_header", {
        t("-- ==================== "),
        i(1),
        t(" ==================== --"),
    }),
    s("nvim_config_header_smal", {
        t("-- ========== "),
        i(1),
        t(" ========== --"),
    }),
}

-- date snippets
local dates = {
    ["today"] = "heute",
    ["tomorrow"] = "morgen",
    ["next monday"] = "nächsten Montag",
    ["next tuesday"] = "nächsten Dienstag",
    ["next wednesday"] = "nächsten Mittwoch",
    ["next thursday"] = "nächsten Donnerstag",
    ["next friday"] = "nächsten Freitag",
    ["next saturday"] = "nächsten Samstag",
    ["next sunday"] = "nächsten Sonntag",
    ["next week"] = "nächste Woche",
    ["next month"] = "nächsten Monat",
}
for date, ger_date in pairs(dates) do
    for _, key in ipairs({ date, ger_date }) do
        table.insert(
            _snippets,
            s("d_" .. key:gsub(" ", "-"), {
                f(function()
                    return vim.fn.trim(vim.fn.system("date -d '" .. date .. "' +'%d.%m.%Y '"))
                end, {}),
            })
        )
    end
end

return _snippets
