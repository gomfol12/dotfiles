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
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local get_visual = function(args, parent)
    if #parent.snippet.env.LS_SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
    else
        return sn(nil, i(1))
    end
end

local in_mathzone = require("utils_latex").in_mathzone

local _snippets = {
    s("latex", {
        t({
            "\\documentclass[a4paper]{tudaexercise}",
            "",
            "% General",
            "\\usepackage{csquotes} % for inline and display quotations",
            "\\usepackage[german]{babel} % for german quotation marks",
            "\\usepackage{outlines} % nested lists with \\1 \\2 \\3",
            "",
            "% math",
            "\\usepackage{upgreek} % big greek letters",
            "\\usepackage{amsmath} % math important",
            "\\usepackage{dsfont} % math symbols like N R Q C",
            "\\usepackage{mathrsfs} % more math symbols with \\mathscr",
            "\\usepackage{amsthm} % math theorems setup",
            "\\usepackage{amssymb} % more symbols",
            "\\usepackage{array} % Matrizen, Tabellen, ...",
            "\\usepackage{mathtools}",
            "\\usepackage{gauss}",
            "",
            "% graphics",
            "% \\usepackage{tikz} % graphics",
            "% \\usepackage{pgf,tikz,tkz-euclide} % more graphics",
            "% \\usepackage{tkz-euclide}",
            "% \\usetikzlibrary{decorations.pathmorphing}",
            "% \\usetikzlibrary{calc,intersections,through,backgrounds,snakes}",
            "% \\usetikzlibrary{decorations.pathreplacing}",
            "% \\usepackage{pgfplots} % plots",
            "% \\pgfplotsset{compat=1.18}",
            "% \\usepackage{graphicx}",
            "% \\usepackage{float}",
            "",
            "% etc stuff",
            "\\usepackage{stackengine}",
            "% \\usepackage{xcolor} % easy colors",
            "",
            "% commands",
            "\\def\\spvec#1{\\left(\\vcenter{\\halign{\\hfil$##$\\hfil\\cr \\spvecA#1;;}}\\right)} % vector",
            "% \\def\\spvecA#1;{\\if;#1;\\else #1\\cr \\expandafter \\spvecA\\fi} % vector",
            "",
            "\\newcommand{\\N}{\\ensuremath{\\mathds{n}}}",
            "\\newcommand{\\Z}{\\ensuremath{\\mathds{Z}}}",
            "\\newcommand{\\R}{\\ensuremath{\\mathds{R}}}",
            "\\newcommand{\\Q}{\\ensuremath{\\mathds{Q}}}",
            "\\newcommand{\\C}{\\ensuremath{\\mathds{C}}}",
            "\\newcommand{\\E}{\\ensuremath{\\mathscr{E}}}",
            "\\newcommand{\\B}{\\ensuremath{\\mathscr{B}}}",
            "\\newcommand{\\sC}{\\ensuremath{\\mathscr{C}}}",
            "",
            "\\newcommand{\\rom}[1]{\\uppercase\\expandafter{\\romannumeral#1\\relax}}",
            "",
            "\\newcommand{\\f}{\\frac}",
            "",
            "\\let\\deltao\\delta",
            "\\renewcommand{\\delta}{\\ensuremath{\\deltao}}",
            "",
            "% begin",
            "\\title{title}",
            "",
            "\\author{author}",
            "",
            "\\date{date}",
            "",
            "\\begin{document}",
            "",
            "\\maketitle",
            "",
            "% begin text",
            "",
            "\\end{document}",
        }),
    }),

    s({ trig = "sumkn", dscr = "sum k=0 to n" }, {
        t("\\sum_{k=0}^n"),
    }),
    s({ trig = "sumni", dscr = "sum n=0 to inf" }, {
        t("\\sum_{n=0}^\\infty"),
    }),
    s({ trig = "sumi", dscr = "sum _ to inf" }, {
        t("\\sum_{"),
        i(1),
        t("}^\\infty"),
    }),
    s({ trig = "sum", dscr = "sum _ to _" }, {
        t("\\sum_{"),
        i(1),
        t("}^{"),
        i(2),
        t("}"),
    }),
    s({ trig = "dsumkn", dscr = "dsum k=0 to n" }, {
        t("\\dsum_{k=0}^n"),
    }),
    s({ trig = "dsumni", dscr = "dsum n=0 to inf" }, {
        t("\\dsum_{n=0}^\\infty"),
    }),
    s({ trig = "dsumi", dscr = "dsum _ to inf" }, {
        t("\\dsum_{"),
        i(1),
        t("}^\\infty"),
    }),
    s({ trig = "dsum", dscr = "dsum _ to _" }, {
        t("\\dsum_{"),
        i(1),
        t("}^{"),
        i(2),
        t("}"),
    }),

    s({ trig = "limni", dscr = "lim n to inf" }, {
        t("\\lim \\limits_{n \\to \\infty}"),
    }),
    s({ trig = "limi", dscr = "lim _ to inf" }, {
        t("\\lim \\limits_{"),
        i(1),
        t("\\to \\infty}"),
    }),
    s({ trig = "lim", dscr = "lim _ to _" }, {
        t("\\lim \\limits_{"),
        i(1),
        t(" \\to "),
        i(2),
        t("}"),
    }),
    s({ trig = "limxx", dscr = "lim x to x_0" }, {
        t("\\lim \\limits_{x \\to x_0}"),
    }),
    s({ trig = "limx", dscr = "lim x to _" }, {
        t("\\lim \\limits_{x \\to }"),
    }),

    s({ trig = ";a", snippetType = "autosnippet" }, {
        t("\\alpha"),
    }),
    s({ trig = ";b", snippetType = "autosnippet" }, {
        t("\\beta"),
    }),
    s({ trig = ";g", snippetType = "autosnippet" }, {
        t("\\gamma"),
    }),
    s({ trig = ";d", snippetType = "autosnippet" }, {
        t("\\delta"),
    }),

    s({ trig = ";n", snippetType = "autosnippet" }, {
        t("\\mathds{N}"),
    }),
    s({ trig = ";z", snippetType = "autosnippet" }, {
        t("\\mathds{Z}"),
    }),
    s({ trig = ";r", snippetType = "autosnippet" }, {
        t("\\mathds{R}"),
    }),
    s({ trig = ";c", snippetType = "autosnippet" }, {
        t("\\mathds{C}"),
    }),
    s({ trig = ";k", snippetType = "autosnippet" }, {
        t("\\mathds{K}"),
    }),
    s({ trig = ";l", snippetType = "autosnippet" }, {
        t("\\lambda"),
    }),
    s({ trig = ";p", snippetType = "autosnippet" }, {
        t("\\varphi"),
    }),
    s({ trig = ";e", snippetType = "autosnippet" }, {
        t("\\varepsilon"),
    }),
    s({ trig = ";i", snippetType = "autosnippet" }, {
        t("\\infty"),
    }),

    s(
        { trig = "eq", dscr = "Equation environment" },
        fmta(
            [[
                \begin{equation}
                    <>
                \end{equation}
            ]],
            { i(0) }
        )
    ),

    s(
        { trig = "ca", dscr = "Cases environment" },
        fmta(
            [[
                \begin{cases}
                    <>
                \end{cases}
            ]],
            { i(0) }
        )
    ),

    s(
        { trig = "al", dscr = "Align environment" },
        fmta(
            [[
                \begin{align*}
                    <>
                \end{align*}
            ]],
            { i(0) }
        )
    ),

    s(
        { trig = "ce", dscr = "Center environment" },
        fmta(
            [[
                \begin{center}
                    <>
                \end{center}
            ]],
            { i(0) }
        )
    ),

    s(
        { trig = "env", snippetType = "autosnippet" },
        fmta(
            [[
                \begin{<>}
                    <>
                \end{<>}
            ]],
            {
                i(1),
                i(0),
                rep(1),
            }
        )
    ),

    s(
        { trig = "tiny", dscr = "'tiny' to {\\tiny TEXT}" },
        fmta("{\\tiny <>}", {
            d(1, get_visual),
        })
    ),
    s(
        { trig = "small", dscr = "'small' to {\\small TEXT}" },
        fmta("{\\small <>}", {
            d(1, get_visual),
        })
    ),
    s(
        { trig = "norm", dscr = "'normal' to {\\normal TEXT}" },
        fmta("{\\normal <>}", {
            d(1, get_visual),
        })
    ),
    s(
        { trig = "large", dscr = "'large' to {\\large TEXT}" },
        fmta("{\\large <>}", {
            d(1, get_visual),
        })
    ),
    s(
        { trig = "huge", dscr = "'huge' to {\\huge TEXT}" },
        fmta("{\\huge <>}", {
            d(1, get_visual),
        })
    ),

    s(
        { trig = "tbf", dscr = "'tbf' to textbf{TEXT}" },
        fmta("\\textbf{<>}", {
            d(1, get_visual),
        })
    ),
    s(
        { trig = "tii", dscr = "'tii' to textit{TEXT}" },
        fmta("\\textit{<>}", {
            d(1, get_visual),
        })
    ),
    s(
        { trig = "tuu", dscr = "'tuu' to \\underline{TEXT}" },
        fmta("\\underline{<>}", {
            d(1, get_visual),
        })
    ),
    s(
        { trig = "too", dscr = "'too' to \\overline{TEXT}" },
        fmta("\\overline{<>}", {
            d(1, get_visual),
        })
    ),

    s({ trig = "ff", regTrig = false, wordTrig = true, snippetType = "autosnippet" }, {
        f(function(_, snip)
            return snip.captures[1]
        end),
        t("\\frac{"),
        i(1),
        t("}{"),
        i(2),
        t("}"),
    }, { condition = in_mathzone }),

    s(
        { trig = "mm", regTrig = false, wordTrig = true, snippetType = "autosnippet" },
        fmta("<>$<>$", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            d(1, get_visual),
        })
    ),

    s(
        { trig = "ee", regTrig = false, wordTrig = true, snippetType = "autosnippet" },
        fmta("<>e^{<>}", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            d(1, get_visual),
        }),
        { condition = in_mathzone }
    ),

    s(
        {
            trig = "cd",
            regTrig = false,
            wordTrig = true,
            snippetType = "autosnippet",
        },
        fmta("<>\\cdot", {
            f(function(_, snip)
                return snip.captures[1]
            end),
        }),
        { condition = in_mathzone }
    ),

    s(
        {
            trig = "in",
            regTrig = false,
            wordTrig = true,
            snippetType = "autosnippet",
        },
        fmta("<>\\in", {
            f(function(_, snip)
                return snip.captures[1]
            end),
        }),
        { condition = in_mathzone }
    ),

    s(
        {
            trig = "uint",
            regTrig = false,
            wordTrig = true,
            snippetType = "autosnippet",
        },
        fmta("<>\\displaystyle \\int <> ~d<>", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            i(1),
            i(2),
        }),
        { condition = in_mathzone }
    ),

    s(
        {
            trig = "bint",
            regTrig = false,
            wordTrig = true,
            snippetType = "autosnippet",
        },
        fmta("<>\\displaystyle \\int_{<>}^{<>} <> ~d<>", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            i(1),
            i(2),
            i(3),
            i(4),
        }),
        { condition = in_mathzone }
    ),

    s(
        {
            trig = "sq",
            regTrig = false,
            wordTrig = true,
            snippetType = "autosnippet",
        },
        fmta("<>\\sqrt{<>}<>", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            i(1),
            i(2),
        }),
        { condition = in_mathzone }
    ),

    s(
        { trig = "left" },
        fmta("\\left(<>\\right)<>", {
            i(1),
            i(2),
        }),
        { condition = in_mathzone }
    ),

    s({ trig = ">=", snippetType = "autosnippet" }, {
        t("\\geq"),
    }, { condition = in_mathzone }),
    s({ trig = "<=", snippetType = "autosnippet" }, {
        t("\\leq"),
    }, { condition = in_mathzone }),

    s({ trig = "sub" }, { t("\\subset") }, { condition = in_mathzone }),
    s({ trig = "subeq" }, { t("\\subseteq") }, { condition = in_mathzone }),
}

for _, num in ipairs({ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, "n", "k" }) do
    table.insert(
        _snippets,
        s(
            { trig = "([%a%)%]%}])" .. num .. num, regTrig = true, wordTrig = false, snippetType = "autosnippet" },
            fmta("<>^{<>}", {
                f(function(_, snip)
                    return snip.captures[1]
                end),
                t("" .. num),
            }),
            { condition = in_mathzone }
        )
    )
end

for _, num in ipairs({ 1, 2, 3 }) do
    local subs = ""
    for i = 2, num do
        subs = "sub" .. subs
    end

    table.insert(
        _snippets,
        s({ trig = "h" .. num }, fmta("\\" .. subs .. "section{<>}", { i(1) }), { condition = line_begin })
    )
end

return _snippets
