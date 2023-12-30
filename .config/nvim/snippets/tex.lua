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
    s({ trig = "dsumnk", dscr = "dsum n=0 to k" }, {
        t("\\dsum_{n=0}^k"),
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
        t("\\lim \\limits_{x \\to "),
        i(1),
        t("}"),
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
    s({ trig = ";P", snippetType = "autosnippet" }, {
        t("\\Phi"),
    }),
    s({ trig = ";e", snippetType = "autosnippet" }, {
        t("\\varepsilon"),
    }),
    s({ trig = ";i", snippetType = "autosnippet" }, {
        t("\\infty"),
    }),
    s({ trig = ";o", snippetType = "autosnippet" }, {
        t("\\varrho"),
    }),
    s({ trig = ";s", snippetType = "autosnippet" }, {
        t("\\psi"),
    }),
    s({ trig = ";m", snippetType = "autosnippet" }, {
        t("\\models"),
    }),
    s({ trig = ";I", snippetType = "autosnippet" }, {
        t("\\mathfrak{I}"),
    }),
    s({ trig = ";J", snippetType = "autosnippet" }, {
        t("\\mathfrak{I}"),
    }),
    s({ trig = ";B", snippetType = "autosnippet" }, {
        t("\\mathds{B}"),
    }),
    s({ trig = ";v", snippetType = "autosnippet" }, {
        t("\\mathcal{V}"),
    }),
    s({ trig = ";t", snippetType = "autosnippet" }, {
        t("\\mathcal{T}"),
    }),
    s({ trig = ";A", snippetType = "autosnippet" }, {
        t("\\mathcal{A}"),
    }),

    s({ trig = "=>", snippetType = "autosnippet" }, {
        t("\\Rightarrow"),
    }),
    s({ trig = "->", snippetType = "autosnippet" }, {
        t("\\rightarrow"),
    }),
    s({ trig = "=<>", snippetType = "autosnippet" }, {
        t("\\Leftrightarrow"),
    }),
    s({ trig = "-<>", snippetType = "autosnippet" }, {
        t("\\leftrightarrow"),
    }),
    s({ trig = "-|>", snippetType = "autosnippet" }, {
        t("\\mapsto"),
    }),
}

local function add_snippet_math(trigger, replace, replace_table, dscr)
    table.insert(
        _snippets,
        s({
            trig = trigger,
            regTrig = false,
            wordTrig = true,
            dscr = dscr,
        }, fmta(replace, replace_table), { condition = in_mathzone })
    )
end

local function add_auto_snippet_math(trigger, replace, replace_table, dscr)
    table.insert(
        _snippets,
        s({
            trig = trigger,
            regTrig = false,
            wordTrig = true,
            snippetType = "autosnippet",
            dscr = dscr,
        }, fmta(replace, replace_table), { condition = in_mathzone })
    )
end

local function add_auto_snippet(trigger, replace, replace_table, dscr)
    table.insert(
        _snippets,
        s({
            trig = trigger,
            regTrig = false,
            wordTrig = true,
            snippetType = "autosnippet",
            dscr = dscr,
        }, fmta(replace, replace_table))
    )
end

local function add_snippet(trigger, replace, replace_table, dscr)
    table.insert(
        _snippets,
        s({
            trig = trigger,
            regTrig = false,
            wordTrig = true,
            dscr = dscr,
        }, fmta(replace, replace_table))
    )
end

add_snippet(
    "eq",
    [[
    \begin{equation*}
        <>
    \end{equation*}
    ]],
    { i(0) },
    "Equation environment"
)
add_snippet(
    "ca",
    [[
    \begin{cases}
        <>
    \end{cases}
    ]],
    { i(0) },
    "Align environment"
)
add_snippet(
    "al",
    [[
    \begin{align*}
        <>
    \end{align*}
    ]],
    { i(0) },
    "Align environment"
)
add_snippet(
    "ce",
    [[
    \begin{center}
        <>
    \end{center}
    ]],
    { i(0) },
    "Center environment"
)
add_snippet(
    "env",
    [[
    \begin{<>}
        <>
    \end{<>}
    ]],
    {
        i(1),
        i(0),
        rep(1),
    },
    "Environment"
)

add_snippet_math(
    "mat2",
    [[
    \begin{pmatrix}
    <> & <> \\
    <> & <>
    \end{pmatrix}
    ]],
    { i(1), i(2), i(3), i(4) },
    "2x2 Matrix"
)

add_snippet_math("tiny", "{\\tiny <>}", { d(1, get_visual) }, "tiny")
add_snippet_math("small", "{\\small <>}", { d(1, get_visual) }, "small")
add_snippet_math("norm", "{\\normal <>}", { d(1, get_visual) }, "normal")
add_snippet_math("large", "{\\large <>}", { d(1, get_visual) }, "large")
add_snippet_math("huge", "{\\huge <>}", { d(1, get_visual) }, "huge")
add_snippet_math("tbf", "\\textbf{<>}", { d(1, get_visual) }, "textbf")
add_snippet_math("tit", "\\textit{<>}", { d(1, get_visual) }, "textit")
add_snippet_math("underline", "\\underline{<>}", { d(1, get_visual) }, "underline")
add_snippet_math("under", "\\underline{<>}", { d(1, get_visual) }, "underline")
add_snippet_math("overline", "\\overline{<>}", { d(1, get_visual) }, "overline")
add_snippet_math("over", "\\overline{<>}", { d(1, get_visual) }, "overline")

add_auto_snippet_math("ff", "\\frac{<>}{<>}", { i(1), i(2) })

add_auto_snippet_math("mm", "$<>$", { d(1, get_visual) })
add_auto_snippet_math("ee", "e^{<>}", { d(1, get_visual) })

add_auto_snippet_math("cd", "\\cdot", {})

add_auto_snippet_math("in", "\\in", {})
add_auto_snippet_math("to", "\\to", {})

add_snippet_math("int", "displaystyle \\int_{<>}^{<>} <> ~d", { i(1), i(2), i(3) }, "int _ to _")
add_snippet_math("intu", "displaystyle \\int <> ~d", { i(1) }, "int unbestimmt")
add_snippet_math("intab", "displaystyle \\int_{a}^{b} <> ~d", { i(1) }, "int a to b")
add_snippet_math("intabx", "displaystyle \\int_{a}^{b} <> ~dx", { i(1) }, "int a to b dx")

add_snippet_math("big", "\\big|_{<>}^{<>}", { i(1), i(2) }, "big| _ to _")
add_snippet_math("bigab", "\\big|_{x=a}^{x=b}", {}, "big| a to b")

add_auto_snippet_math("sq", "\\sqrt{<>}<>", { i(1), i(2) })
add_auto_snippet_math("sn", "\\sqrt[n]{<>}<>", { i(1), i(2) })

add_snippet_math("left", "\\left(<>\\right)", { i(1) }, "big ()")

add_auto_snippet_math(">=", "\\geq", {})
add_auto_snippet_math("<=", "\\leq", {})
add_auto_snippet_math("!=", "\\not =", {})

add_snippet_math("sub", "\\subset", {})
add_snippet_math("sube", "\\subseteq", {})

add_auto_snippet_math("par", "\\partial", {})
add_auto_snippet_math("nab", "\\nabla", {})

add_auto_snippet_math("and", "\\land", {})
add_auto_snippet_math("or", "\\lor", {})

add_auto_snippet_math("ne", "\\neg", {})
add_auto_snippet_math("==", "\\equiv", {})

add_auto_snippet_math("ex", "\\exists", {})
add_auto_snippet_math("all", "\\forall", {})

add_snippet_math("angle", "\\langle <> \\rangle", { i(1) })

for _, num in ipairs({ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, "n", "k", "d", "p" }) do
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
    table.insert(
        _snippets,
        s(
            { trig = "([%a%)%]%}])_" .. num .. num, regTrig = true, wordTrig = false, snippetType = "autosnippet" },
            fmta("<>_{<>}", {
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
