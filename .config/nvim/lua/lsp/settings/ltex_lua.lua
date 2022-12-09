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
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    settings = {
        ltex = {
            enabled = { "latex", "tex", "bib", "markdown" },
            language = "en",
            diagnosticSeverity = "information",
            setenceCacheSize = 2000,
            additionalRules = {
                enablePickyRules = true,
                motherTongue = "en",
            },
            trace = { server = "verbose" },
            dictionary = {},
            disabledRules = {},
            hiddenFalsePositives = {},
        },
    },
}
