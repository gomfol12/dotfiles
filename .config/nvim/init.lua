-- ==================== NVIM init ==================== --

require("config.mappings")
require("config.settings")
require("config.cmds")
require("config.toggle-checkbox").setup()
require("config.statusline")
require("config.spell")
require("config.auto-template-insert")

require("config.lazy")

require("config.venv_switcher")()
