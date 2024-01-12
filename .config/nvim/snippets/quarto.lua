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
    s("quartohtml", {
        t({
            "---",
            "title: title",
            "author: author",
            "format:",
            "    html:",
            "        code-fold: true",
            "        theme: cosmo",
            "latex-tinytex: false",
            "pdf-engine: lualatex",
            "jupyter: python3",
            "---",
        }),
    }),
    s("quartopdf", {
        t({
            "---",
            "title: title",
            "author: author",
            "format:",
            "    pdf",
            "latex-tinytex: false",
            "pdf-engine: lualatex",
            "jupyter: python3",
            "---",
        }),
    }),
    s(
        "python",
        fmta(
            [[
            ```{python}
            <>
            ```
            ]],
            { i(0) }
        )
    ),
    s(
        "cpp",
        fmta(
            [[
            ```{cpp}
            <>
            ```
            ]],
            { i(0) }
        )
    ),
}

return _snippets
