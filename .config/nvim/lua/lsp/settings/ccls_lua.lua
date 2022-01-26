local util = require("lspconfig.util")

return {
    init_options = {
        compilationDatabaseDirectory = "build",
        index = {
            threads = 0,
        },
        clang = {
            excludeArgs = { "-frounding-math" },
        },
    },
    cmd = { "ccls" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    -- offset_encoding = "utf-16",
    root_dir = util.root_pattern("compile_commands.json", ".ccls", ".git"),
    single_file_support = false,
}
