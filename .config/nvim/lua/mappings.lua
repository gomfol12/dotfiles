-- ==================== Mappings ==================== --
-- :map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
-- :nmap  :nnoremap :nunmap    Normal
-- :vmap  :vnoremap :vunmap    Visual and Select
-- :smap  :snoremap :sunmap    Select
-- :xmap  :xnoremap :xunmap    Visual
-- :omap  :onoremap :ounmap    Operator-pending
-- :map!  :noremap! :unmap!    Insert and Command-line
-- :imap  :inoremap :iunmap    Insert
-- :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
-- :cmap  :cnoremap :cunmap    Command-line
-- :tmap  :tnoremap :tunmap    Terminal-Job
--
-- normal_mode          n
-- insert_mode          i
-- visual_mode          v
-- visual_block_mode    x
-- term_mode            t
-- command_mode         c
-- TODO: show documentation in preview window, auto formating

local utils = require('utils')

-- leader
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.b.mapleader = ' '

-- saving
utils.map('n', '<c-s>', ':w<CR>')
utils.map('i', '<c-s>', '<ESC>:w<CR>a')

-- source
--utils.map('n', '<c-c>', ':source ~/.config/nvim/init.lua<cr>')

-- window navigation
utils.map('n', '<c-j>', '<c-w>j')
utils.map('n', '<c-h>', '<c-w>h')
utils.map('n', '<c-k>', '<c-w>k')
utils.map('n', '<c-l>', '<c-w>l')

-- window resize
utils.map('n', '<Up>', ':resize -2<CR>', { silent = true})
utils.map('n', '<Down>', ':resize +2<CR>', { silent = true})
utils.map('n', '<Left>', ':vertical resize -2<CR>', { silent = true})
utils.map('n', '<Right>', ':vertical resize +2<CR>', { silent = true})

-- window splits
utils.map('n', '<leader>s', ':split<Space>')
utils.map('n', '<leader>v', ':vsplit<Space>')

-- bufferline
utils.map('n', '<S-l>', ':BufferLineCycleNext<cr>', { silent = true })
utils.map('n', '<S-h>', ':BufferLineCyclePrev<cr>', { silent = true })
utils.map('n', 'gb', ':BufferLinePick<cr>', { silent = true })
utils.map('n', 'gx', ':BufferLinePickClose<cr>', { silent = true })
utils.map('n', '<leader>x', ':Bdelete<cr>', { silent = true })
utils.map('n', ']b', ':BufferLineMoveNext<CR>', { silent = true })
utils.map('n', '[b', ':BufferLineMovePrev<CR>', { silent = true })

utils.map('n', '<leader>1', ':BufferLineGoToBuffer 1<cr>', { silent = true })
utils.map('n', '<leader>2', ':BufferLineGoToBuffer 2<cr>', { silent = true })
utils.map('n', '<leader>3', ':BufferLineGoToBuffer 3<cr>', { silent = true })
utils.map('n', '<leader>4', ':BufferLineGoToBuffer 4<cr>', { silent = true })
utils.map('n', '<leader>5', ':BufferLineGoToBuffer 5<cr>', { silent = true })
utils.map('n', '<leader>6', ':BufferLineGoToBuffer 6<cr>', { silent = true })
utils.map('n', '<leader>7', ':BufferLineGoToBuffer 7<cr>', { silent = true })
utils.map('n', '<leader>8', ':BufferLineGoToBuffer 8<cr>', { silent = true })
utils.map('n', '<leader>9', ':BufferLineGoToBuffer 9<cr>', { silent = true })

-- Map Ctrl-Backspace to delete the previous word in insert mode.
-- solution: https://vim.fandom.com/wiki/Map_Ctrl-Backspace_to_delete_previous_word
utils.map('!', '<C-BS>', '<C-w>')
utils.map('!', '<C-h>', '<C-w>')

-- search replace
utils.map('n', 'S', ':%s///g<Left><Left><Left>')

-- disable ex mode
utils.map('n', 'Q', '<nop>')

-- quit
utils.map('n', 'Q', ':q<cr>', { silent = true })

-- disable search highlighting until the next search
utils.map('n', '<cr>', ':noh<cr><cr>', { silent = true })

-- formating
-- put brackets around word/s
utils.map('n', '<leader>(', 'viwc()<esc>P')
utils.map('n', '<leader>{', 'viwc{}<esc>P')
utils.map('n', '<leader>[', 'viwc[]<esc>P')
utils.map('n', "<leader>'", "viwc''<esc>P")
utils.map('n', '<leader>"', 'viwc""<esc>P')

-- put brackets around selected
utils.map('x', '<leader>(', '<ESC>`>a)<ESC>`<i(<ESC>')
utils.map('x', '<leader>{', '<ESC>`>a}<ESC>`<i{<ESC>')
utils.map('x', '<leader>[', '<ESC>`>a]<ESC>`<i[<ESC>')
utils.map('x', "<leader>'", "<ESC>`>a'<ESC>`<i'<ESC>")
utils.map('x', '<leader>"', '<ESC>`>a"<ESC>`<i"<ESC>')

-- move selected text
utils.map('x', 'K', ":move '<-2<CR>gv-gv")
utils.map('x', 'J', ":move '>+1<CR>gv-gv")

utils.map('', '<leader>z', ':set formatoptions-=cro<cr>')
utils.map('', '<leader>Z', ':set formatoptions=cro<cr>')

-- Telescope
utils.map('n', '<leader>ff', ':Telescope find_files<cr>')
utils.map('n', '<leader>fg', ':Telescope live_grep<cr>')
utils.map('n', '<leader>fb', ':Telescope buffers<cr>')
utils.map('n', '<leader>fh', ':Telescope help_tags<cr>')
utils.map('n', '<leader>fp', ':Telescope media_files<cr>')

-- stay in indent mode
utils.map('v', '<', '<gv')
utils.map('v', '>', '>gv')

-- comments
--utils.map('n', '<leader>c', ':set operatorfunc=v:lua.__toggle_contextual<cr>g@l')
--utils.map('x', '<leader>c', ':set operatorfunc=v:lua.__toggle_contextual<cr>g@')

-- alpha
utils.map('n', '<c-a>', ':Alpha<cr>')

-- nvim tree
utils.map('n', '<c-n>', ':NvimTreeToggle<cr>', { silent = true })
