-- ==================== VimWiki ==================== --

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
    pattern = { "*diary/*.md" },
    command = "0r! " .. vim.fn.stdpath("config") .. "/scripts/vimwiki-diary-template.sh '%'",
})

return {
    {
        "mattn/calendar-vim",
        init = function()
            vim.g.calendar_monday = 1
        end,
    },
    {
        "vimwiki/vimwiki",
        init = function()
            vim.g.vimwiki_list = {
                {
                    path = "~/doc/vimwiki",
                    template_path = "~/doc/vimwiki/templates/",
                    template_default = "default",
                    syntax = "markdown",
                    ext = ".md",
                    path_html = "~/doc/vimwiki/site_html",
                    custom_wiki2html = "vimwiki_markdown",
                    template_ext = ".tpl",
                    auto_diary_index = 1,
                },
            }
            vim.g.vimwiki_global_ext = 0
            vim.cmd([[
    function! VimwikiLinkHandler(link)
        let link = a:link
        if link =~# '^vfile:'
            let link = link[1:]
        else
            return 0
        endif
        let link_infos = vimwiki#base#resolve_link(link)
        if link_infos.filename == ''
            echomsg 'Vimwiki Error: Unable to resolve link!'
            return 0
        else
            exe 'tabnew ' . fnameescape(link_infos.filename)
            return 1
        endif
    endfunction
]])
        end,
    },
}
