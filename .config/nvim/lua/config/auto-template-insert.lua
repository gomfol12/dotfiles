local function insert_header_guard()
    -- local def = vim.fn.expand("%:t:r") .. "_" .. vim.fn.expand("%:e")

    vim.api.nvim_buf_set_lines(0, 0, 0, false, {
        "#pragma once",
        "",
    })

    vim.api.nvim_win_set_cursor(0, { 3, 0 })
end

local function insert_main_c()
    vim.api.nvim_buf_set_lines(0, 0, 0, false, {
        "#include <stdio.h>",
        "",
        "int main(int argc, char *argv[])",
        "{",
        "    ",
        "    return 0;",
        "}",
    })

    vim.api.nvim_win_set_cursor(0, { 5, 4 })
end

local function insert_main_cpp()
    vim.api.nvim_buf_set_lines(0, 0, 0, false, {
        "#include <iostream>",
        "",
        "int main(int argc, char *argv[])",
        "{",
        "    ",
        "    return 0;",
        "}",
    })

    vim.api.nvim_win_set_cursor(0, { 5, 4 })
end

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.h",
    callback = insert_header_guard,
})

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "main.c",
    callback = insert_main_c,
})

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "main.cpp",
    callback = insert_main_cpp,
})

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.py",
    callback = function()
        vim.api.nvim_buf_set_lines(0, 0, 0, false, {
            "#!/usr/bin/env python",
        })
    end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.sh",
    callback = function()
        vim.api.nvim_buf_set_lines(0, 0, 0, false, {
            "#!/usr/bin/env bash",
        })
    end,
})
