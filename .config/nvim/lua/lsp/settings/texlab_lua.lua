local util = require("lspconfig.util")

return {
    cmd = { "texlab" },
    filetypes = { "tex", "bib" },
    root_dir = function(fname)
        return util.root_pattern(".latexmkrc")(fname) or util.find_git_ancestor(fname)
    end,
    settings = {
        texlab = {
            auxDirectory = ".",
            bibtexFormatter = "texlab",
            build = {
                args = { "-pdflua", "-interaction=nonstopmode", "-synctex=1", "-outdir=build", "%f" },
                executable = "latexmk",
                forwardSearchAfter = false,
                onSave = true,
            },
            chktex = {
                onEdit = true,
                onOpenAndSave = true,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
                executable = "zathura.sh",
                args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
            latexFormatter = "latexindent",
            latexindent = {
                modifyLineBreaks = false,
            },
        },
    },
    single_file_support = true,
}
