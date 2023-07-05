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
local concat = require("utils").concat

local _snippets = {
    s("uninote", {
        t({
            "---",
            "title: title",
            "author: author",
            "header-includes:",
            "    \\usepackage[a4paper, left=2.5cm, right=2.5cm, top=2.5cm, bottom=2.5cm]{geometry}",
            "---",
        }),
    }),
    s("uninotemath", {
        t({
            "---",
            "title: title",
            "author: author",
            "header-includes:",
            "    \\usepackage[a4paper, left=2.5cm, right=2.5cm, top=2.5cm, bottom=2.5cm]{geometry}",
            "    \\usepackage{csquotes}",
            "    \\usepackage[german]{babel}",
            "    \\usepackage{dsfont}",
            "    \\usepackage{upgreek}",
            "    \\usepackage{amsmath}",
            "    \\usepackage{mathrsfs}",
            "    \\usepackage{amsthm}",
            "    \\usepackage{amssymb}",
            "---",
        }),
    }),
    s("uninotemathextended", {
        t({
            "---",
            "title: title",
            "author: author",
            "header-includes:",
            "    \\usepackage[a4paper, left=2.5cm, right=2.5cm, top=2.5cm, bottom=2.5cm]{geometry}",
            "    \\usepackage{csquotes}",
            "    \\usepackage[german]{babel}",
            "    \\usepackage{dsfont}",
            "    \\usepackage{upgreek}",
            "    \\usepackage{amsmath}",
            "    \\usepackage{mathrsfs}",
            "    \\usepackage{amsthm}",
            "    \\usepackage{amssymb}",
            "",
            "    \\newcommand{\\N}{\\ensuremath{\\mathds{N}}}",
            "    \\newcommand{\\Z}{\\ensuremath{\\mathds{Z}}}",
            "    \\newcommand{\\Q}{\\ensuremath{\\mathds{Q}}}",
            "    \\newcommand{\\R}{\\ensuremath{\\mathds{R}}}",
            "    \\newcommand{\\C}{\\ensuremath{\\mathds{C}}}",
            "    \\newcommand{\\I}{\\ensuremath{\\mathfrak{I}}}",
            "    \\newcommand{\\B}{\\ensuremath{\\mathds{B}}}",
            "    \\newcommand{\\E}{\\ensuremath{\\mathscr{E}}}",
            "---",
        }),
    }),
}

return concat(_snippets, dofile(vim.fn.stdpath("config") .. "/snippets/tex.lua"))
