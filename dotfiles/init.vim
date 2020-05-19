" Plugins
" -------------------------------------------------------------------
call plug#begin(stdpath('data') . '/plugged')

" General
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
" Plug 'luochen1990/rainbow'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-surround'

" Colour schemes
" Plug 'joshdick/onedark.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'arzg/vim-colors-xcode'

" Language syntax
Plug 'vim-python/python-syntax'
" Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
" Plug 'peitalin/vim-jsx-typescript'
Plug 'SolaWing/vim-objc-syntax'
Plug 'vim-ruby/vim-ruby'
Plug 'arzg/vim-swift'

" Formatter/fixer/linter
Plug 'rhysd/vim-clang-format', {
  \ 'for': ['c', 'cpp', 'objc']
  \ }
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'json', 'graphql', 'markdown', 'html', 'yaml']
  \ }
Plug 'ruanyl/vim-sort-imports', {
  \ 'for': ['javascript', 'typescript']
  \ }

Plug 'ryanoasis/vim-devicons'

call plug#end()


" Settings
" -------------------------------------------------------------------
set autochdir                                     " update current directory on switching buffers
set cmdheight=2                                   " set command-line height to 2 lines
set expandtab                                     " use spaces instead of tabs
set hidden                                        " hides a buffer when it's abandoned
set ignorecase                                    " case-insensitive search
set list                                          " display invisible characters
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set mouse=a                                       " enable mouse
set noswapfile                                    " load new buffer without creating a swapfile
set number                                        " display line numbers
set scrolloff=3                                   " show vertical context by 5 lines
set shiftround                                    " indent to next multiple of 'shiftwidth'
set shiftwidth=2                                  " indent by 2 spaces
set shortmess+=c
set showmatch                                     " highlight matching [{()}]
set sidescrolloff=3                               " show horizontal context
set signcolumn=yes                                " always show column next to line number
set smartcase                                     " case-sensitive search if any uppercase characters
set smartindent
set softtabstop=2                                 " tab key indents by 2 spaces
set splitbelow                                    " split new panes to the bottom
set splitright                                    " split new panes to the right
set termguicolors
set updatetime=100                                " set delay before updates happen (ms)
set viewoptions-=options                          " disable saving/restoring local options & mappings

" Start terminal in Insert mode
au TermOpen term://* startinsert

" Automatically save and load folds
au BufWinLeave *.* mkview
au BufWinEnter *.* silent! loadview


" Key Mappings
" -------------------------------------------------------------------
" [n] Switching between windows: Ctrl + h,j,k,l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" [n] Switching between buffers: Shift + left,right
nnoremap <S-Left> :bprev<CR>
nnoremap <S-Right> :bnext<CR>

" [n] Open new empty buffer: <leader> t
nnoremap <leader>t :enew<CR>

" [nv] Toggle selected fold: Space
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" [t] Turn terminal to normal mode: Esc
tnoremap <Esc> <C-\><C-n>


" Plugin Settings
" -------------------------------------------------------------------
"  dense-analysis/ale
let g:ale_fix_on_save = 1
let g:ale_linters = {
  \ 'python': ['flake8', 'mypy', 'bandit'],
  \ }
let g:ale_fixers = {
  \ 'python': ['black', 'isort'],
  \ 'swift': ['swiftformat'],
  \ }
let g:ale_swift_swiftformat_options = '
  \ --indent 2
  \ --indentcase true
  \ --maxwidth 120
  \ --wrapcollections before-first
  \ '
nnoremap ]e :ALENextWrap<CR>
nnoremap [e :ALEPreviousWrap<CR>


" junegunn/fzf
" hide statusline for cleaner look
au! FileType fzf
au FileType fzf set laststatus=0 noshowmode noruler
  \| au BufLeave <buffer> set laststatus=2 showmode ruler
let g:fzf_action = {
  \ 'ctrl-t': 'vsplit',
  \ 'ctrl-s': 'split',
  \ }
nnoremap <C-p> :FZF<CR>


" preservim/nerdtree
" close vim if NERDTree is last open window
au BufEnter * if (winnr("$") == 1 &&
  \ exists("b:NERDTree") &&
  \ b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowHidden = 1                        " show hidden (dot) files
let NERDTreeMinimalUI = 1                         " hide Help message
let NERDTreeHighlightCursorline = 0
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>


" Plug 'luochen1990/rainbow'
" let g:rainbow_active = 1


" vim-airline/vim-airline
let g:airline#extensions#tabline#enabled = 1      " display all buffers
let g:airline#extensions#tabline#formatter = 'unique_tail'


" tpope/vim-commentary
" map to <C-_> because vim registers <C-/> as <C-_>
nmap <C-_> gcc
vmap <C-_> gc


" airblade/vim-gitgutter
nmap ghs :GitGutterStageHunk<CR>
nmap ghu :GitGutterUndoHunk<CR>
nmap ghp :GitGutterPreviewHunk<CR>
nmap ghf :GitGutterFold<CR>


" tiagofumo/vim-nerdtree-syntax-highlight
let g:NERDTreePatternMatchHighlightColor = {}
let g:NERDTreePatternMatchHighlightColor['.*\*$'] = ''
" let g:NERDTreeSyntaxDisableDefaultExtensions = 1
" let g:NERDTreeDisableExactMatchHighlight = 1
" let g:NERDTreeDisablePatternMatchHighlight = 1
" let g:NERDTreeSyntaxEnabledExtensions = [
"   \ 'css',
"   \ 'html',
"   \ 'java',
"   \ 'jpg',
"   \ 'js',
"   \ 'json',
"   \ 'md',
"   \ 'png',
"   \ 'py',
"   \ 'swift'
"   \ ]


" vim-python/python-syntax
let g:python_highlight_all = 1
let g:python_highlight_file_headers_as_comments = 1


" pangloss/vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1


" maxmellon/vim-jsx-pretty
let g:vim_jsx_pretty_colorful_config = 1          " highlight styles


" rhysd/vim-clang-format
let g:clang_format#auto_format = 1
let g:clang_format#code_style = 'mozilla'


" prettier/vim-prettier
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0


" joshdick/onedark.vim
" let g:onedark_hide_endofbuffer = 1              " hide end-of-buffer '~' lines

" arzg/vim-colors-xcode
" let g:xcodedark_match_paren_style = 1
" let g:xcodedark_dim_punctuation = 0


colorscheme dracula

