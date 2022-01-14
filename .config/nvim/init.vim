" ==================== Plugins(vim-plug) ====================
call plug#begin("$XDG_CONFIG_HOME/nvim/plugged")
    Plug 'tomasiser/vim-code-dark'
    "Plug 'ap/vim-css-color'

    Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'
    "Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    "Plug 'lambdalisue/gina.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'jackguo380/vim-lsp-cxx-highlight'
    "Plug 'vim-syntastic/syntastic'
    Plug 'rhysd/vim-clang-format'
    Plug 'jiangmiao/auto-pairs'
    Plug 'ptzz/lf.vim'
    Plug 'voldikss/vim-floaterm'

    "snippets
    Plug 'one-harsh/vscode-cpp-snippets'
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
set shortmess+=c
set mouse=a
set title

" Map Ctrl-Backspace to delete the previous word in insert mode.
" solution: https://vim.fandom.com/wiki/Map_Ctrl-Backspace_to_delete_previous_word
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

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

" CocList
" Show all diagnostics.
nnoremap <silent><nowait> <leader>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<cr>
" Search workleader symbols.
nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <leader>b  :<C-u>CocListResume<CR>

" show documentation in preview window
nnoremap <silent> D :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

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
" put brackets around word
nnoremap <leader>( viwc()<ESC>P
nnoremap <leader>{ viwc{}<ESC>P
nnoremap <leader>[ viwc[]<ESC>P

nnoremap <leader>' viwc''<ESC>P
nnoremap <leader>" viwc""<ESC>P

" put brackets around selected text
xnoremap <leader>( <ESC>`>a)<ESC>`<i(<ESC>
xnoremap <leader>{ <ESC>`>a}<ESC>`<i{<ESC>
xnoremap <leader>[ <ESC>`>a]<ESC>`<i[<ESC>

xnoremap <leader>' <ESC>`>a'<ESC>`<i'<ESC>
xnoremap <leader>" <ESC>`>a"<ESC>`<i"<ESC>

xnoremap <silent> K :move '<-2<CR>gv-gv
xnoremap <silent> J :move '>+1<CR>gv-gv

map <leader>z :set formatoptions-=cro<CR>
map <leader>Z :set formatoptions=cro<CR>

autocmd FileType c,cpp,objc nnoremap <leader>F :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <leader>F :ClangFormat<CR>

" enable spellchecking
"map <leader>s :setlocal spell! spelllang=de_de,en_us<CR>

" completion
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" use <tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? coc#_select_confirm() :
"      \ coc#expandableOrJumpable() ? \"\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"      \ <SID>check_back_space() ? \"\<TAB>" :
"      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" use <S-Tab> to navigate back in the completion list
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" NERDTree
nnoremap <silent> <leader>n :NERDTreeFocus<CR>
nnoremap <silent> <C-n> :NERDTree<CR>
nnoremap <silent> <C-t> :NERDTreeToggle<CR>

"vim-floaterm
let g:floaterm_keymap_prev      = '<leader>tp'
let g:floaterm_keymap_next      = '<leader>tn'
let g:floaterm_keymap_new       = '<leader>tf'
let g:floaterm_keymap_toggle    = '<leader>to'
let g:floaterm_keymap_kill      = '<leader>tk'

"lf
map <silent> <leader>f :LfCurrentFileExistingOrNewTab<CR>

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
let g:coc_global_extensions = ['coc-json', 'coc-syntax', 'coc-dictionary', 'coc-html', 'coc-css', 'coc-pyright', 'coc-highlight', 'coc-snippets', 'coc-sql', 'coc-xml']

" fix json comment highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent if ! coc#float#has_scroll() | call CocActionAsync('highlight') | endif
autocmd CursorHoldI * silent if ! coc#float#has_scroll() | call CocActionAsync('showSignatureHelp') | endif

" Scroll in signature help
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

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

" ==================== vim-floaterm ====================
let g:floaterm_width = 1.0
let g:floaterm_height = 0.4
let g:floaterm_wintype = 'float'
let g:floaterm_position = 'bottom'
let g:floaterm_autoclose = 1

hi Floaterm guibg=black

" ==================== auto-pairs ====================
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', "`":"`", '```':'```', '"""':'"""', "'''":"'''"}

" ==================== lf.vim ====================
let g:lf_map_keys = 0

let g:NERDTreeHijackNetrw = 0
let g:lf_replace_netrw = 1
