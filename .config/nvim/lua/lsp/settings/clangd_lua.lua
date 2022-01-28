local util = require("lspconfig.util")

return {
    -- offsetEncoding = "utf-8",
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git") or util.dirname,
    single_file_support = true,
}
