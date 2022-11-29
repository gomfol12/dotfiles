-- ==================== NVIM init ==================== --
-- TODO: Telescope, alpha color, lualine

local packer_install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
    vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. packer_install_path)
    vim.cmd([[packadd packer.nvim]])
    require("plugins")
    require("packer").sync()

    print("==================================")
    print("    Plugins are being installed")
    print("    Wait until Packer completes,")
    print("       then restart nvim")
    print("==================================")
    return
end

function _G.load_config()
    require("mappings")
    require("settings")
    require("lsp")()
    require("completion")
    require("treesitter")
    require("tele")
    require("pairs")
    require("comment")
    require("start")
    require("tree")
    require("git")
    require("statusline")
    require("spell")
    require("debugui")
    -- require("tabline")
    require("sessionManager")
    require("color")
    require("mason-update-all").setup()
    require("task")
    require("plugin_conf")
end

require("impatient")
require("plugins")
load_config()
vim.cmd([[autocmd User PackerComplete ++once lua load_config()]])
