return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        local autopairs = require("nvim-autopairs")
        autopairs.setup({})

        -- If you want to automatically add `(` after selecting a function or method
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

        -- rules
        local rule = require("nvim-autopairs.rule")
        local cond = require("nvim-autopairs.conds")

        autopairs.add_rules({
            rule("$", "$", { "tex", "latex", "pandoc" })
                :with_pair(cond.not_after_regex("%%"))
                :with_pair(cond.not_before_regex("%%", 999))
                :with_cr(cond.none()),
        })

        autopairs.add_rules({
            rule("\\[", "\\]", { "tex", "latex", "pandoc" })
                :with_pair(cond.not_after_regex("%%"))
                :with_pair(cond.not_before_regex("%%", 999))
                :with_cr(cond.none()),
        })

        -- space between brackets
        local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
        local brackets_rule = { "sh" }
        autopairs.add_rules({
            rule(" ", " ", brackets_rule):with_pair(function(opts)
                local pair = opts.line:sub(opts.col - 1, opts.col)
                return vim.tbl_contains({
                    brackets[1][1] .. brackets[1][2],
                    brackets[2][1] .. brackets[2][2],
                    brackets[3][1] .. brackets[3][2],
                }, pair)
            end),
        })
        for _, bracket in pairs(brackets) do
            autopairs.add_rules({
                rule(bracket[1] .. " ", " " .. bracket[2], brackets_rule)
                    :with_pair(function()
                        return false
                    end)
                    :with_move(function(opts)
                        return opts.prev_char:match(".%" .. bracket[2]) ~= nil
                    end)
                    :use_key(bracket[2]),
            })
        end
    end,
}
