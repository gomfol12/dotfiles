-- ==================== Completion (nvim-cmp, luasnip) ==================== --
-- TODO: diagnostics ???, git, fzf, pandoc + markdown

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local types = require("luasnip.util.types")
luasnip.config.setup({
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "●", "Todo" } }, -- yellow
            },
        },
        [types.insertNode] = {
            active = {
                virt_text = { { "●", "Constant" } }, -- blue
            },
        },
    },
})

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets/" })

local kind_icons = {
    Text = " ",
    Method = "m ",
    Function = " ",
    Constructor = " ",
    Field = " ",
    Variable = " ",
    Class = " ",
    Interface = " ",
    Module = " ",
    Property = " ",
    Unit = " ",
    Value = " ",
    Enum = " ",
    Keyword = " ",
    Snippet = " ",
    Color = " ",
    File = " ",
    Reference = " ",
    Folder = " ",
    EnumMember = " ",
    Constant = " ",
    Struct = " ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
}

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item()),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item()),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete()),
        ["<C-e>"] = cmp.mapping(cmp.mapping.abort()),
        ["<CR>"] = cmp.mapping(cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        })),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
                nvim_lsp_signature_help = "[SIG]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[NVIM_LUA]",
                omni = "[OMNI]",
                luasnip = "[LUASNIP]",
                git = "[GIT]",
                rg = "[RG]",
                calc = "[CALC]",
                dynamic = "[DYNAMIC]",
                path = "[PATH]",
                buffer = "[BUFFER]",
            })[entry.source.name]
            return vim_item
        end,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "omni" },
        { name = "luasnip" },
        { name = "git" },
        { name = "rg" },
        { name = "calc" },
        { name = "dynamic" },
        { name = "path" },
    }, {
        { name = "buffer" },
    }),
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})
require("cmp_git").setup()

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
                buffer = "[BUFFER]",
                cmdline_history = "[HIST]",
            })[entry.source.name]
            return vim_item
        end,
    },
    sources = cmp.config.sources({
        { name = "buffer" },
    }, {
        { name = "cmdline_history" },
    }),
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
                path = "[PATH]",
                cmdline = "[CMD]",
                cmdline_history = "[HIST]",
            })[entry.source.name]
            return vim_item
        end,
    },
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
        { name = "cmdline_history" },
    }),
})

local Date = require("cmp_dynamic.utils.date")
require("cmp_dynamic").setup({
    {
        label = "today",
        insertText = 1,
        cb = {
            function()
                return os.date("%Y/%m/%d")
            end,
        },
    },
    {
        label = "next Monday",
        insertText = 1,
        cb = {
            function()
                return Date.new():add_date(7):day(1):format("%Y/%m/%d")
            end,
        },
        resolve = true, -- default: false
    },
})
