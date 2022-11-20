local status, jdtls = pcall(require, "jdtls")
if not status then
    return
end

local home = os.getenv("HOME")
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
    return
end

local workspace_dir = home .. "/ndoc/java/"

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local bundles = {}
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
    bundles,
    vim.split(
        vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
        "\n"
    )
)

local config = {
    cmd = {

        "java",

        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        "-jar",
        vim.fn.glob(mason_path .. "packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),

        "-configuration",
        mason_path .. "packages/jdtls/config_linux",

        "-data",
        workspace_dir,
    },

    capabilities = vim.lsp.protocol.make_client_capabilities(),

    root_dir = root_dir,

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- or https://github.com/redhat-developer/vscode-java#supported-vs-code-settings
    -- for a list of options
    settings = {
        ["java.import.gradle.enabled"] = true,
        ["java.import.gradle.wrapper.enabled"] = true,
        ["java.import.maven.enabled"] = true,
        ["java.import.maven.wrapper.enabled"] = true,
        ["java.import.generatesMetadataFilesAtProjectRoot"] = true,
        java = {
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                    {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk/",
                    },
                    {
                        name = "JavaSE-1.8",
                        path = "/usr/lib/jvm/java-8-openjdk/",
                    },
                },
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
            format = {
                enabled = false,
            },
        },
        signatureHelp = { enabled = true },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
            filteredTypes = {
                "java.awt.List",
                "com.sun.*",
                "sun.*",
                "jdk.*",
                "org.graalvm.*",
                "io.micrometer.shaded.*",
                "java.awt.*",
            },
        },
        contentProvider = { preferred = "fernflower" },
        extendedClientCapabilities = extendedClientCapabilities,
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    },

    flags = {
        allow_incremental_sync = true,
    },

    init_options = {
        bundles = bundles,
    },
}

config["on_attach"] = function(client, bufnr)
    local _, _ = pcall(vim.lsp.codelens.refresh)

    require("jdtls.dap").setup_dap_main_class_configs()
    require("jdtls").setup_dap({ hotcodereplace = "auto" })

    require("lsp").keybinds(bufnr)
    require("lsp").highlight(client, bufnr)
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.java" },
    callback = function()
        local _, _ = pcall(vim.lsp.codelens.refresh)
    end,
})

jdtls.start_or_attach(config)

vim.cmd(
    [[command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)]]
)
vim.cmd([[command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()]])
