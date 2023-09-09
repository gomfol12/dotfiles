-- ==================== Autopairs (nvim-autopairs) ==================== --
-- TODO: https://github.com/altermo/ultimate-autopair.nvim

local npairs_ok, npairs = pcall(require, "nvim-autopairs")
local cmp_ok, cmp = pcall(require, "cmp")

if not npairs_ok and not cmp_ok then
    return
end

npairs.setup({
    disable_filetype = { "TelescopePrompt" },
    disable_in_macro = false, -- disable when recording or executing a macro
    disable_in_visualblock = false, -- disable when insert after visual block mode
    ignored_next_char = [=[[%w%%%'%[%"%.]]=],
    enable_moveright = true,
    enable_afterquote = true, -- add bracket pairs after quote
    enable_check_bracket_line = true, -- check bracket in same line
    enable_bracket_in_quote = true,
    enable_abbr = false, -- trigger abbreviation
    break_undo = true, -- switch for basic rule break undo sequence
    check_ts = true,
    map_cr = true,
    map_bs = true, -- map the <BS> key
    map_c_h = false, -- Map the <C-h> key to delete a pair
    map_c_w = false, -- map <c-w> to delete a pair if possible
    fast_wrap = {
        map = "<c-'>",
        chars = { "{", "[", "(", '"', "'", "$" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
    },
})

-- rules
local rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

npairs.add_rules({
    rule("$", "$", { "tex", "latex", "pandoc" })
        :with_pair(cond.not_after_regex("%%"))
        :with_pair(cond.not_before_regex("%%", 999))
        :with_cr(cond.none()),
})

npairs.add_rules({
    rule("\\[", "\\]", { "tex", "latex", "pandoc" })
        :with_pair(cond.not_after_regex("%%"))
        :with_pair(cond.not_before_regex("%%", 999))
        :with_cr(cond.none()),
})

-- space between brackets
local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
local brackets_rule = { "sh" }
npairs.add_rules({
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
    npairs.add_rules({
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

-- If you want insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
