-- ==================== autocmds, augroups, usercmds, ... ==================== --

local utils = require("config.utils")

-- disable on BufEnter conceal for specific filetypes and re-enable it on BufLeave
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.qmd", "*.md", "*.json" },
    callback = function()
        if vim.bo.filetype == "vimwiki" then
            vim.cmd("set conceallevel=2")
            return
        end
        vim.cmd("set conceallevel=0")
    end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
    pattern = { "*.qmd", "*.md", "*.json" },
    callback = function()
        if vim.bo.filetype == "vimwiki" then
            vim.cmd("set conceallevel=2")
            return
        end
        vim.cmd("set conceallevel=1")
    end,
})

-- highlight on yank
vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- vertically center document when entering insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    command = "norm zz",
})

-- Autocommand that reloads xresources
vim.api.nvim_create_augroup("xresources_user_config", { clear = true })
if utils.getHost() == os.getenv("HOSTNAME_LAPTOP") then
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = "xresources_user_config",
        pattern = "laptop.Xresources",
        command = "silent! !xrdb -merge " .. os.getenv("XDG_CONFIG_HOME") .. "/laptop.Xresources",
    })
else
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = "xresources_user_config",
        pattern = "Xresources",
        command = "silent! !xrdb -merge " .. os.getenv("XDG_CONFIG_HOME") .. "/Xresources",
    })
end

-- Disable automatic comment insertion
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    command = "setlocal formatoptions-=cro",
})

-- Line length marker at 80 columns and format
for _, k in pairs({ "markdown", "pandoc" }) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = k,
        callback = function()
            vim.opt.colorcolumn = "80"
            vim.opt.textwidth = 80
            -- vim.cmd("set fo+=a")
        end,
    })
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "/tmp/calcurse*",
    command = "set filetype=markdown",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "~/.local/share/calcurse/notes/*",
    command = "set filetype=markdown",
})

-- remove trailing spaces
vim.api.nvim_create_augroup("myformat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = "myformat",
    pattern = "*",
    callback = function()
        if vim.g.disable_autoformat or vim.b[0].disable_autoformat then
            return
        end
        if
            vim.bo.filetype == "markdown"
            or vim.bo.filetype == "vimwiki"
            or vim.bo.filetype == "pandoc"
            or vim.bo.filetype == "latex"
            or vim.bo.filetype == "quarto"
        then
            return
        end
        local view = vim.fn.winsaveview()
        vim.cmd([[%s/\v\s+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- Enable/Disable autoformat
vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable auto formatting",
    bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable auto formatting",
})

-- ========== usercmds ========== --

vim.api.nvim_create_user_command("Bonly", function()
    vim.cmd('execute "%bd|e#|bd#"')
end, { nargs = 0 })

-- Inspect command
vim.api.nvim_create_user_command("I", function(opts)
    local chunk, load_err = load("return " .. opts.args)
    if chunk then
        local ok, result = pcall(chunk)
        if ok then
            print(vim.inspect(result))
        else
            print("Error evaluating expression: " .. result)
        end
    else
        print("Error loading expression: " .. load_err)
    end
end, { nargs = 1 })

-- Search Escape String
vim.api.nvim_create_user_command("Sescstr", [[/\\".\{-}\\"]], { nargs = 0 })
-- Search String
vim.api.nvim_create_user_command("Sstr", [[/".\{-}"]], { nargs = 0 })

-- markdown paste url
vim.api.nvim_create_user_command("MdPasteUrl", function()
    local url = vim.fn.getreg("+") -- Clipboard register
    vim.api.nvim_put({ string.format("[](%s)", url) }, "c", true, true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("F[", true, true, true), "n", true)
end, { desc = "Markdown paste url" })

-- count words in latex file
local function word_count()
    local filepath = vim.fn.expand("%:p")
    if filepath == "" then
        print("No file loaded.")
        return
    end

    local handle = io.popen('detex "' .. filepath .. '" | wc -w')
    if handle then
        local result = handle:read("*a")
        handle:close()
        print("Word count: " .. result:gsub("%s+", ""))
    else
        print("Error running detex or wc.")
    end
end
vim.api.nvim_create_user_command("WC", word_count, {})
