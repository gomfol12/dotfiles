local augroup_name = "DiffColors"
local saved_hls = {}

local function save_current_diff_highlights()
    for _, group in ipairs({ "DiffAdd", "DiffDelete", "DiffChange", "DiffText" }) do
        saved_hls[group] = vim.api.nvim_get_hl(0, { name = group, link = false })
    end
end

local function restore_diff_highlights()
    for group, hl in pairs(saved_hls) do
        vim.api.nvim_set_hl(0, group, hl)
    end
end

local function set_diff_highlights()
    local highlights = vim.o.background == "dark"
            and {
                DiffAdd = "#2e4b2e",
                DiffDelete = "#4c1e15",
                DiffChange = "#45565c",
                DiffText = "#996d74",
            }
        or {
            DiffAdd = "palegreen",
            DiffDelete = "tomato",
            DiffChange = "lightblue",
            DiffText = "lightpink",
        }

    for group, color in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, { bold = true, fg = "NONE", bg = color })
    end
end

local function setup()
    vim.api.nvim_create_user_command("DiffHighlightEnable", function()
        save_current_diff_highlights()
        vim.api.nvim_create_augroup(augroup_name, { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = augroup_name,
            callback = set_diff_highlights,
        })
        set_diff_highlights()
    end, {})

    vim.api.nvim_create_user_command("DiffHighlightDisable", function()
        pcall(vim.api.nvim_del_augroup_by_name, augroup_name)
        restore_diff_highlights()
    end, {})
end

return {
    setup = setup,
}
