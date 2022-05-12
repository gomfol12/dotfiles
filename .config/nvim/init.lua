-- ==================== NVIM init ==================== --
-- TODO: Telescope, alpha color, fix weird snippet bug

local packer_install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

function _G.load_config()
    require("mappings")
    require("settings")
    require("lsp")
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
    require("tabline")
    require("sessionManager")
end

if vim.fn.isdirectory(packer_install_path) == 0 then
    vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_install_path })
    require("plugins")
    require("packer").sync()
    vim.cmd([[autocmd User PackerComplete ++once lua load_config()]])
else
    require("impatient")
    require("plugins")
    _G.load_config()
end
