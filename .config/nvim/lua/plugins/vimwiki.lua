-- ==================== VimWiki ==================== --

function _G.VimwikiLinkHandler(link)
    if not link:match("^vfile:") then
        return 0
    end

    link = link:sub(2)

    local link_infos = vim.fn["vimwiki#base#resolve_link"](link)

    if link_infos.filename == "" then
        vim.api.nvim_echo({ { "Vimwiki Error: Unable to resolve link!" } }, false, {})
        return 0
    else
        vim.cmd("tabnew " .. vim.fn.fnameescape(link_infos.filename))
        return 1
    end
end

local function custom_vimwiki_enter()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local char_under_cursor = line:sub(col + 1, col + 1)

    -- check if cursor is on a dash - or on empty/whitespace character
    if char_under_cursor == "-" or char_under_cursor:match("%s") or line:match("^%s*$") then
        local ok, _ = pcall(vim.fn["vimwiki#base#handle_wikilink_at_cursor"])
        if ok then
            return
        end

        local target = line:match("%[[^%]]+%]%(([^%)]+)%)")
        if target then
            if target:match("^vfile:") then
                local handled = VimwikiLinkHandler(target)
                if handled == 1 then
                    return
                end
            end
            vim.cmd("VimwikiGoto " .. target)
        end

        return
    end

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>VimwikiFollowLink", true, false, true), "n", true)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "vimwiki",
    callback = function()
        vim.keymap.set("n", "<CR>", custom_vimwiki_enter, {
            buffer = true,
            noremap = true,
            silent = true,
        })
    end,
})

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
                    return v:lua.VimwikiLinkHandler(a:link)
                endfunction
            ]])
        end,
    },
}
