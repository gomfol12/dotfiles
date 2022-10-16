-- ==================== Overseer (overseer.nvim) ==================== --

local status_ok, overseer = pcall(require, "overseer")
if not status_ok then
    return
end

overseer.setup({
    templates = {
        "builtin",
        "user.cpp_build",
        "user.run_current_file",
        "user.cmake_debug_build",
        "user.make_build",
        "user.cmake_release_build",
    },
})

vim.api.nvim_create_user_command("WatchRun", function()
    overseer.run_template({ name = "run current file" }, function(task)
        if task then
            task:add_component({ "restart_on_save", path = vim.fn.expand("%:p") })
            local main_win = vim.api.nvim_get_current_win()
            overseer.run_action(task, "open hsplit")
            vim.api.nvim_set_current_win(main_win)
        else
            vim.notify("WatchRun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
        end
    end)
end, {})

vim.api.nvim_create_user_command("Make", function(params)
    local task = overseer.new_task({
        cmd = vim.split(vim.o.makeprg, "%s+"),
        args = params.fargs,
        components = {
            { "on_output_quickfix", open = not params.bang, open_height = 8 },
            "default",
        },
    })
    task:start()
end, {
    desc = "",
    nargs = "*",
    bang = true,
})

vim.api.nvim_create_user_command("OverseerRestartLast", function()
    local tasks = overseer.list_tasks({ recent_first = true })
    if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
    else
        overseer.run_action(tasks[1], "restart")
    end
end, {})
