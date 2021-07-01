" ==================== Plugins(vim-plug) ====================
call plug#begin("$XDG_CONFIG_HOME/nvim/plugged")
    Plug 'tomasiser/vim-code-dark'
    Plug 'ap/vim-css-color'

    Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'
    "Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    "Plug 'lambdalisue/gina.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'jackguo380/vim-lsp-cxx-highlight'
    "Plug 'vim-syntastic/syntastic'
    Plug 'rhysd/vim-clang-format'
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
set cmdheight=2
"set spelllang=en_us,de_de
"set spell
set termguicolors
set nobackup
set nowritebackup
set hidden
set updatetime=300
set signcolumn=yes

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

" quit
nnoremap <silent> Q :q<CR>

" navigate diagnostics
nmap <silent> <leader>d <Plug>(coc-diagnostic-next)
nmap <silent> <leader>D <Plug>(coc-diagnostic-prev)

" gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" show documentation in preview window
nnoremap <silent> D :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" disable search highlighting until the next search
nnoremap <silent> <CR> :noh<CR><CR>

" rename
nmap <silent> <leader>r  <Plug>(coc-rename)
nmap <silent> <F2>       <Plug>(coc-rename)

" windows
nnoremap <silent> <Up> :resize -2<CR>
nnoremap <silent> <Down> :resize +2<CR>
nnoremap <silent> <Left> :vertical resize -2<CR>
nnoremap <silent> <Right> :vertical resize +2<CR>

nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

nnoremap <leader>h :split<Space>
nnoremap <leader>v :vsplit<Space>

" formating
map <leader>p i(<ESC>ea)<ESC>
map <leader>l i{<ESC>ea}<ESC>

xnoremap <silent> K :move '<-2<CR>gv-gv
xnoremap <silent> J :move '>+1<CR>gv-gv

map <leader>c :set formatoptions-=cro<CR>
map <leader>C :set formatoptions=cro<CR>

autocmd FileType c,cpp,objc nnoremap <leader>f :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <leader>f :ClangFormat<CR>

" enable spellchecking
map <leader>s :setlocal spell! spelllang=de_de,en_us<CR>

" completion
" use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" use <S-Tab> to navigate back in the completion list
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" NERDTree
nnoremap <silent> <leader>n :NERDTreeFocus<CR>
nnoremap <silent> <C-n> :NERDTree<CR>
nnoremap <silent> <C-t> :NERDTreeToggle<CR>

" ==================== NERDTree ====================
" Start NERDTree and put the cursor back in the other window.
"autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * silent NERDTreeMirror

let NERDTreeNaturalSort=1

" ==================== nerdtree-git-plugin ====================
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }

let g:NERDTreeGitStatusUseNerdFonts = 1

" ==================== Coc ====================
" fix json comment highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" ==================== vim-lsp-cxx-highlight ====================
" c++ syntax highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

" ==================== syntastic ====================
let g:syntastic_cpp_checkers = ['cpplint']
let g:syntastic_c_checkers = ['cpplint']
let g:syntastic_cpp_cpplint_exec = 'cpplint'
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" ==================== vim-clang-format ====================
let g:clang_format#code_style = 'gnu'
