-- ==================== Fold (nvim-ufo) ==================== --

-- handler for folded lines to show number of folded line and some eyecandy
local handler_folded = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = vim.g.have_nerd_font and ("  %d "):format(endLnum - lnum) or (" %d "):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    local lastHlGroup = "MoreMsg"

    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        lastHlGroup = chunk[2] or lastHlGroup

        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, lastHlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)

            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end

            break
        end

        curWidth = curWidth + chunkWidth
    end

    table.insert(newVirtText, { suffix, lastHlGroup })

    return newVirtText
end

return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    keys = {
        {
            "zR",
            function()
                require("ufo").openAllFolds()
            end,
            mode = "n",
            desc = "Open all folds",
        },
        {
            "zM",
            function()
                require("ufo").closeAllFolds()
            end,
            mode = "n",
            desc = "Close all folds",
        },
        {
            "zr",
            function()
                require("ufo").openFoldsExceptKinds()
            end,
            mode = "n",
            desc = "Open folds except Kinds",
        },
        {
            "zm",
            function()
                require("ufo").closeFoldsWith()
            end,
            mode = "n",
            desc = "Close folds with",
        },
        {
            "U",
            function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end,
            mode = "n",
            desc = "Peek folded lines",
        },
    },
    opts = {
        open_fold_hl_timeout = 150,
        close_fold_kinds_for_ft = {
            default = {
                "imports" --[[ , "comment" ]],
            },
            -- json = { "array" },
            -- c = { "comment", "region" },
        },
        preview = {
            win_config = {
                border = { "", "─", "", "", "", "─", "", "" },
                winhighlight = "Normal:Folded",
                winblend = 0,
            },
            mappings = {
                scrollU = "<C-u>",
                scrollD = "<C-d>",
                jumpTop = "[",
                jumpBot = "]",
            },
        },
        fold_virt_text_handler = handler_folded,
    },
}
