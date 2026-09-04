-- local scan = require("plenary.scandir")
-- scan.scan_dir(".venv", { hidden = true, depth = 2 })

local path = require("plenary.path")
local scan = require("plenary.scandir")
local ACTIVE_VENV_BIN

local M = {}

---
---Set venv path
---
---@param venv {path: string, source: string}
M.set_venv_path = function(venv)
    if venv.source ~= "venv" then
        return
    end

    vim.fn.setenv("VIRTUAL_ENV", venv.path)
    local bin_path = (path:new(venv.path) / "bin"):absolute()
    local current_path = vim.fn.getenv("PATH")
    local path_entries = vim.split(current_path, ":", { plain = true })
    local preserved_entries = {}

    for _, entry in ipairs(path_entries) do
        if entry ~= ACTIVE_VENV_BIN then
            table.insert(preserved_entries, entry)
        end
    end

    vim.fn.setenv("PATH", bin_path .. ":" .. table.concat(preserved_entries, ":"))
    ACTIVE_VENV_BIN = bin_path
end

---
---Search for venv path
---
---@return string[]
local function search_for_venv_path()
    local paths = {}

    scan.scan_dir(".", {
        search_pattern = "pyvenv.cfg",
        on_insert = function(entry)
            local relative_path = string.match(entry, "(.*)/[^/]+$")
            if relative_path == nil then
                return
            end
            table.insert(paths, path:new(relative_path):absolute())
        end,
        hidden = true,
        depth = 3,
    })

    table.sort(paths)
    return paths
end

M.load_venv = function()
    local paths = search_for_venv_path()

    if #paths > 1 then
        vim.defer_fn(function()
            vim.ui.select(paths, { "Select venv" }, function(selected)
                if selected == nil then
                    return
                end
                M.set_venv_path({ path = selected, source = "venv" })
                print("Selected venv: " .. selected)
            end)
        end, 0)
    end
    if #paths == 1 then
        M.set_venv_path({ path = paths[1], source = "venv" })
        print("Selected venv: " .. paths[1])
    end
end

vim.api.nvim_create_user_command("LoadVenv", function()
    M.load_venv()
end, {
    desc = "Load venv",
})

return setmetatable({}, {
    __call = function()
        M.load_venv()
    end,
})
