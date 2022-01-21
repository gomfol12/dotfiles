-- ==================== Comment (Comment.nvim) ==================== --

local status_ok, comment = pcall(require, "Comment")
if not status_ok then
    return
end

local cfg = ({
    pre_hook = function(ctx)
        local U = require("Comment.utils")

        local location = nil
        if ctx.ctype == U.ctype.block then
            location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring {
            key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
            location = location,
        }
    end,
    -- LHS of toggle mappings in NORMAL + VISUAL mode
    -- @type table
    toggler = {
        -- Line-comment toggle keymap
        line = 'gcc',
        -- Block-comment toggle keymap
        block = 'gbc',
    },

    -- LHS of operator-pending mappings in NORMAL + VISUAL mode
    -- @type table
    opleader = {
        -- Line-comment keymap
        line = 'gc',
        -- Block-comment keymap
        block = 'gb',
    },

    -- LHS of extra mappings
    -- @type table
    extra = {
        -- Add comment on the line above
        above = 'gcO',
        -- Add comment on the line below
        below = 'gco',
        -- Add comment at the end of line
        eol = 'gcA',
    },

    -- Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
    -- @type table
    mappings = {
        -- Operator-pending mapping
        -- Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
        -- NOTE: These mappings can be changed individually by `opleader` and `toggler` config
        basic = true,
        -- Extra mapping
        -- Includes `gco`, `gcO`, `gcA`
        extra = true,
        -- Extended mapping
        -- Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
        extended = false,
    },
    -- ignores empty lines
    ignore = '^$',
})

comment.setup(cfg)

-- comments
-- numToStr 2021
function _G.__toggle_contextual(vmode)
    local U = require("Comment.utils")
    local Op = require("Comment.opfunc")

    local range = U.get_region(vmode)
    local same_line = range.srow == range.erow

    local ctx = {
        cmode = U.cmode.toggle,
        range = range,
        cmotion = U.cmotion[vmode] or U.cmotion.line,
        ctype = same_line and U.ctype.line or U.ctype.block,
    }

    local lcs, rcs = U.parse_cstr(cfg, ctx)
    local lines = U.get_lines(range)

    local params = {
        range = range,
        lines = lines,
        cfg = cfg,
        cmode = ctx.cmode,
        lcs = lcs,
        rcs = rcs,
    }

    if lines[1] == nil then
        return
    end

    if same_line then
        Op.linewise(params)
    else
        Op.blockwise(params)
    end
end
