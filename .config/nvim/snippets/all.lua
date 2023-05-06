local latex_template = {
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
}

local markdown_template = {
    "---",
    "title: title",
    "author: author",
    "header-includes:",
    "    \\usepackage[a4paper, left=2.5cm, right=2.5cm, top=2.5cm, bottom=2.5cm]{geometry}",
    "---",
}
local markdown_template_math = {
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
}

local markdown_template_math_extended = {
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
}

local _snippets = {
    s("trig", {
        i(1),
        t("text"),
        i(2),
        t("text again"),
        i(3),
    }),
    s("latex", {
        t(latex_template),
    }),
    s("uninote", {
        t(markdown_template),
    }),
    s("uninotemath", {
        t(markdown_template_math),
    }),
    s("uninotemathextended", {
        t(markdown_template_math_extended),
    }),
    s("\\sumkn", {
        t("\\sum_{k=0}^n"),
    }),
    s("\\sumn", {
        t("\\sum_{n=0}^\\infty"),
    }),
    s("\\sumi", {
        t("\\sum_{}^\\infty"),
    }),
    s("\\sum", {
        t("\\sum_{}^"),
    }),
    s("\\N", {
        t("\\mathds{N}"),
    }),
    s("\\Z", {
        t("\\mathds{Z}"),
    }),
    s("\\Q", {
        t("\\mathds{R}"),
    }),
    s("\\R", {
        t("\\mathds{R}"),
    }),
    s("\\C", {
        t("\\mathds{C}"),
    }),
    s("\\K", {
        t("\\mathds{K}"),
    }),
    s("\\limn", {
        t("\\lim \\limits_{n \\to \\infty}"),
    }),
    s("\\limi", {
        t("\\lim \\limits_{ \\to \\infty}"),
    }),
    s("\\lim", {
        t("\\lim \\limits_{ \\to }"),
    }),
}

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
