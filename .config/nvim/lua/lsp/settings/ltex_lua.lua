local util = require("lspconfig.util")

local language_id_mapping = {
    bib = "bibtex",
    plaintex = "tex",
    rnoweb = "sweave",
    rst = "restructuredtext",
    tex = "latex",
    xhtml = "xhtml",
}

return {
    cmd = { "ltex-ls" },
    filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" },
    get_language_id = function(_, filetype)
        local language_id = language_id_mapping[filetype]
        if language_id then
            return language_id
        else
            return filetype
        end
    end,
    root_dir = function(path)
        -- Support git directories and git files (worktrees)
        if util.path.is_dir(util.path.join(path, ".git")) or util.path.is_file(util.path.join(path, ".git")) then
            return path
        end
    end,
    single_file_support = true,
    settings = {
        ltex = {
            enabled = { "latex", "tex", "bib", "markdown" },
            language = "de",
            diagnosticSeverity = "information",
            setenceCacheSize = 2000,
            additionalRules = {
                enablePickyRules = true,
                motherTongue = "de",
            },
            trace = { server = "verbose" },
            dictionary = {},
            disabledRules = {},
            hiddenFalsePositives = {},
        },
    },
}
