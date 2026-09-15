local M = {}

local id = ("%x"):format(vim.uv.hrtime())
local state_file = vim.fn.stdpath("state") .. "/kitty_links_server-" .. id

--@param cmd string
--@param args string[]
local function kitty_command(cmd, args)
    local command = { "kitten", "@", cmd }

    for _, arg in ipairs(args) do
        table.insert(command, vim.fn.fnameescape(arg))
    end

    vim.fn.jobstart(command, {
        detach = true,
    })
end

---@param path string
---@param line number?
function M.open(path, line)
    path = vim.fn.fnamemodify(path, ":p")

    local bufnr = vim.fn.bufnr(path)

    if bufnr ~= -1 then
        local wins = vim.fn.win_findbuf(bufnr)

        if #wins > 0 then
            vim.api.nvim_set_current_win(wins[1])
        else
            vim.cmd("buffer " .. bufnr)
        end
    else
        vim.cmd("edit " .. vim.fn.fnameescape(path))
    end

    if line then
        line = math.max(1, tonumber(line) or 1)

        local last_line = vim.api.nvim_buf_line_count(0)
        line = math.min(line, last_line)

        vim.api.nvim_win_set_cursor(0, { line, 0 })
        vim.cmd("normal! zz")
    end

    kitty_command("focus-window", { "--match", "title:.*nvim.*" })
end

vim.api.nvim_create_user_command("KittyOpen", function(opts)
    local path, line = opts.args:match("^(.*):(%d+)$")

    if path then
        M.open(path, tonumber(line))
    else
        M.open(opts.args)
    end
end, {
    nargs = 1,
})

if state_file and vim.v.servername ~= "" then
    vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
    vim.fn.writefile({ vim.v.servername }, state_file)
    kitty_command("set-user-vars", { "kitty_links_server=" .. state_file })

    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            pcall(vim.fn.delete, state_file)
            kitty_command("set-user-vars", { "kitty-links-server", "" })
        end,
    })
end

return M
