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

local _snippets = {}

-- date snippets
local dates = {
    "today",
    "tomorrow",
    "next monday",
    "next tuesday",
    "next wednesday",
    "next thursday",
    "next friday",
    "next saturday",
    "next sunday",
    "next week",
    "next month",
}
for _, date in pairs(dates) do
    table.insert(
        _snippets,
        s("d_" .. date:gsub(" ", "-"), {
            f(function(args, snip, user_arg_1)
                return vim.fn.trim(vim.fn.system("date -d '" .. date .. "' +'%d.%m.%Y '"))
            end, {}),
        })
    )
end

return _snippets
