-- ==================== Statuscolumn (statuscol.nvim) ==================== --
-- NOTE: get names `:I vim.fn.sign_getdefined()`

return {}

-- return {
--     "luukvbaal/statuscol.nvim",
--     config = function()
--         local builtin = require("statuscol.builtin")
--         require("statuscol").setup({

--             relculright = true,
--             segments = {
--                 {
--                     sign = { namespace = { "gitsigns" }, colwidth = 1, wrap = true },
--                     click = "v:lua.ScLa",
--                 },
--                 {
--                     sign = { namespace = { "diagnostic/signs" }, colwidth = 2 },
--                     click = "v:lua.ScLa",
--                 },
--                 {
--                     sign = { name = { "Dap" }, colwidth = 1 },
--                     click = "v:lua.ScLa",
--                 },
--                 {
--                     text = { builtin.lnumfunc },
--                     condition = { true, builtin.not_empty },
--                     click = "v:lua.ScLa",
--                 },
--                 { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
--             },
--         })
--     end,
-- }
