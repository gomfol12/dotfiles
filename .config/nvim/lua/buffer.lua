-- ==================== Buffer (bufferline.nvim) ==================== --
-- TODO: color

local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
    return
end

bufferline.setup({
    options = {
        numbers = "none", --| "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        -- NOTE: this plugin is designed with this icon in mind,
        -- and so changing this is NOT recommended, this is intended
        -- as an escape hatch for people who cannot bear it for whatever reason
        indicator_icon = "▎",
        buffer_close_icon = "x",
        modified_icon = "*",
        close_icon = "x",
        left_trunc_marker = "<",
        right_trunc_marker = ">",
        --- name_formatter can be used to change the buffer's label in the bufferline.
        --- Please note some names can/will break the
        --- bufferline so use this at your discretion knowing that it has
        --- some limitations that will *NOT* be fixed.
        -- name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
        --     -- remove extension from markdown files for example
        --     if buf.name:match('%.md') then
        --         return vim.fn.fnamemodify(buf.name, ':t:r')
        --     end
        -- end,
        max_name_length = 30,
        max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
        tab_size = 21,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = true,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return "" .. icon .. count
        end,
        -- NOTE: this will be called a lot so don't do any heavy processing here
        -- custom_filter = function(buf_number, buf_numbers)
        --     -- filter out filetypes you don't want to see
        --     if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
        --         return true
        --     end
        --     -- filter out by buffer name
        --     if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
        --         return true
        --     end
        --     -- filter out based on arbitrary rules
        --     -- e.g. filter out vim wiki buffer from tabline in your work repo
        --     if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
        --         return true
        --     end
        --     -- filter out by it's index number in list (don't show first buffer)
        --     if buf_numbers[1] ~= buf_number then
        --         return true
        --     end
        -- end,
        offsets = { { filetype = "NvimTree", text = "", text_align = "left" } },
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        -- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
        --     -- add custom logic
        --     return buffer_a.modified > buffer_b.modified
        -- end
    },
    highlights = {
        fill = {
            guifg = "#ff0000",
            guibg = "TabLine",
        },
        background = {
            guifg = "TabLine",
            guibg = "TabLine",
        },

        tab = {
            guifg = "TabLine",
            guibg = "TabLine",
        },
        tab_selected = {
            guifg = "Normal",
            guibg = "Normal",
        },
        tab_close = {
            guifg = "TabLineSel",
            guibg = "Normal",
        },

        --[[ close_button = {
            guifg = 'TabLine',
            guibg = 'TabLine'
        },
        close_button_visible = {
            guifg = 'TabLine',
            guibg = 'TabLine'
        },
        close_button_selected = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>'
        }, ]]

        buffer_visible = {
            guifg = "TabLine",
            guibg = "TabLine",
        },
        buffer_selected = {
            guifg = "TabLine",
            guibg = "Tabline",
            gui = "bold",
        },

        --[[ diagnostic = {
            guifg = 'TabLine',
            guibg = 'TabLine',
        },
        diagnostic_visible = {
            guifg = 'TabLine',
            guibg = 'TabLine',
        },
        diagnostic_selected = {
            guifg = 'TabLine',
            guibg = 'TabLine',
            gui = "bold"
        }, ]]

        --[[ info = {
            guifg = '<color-value-here>',
            guisp = '<color-value-here>',
            guibg = '<color-value-here>'
        },
        info_visible = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>'
        },
        info_selected = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>',
            gui = "bold,italic",
            guisp = '<color-value-here>'
        },
        info_diagnostic = {
            guifg = '<color-value-here>',
            guisp = '<color-value-here>',
            guibg = '<color-value-here>'
        },
        info_diagnostic_visible = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>'
        },
        info_diagnostic_selected = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>',
            gui = "bold,italic",
            guisp = '<color-value-here>'
        }, ]]

        --[[ warning = {
            guifg = '<color-value-here>',
            guisp = '<color-value-here>',
            guibg = '<color-value-here>'
        },
        warning_visible = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>'
        },
        warning_selected = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>',
            gui = "bold,italic",
            guisp = '<color-value-here>'
        },
        warning_diagnostic = {
            guifg = '<color-value-here>',
            guisp = '<color-value-here>',
            guibg = '<color-value-here>'
        },
        warning_diagnostic_visible = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>'
        },
        warning_diagnostic_selected = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>',
            gui = "bold,italic",
            guisp = warning_diagnostic_fg
        }, ]]

        --[[ error = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>',
            guisp = '<color-value-here>'
        },
        error_visible = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>'
        },
        error_selected = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>',
            gui = "bold,italic",
            guisp = '<color-value-here>'
        },
        error_diagnostic = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>',
            guisp = '<color-value-here>'
        },
        error_diagnostic_visible = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>'
        },
        error_diagnostic_selected = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>',
            gui = "bold,italic",
            guisp = '<color-value-here>'
        }, ]]

        modified = {
            guifg = "TabLine",
            guibg = "Tabline",
        },
        modified_visible = {
            guifg = "TabLine",
            guibg = "TabLine",
        },
        modified_selected = {
            guifg = "Normal",
            guibg = "Normal",
        },

        duplicate_selected = {
            guifg = "TabLineSel",
            gui = "bold",
            guibg = "TabLineSel",
        },
        duplicate_visible = {
            guifg = "TabLine",
            gui = "bold",
            guibg = "TabLine",
        },
        duplicate = {
            guifg = "TabLine",
            gui = "bold",
            guibg = "TabLine",
        },

        --[[ separator_selected = {
            guifg = 'Normal',
            guibg = 'Normal'
        }, ]]
        --[[ separator_visible = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>'
        }, ]]
        --[[ separator = {
            guifg = 'TabLine',
            guibg = 'TabLine'
        }, ]]

        indicator_selected = {
            guifg = "LspDiagnosticsDefaultHint",
            guibg = "Normal",
        },

        --[[ pick_selected = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>',
            gui = "bold,italic"
        },
        pick_visible = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>',
            gui = "bold,italic"
        },
        pick = {
            guifg = '<color-value-here>',
            guibg = '<color-value-here>',
            gui = "bold,italic"
        } ]]
    },
})
