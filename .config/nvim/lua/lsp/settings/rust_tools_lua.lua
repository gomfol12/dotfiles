return setmetatable({}, {
    __call = function(_, opts)
        return {
            tools = {
                inlay_hints = {
                    -- automatically set inlay hints (type hints)
                    auto = true,

                    -- Only show inlay hints for the current line
                    only_current_line = true,

                    -- whether to show parameter hints with the inlay hints or not
                    show_parameter_hints = true,

                    -- prefix for parameter hints
                    parameter_hints_prefix = "<- ",

                    -- prefix for all the other hints (type, chaining)
                    other_hints_prefix = "=> ",

                    -- whether to align to the length of the longest line in the file
                    max_len_align = false,

                    -- padding from the left if max_len_align is true
                    max_len_align_padding = 1,

                    -- whether to align to the extreme right or not
                    right_align = false,

                    -- padding from the right if right_align is true
                    right_align_padding = 7,

                    -- The color of the hints
                    highlight = "Comment",
                },

                hover_actions = {

                    -- the border that is used for the hover window
                    -- see vim.api.nvim_open_win()
                    border = {
                        { "╭", "FloatBorder" },
                        { "─", "FloatBorder" },
                        { "╮", "FloatBorder" },
                        { "│", "FloatBorder" },
                        { "╯", "FloatBorder" },
                        { "─", "FloatBorder" },
                        { "╰", "FloatBorder" },
                        { "│", "FloatBorder" },
                    },

                    -- Maximal width of the hover window. Nil means no max.
                    max_width = nil,

                    -- Maximal height of the hover window. Nil means no max.
                    max_height = nil,

                    -- whether the hover action window gets automatically focused
                    auto_focus = false,
                },
            },

            server = vim.tbl_deep_extend("force", {
                -- standalone file support
                standalone = true,
            }, opts),

            dap = {
                adapter = {
                    type = "executable",
                    command = "lldb-vscode",
                    name = "rt_lldb",
                },
            },
        }
    end,
})
