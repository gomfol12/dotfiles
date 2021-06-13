" ==================== Plugins(vim-plug) ====================
call plug#begin("$XDG_CONFIG_HOME/nvim/plugged")
    Plug 'tomasiser/vim-code-dark'
    Plug 'ap/vim-css-color'

    Plug 'preservim/nerdtree'
    "Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'
    "Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
call plug#end()

" ==================== General Settings ====================
set encoding=UTF-8
filetype plugin indent on " Enabling Plugin & Indent
syntax on
set autoread
set wildmenu
set wildmode=longest:full " autocompletion
set number relativenumber
set backspace=indent,eol,start " Making sure backspace works
set ruler " setting rulers & spacing, tabs
set confirm
set shiftwidth=4
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set expandtab
set hls is " search highlights
set ic " ignorecase in search patterns
set history=1000
set showcmd
set ttimeout
set ttimeoutlen=100
set laststatus=2
set cmdheight=1
"set spelllang=en_us,de_de
"set spell
set termguicolors

colorscheme codedark " colorscheme

" cursor
set cursorline
"set cursorcolumn
highlight CursorLine ctermbg=Gray cterm=bold guibg=#333333
"highlight CursorColumn ctermbg=Gray cterm=bold guibg=#222222

set splitbelow splitright " fix splitting

set path+=** " search down into subfolders. tab-completion

" file browsing
let g:netrw_banner=0 " disable banner
let g:netrm_browse_split=4 " open in prior window
let g:netrw_altv=1 " open splits to the right
let g:netrw_liststyle=3 " tree view

" statusline
set statusline=
set statusline+=\ %M
set statusline+=\ %y
set statusline+=\ %r
set statusline+=\ %F
set statusline+=%= " Right side settings
set statusline+=\ %c:%l/%L
set statusline+=\ %p%%
set statusline+=\ [%n]
set statusline+=\ [%{&fileencoding},%{&ff}]

set clipboard+=unnamedplus " use system clipboard

" vertically center document when entering insert mode
autocmd InsertEnter * norm zz

" remove trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" ==================== Mappings ====================
" :map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
" :nmap  :nnoremap :nunmap    Normal
" :vmap  :vnoremap :vunmap    Visual and Select
" :smap  :snoremap :sunmap    Select
" :xmap  :xnoremap :xunmap    Visual
" :omap  :onoremap :ounmap    Operator-pending
" :map!  :noremap! :unmap!    Insert and Command-line
" :imap  :inoremap :iunmap    Insert
" :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
" :cmap  :cnoremap :cunmap    Command-line
" :tmap  :tnoremap :tunmap    Terminal-Job

let mapleader=" "

" general
map <C-c> :source ~/.config/nvim/init.vim<CR>
map <C-s> :w<CR>

nnoremap S :%s///g<Left><Left><Left>

" disable ex mode
nnoremap Q <nop>

" disable search highlighting until the next search
nnoremap <silent> <CR> :noh<CR><CR>

" windows
nnoremap <Up> :resize -2<CR>
nnoremap <Down> :resize +2<CR>
nnoremap <Left> :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>

nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

nnoremap <leader>h :split<Space>
nnoremap <leader>v :vsplit<Space>

"formating
map <leader>p i(<ESC>ea)<ESC>
map <leader>l i{<ESC>ea}<ESC>

xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

map <leader>c :set formatoptions-=cro<CR>
map <leader>C :set formatoptions=cro<CR>

" enable spellchecking
map <leader>s :setlocal spell! spelllang=de_de,en_us<CR>

" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" ==================== NERDTree ====================
" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * silent NERDTreeMirror

let NERDTreeNaturalSort=1
