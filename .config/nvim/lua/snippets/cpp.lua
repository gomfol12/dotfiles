-- ==================== Snippets (cpp) ==================== --

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

local function filename()
    return vim.fn.expand("%:t")
end

local _snippets = {
    s("license_metacg", {
        t({
            "/**",
            "* File: ",
        }),
        f(filename, {}),
        t({
            "",
            "* License: Part of the MetaCG project. Licensed under BSD 3 clause license. See LICENSE.txt file at",
            "* https://github.com/tudasc/metacg/LICENSE.txt",
            "*/",
        }),
    }),
}

return _snippets
