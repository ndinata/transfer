set nocompatible

" Plugins
" -------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" General
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'yggdroot/indentline'
Plug 'preservim/nerdtree', {
  \ 'on': 'NERDTreeToggle'
  \ }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'andymass/vim-matchup'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', {
  \ 'on': 'NERDTreeToggle'
  \ }
Plug 'tpope/vim-surround'

" Language syntax
Plug 'vim-python/python-syntax'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
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
  \ 'for': ['javascript']
  \ }

" Colour schemes
Plug 'joshdick/onedark.vim'
Plug 'arzg/vim-colors-xcode'

" Priority plugins
Plug 'ryanoasis/vim-devicons'

call plug#end()


" Settings
" -------------------------------------------------------------
set autoindent              " Indent according to previous line.
set autoread                " Detect file changes made outside of Vim.
set backspace=indent,eol,start
set cmdheight=2             " Set command-line height to 2 lines.
set cursorline              " Improve visual indicator of current line.
set display+=lastline       " Show as much as possible of the last line.
set encoding=utf-8
set expandtab               " Use spaces instead of tabs.
set formatoptions+=j        " Delete comment character when joining commented lines.
set history=1000            " History of :commands and search patterns.
set hlsearch                " Highlight search matches.
set ignorecase              " Case-insensitive search.
set incsearch               " Highlight while searching with / or ?
set laststatus=2            " Always show status line.
set lazyredraw              " Only redraw when necessary.
set list                    " Display invisible chars.
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set mouse=a                 " Enable use of mouse.
set noswapfile              " Load new buffer without creating a swapfile.
set nrformats-=octal        " don't treat numbers starting with 0 to be octal.
set number                  " Display line numbers.
set ruler                   " Show cursor row and column position.
set scrolloff=5             " Show context above/below cursor line.
set shiftround              " Indents to next multiple of 'shiftwidth'.
set shiftwidth=2            " Indents by 2 spaces.
set showcmd                 " Show partial commands.
set sidescrolloff=5         " Show context horizontally.
set signcolumn=yes          " Always show sign column next to line number.
set smartcase               " Case-sensitive search if any uppercase chars.
set smartindent
set smarttab
set softtabstop=2           " Tab key indents by 2 spaces.
set ttimeout                " Allow timeout on key codes.
set ttimeoutlen=100         " Wait for 100ms before timing out.
set ttyfast                 " Faster redrawing.
set updatetime=100          " Set delay before updates happen (ms)
set viewoptions-=options    " Disable saving/restoring local options and mappings.
set wildignore+=*/node_modules/*
set wildmenu                " Show options when attempting autocomplete.

" Set italic escape codes
set t_ZH=[3m
set t_ZR=[23m

" Allow colour schemes to do bright colours without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif


" Key mappings
" -------------------------------------------------------------
let mapleader = ","

" Switching between windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" preservim/nerdtree
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>


" Onedark color scheme settings
" -------------------------------------------------------------
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif

  if (has("termguicolors"))
    set termguicolors
  endif
endif


" Plugin configs
" -------------------------------------------------------------

" dense-analysis/ale
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

" yggdroot/indentline
let g:indentLine_char = '▏'
let g:vim_json_conceal = 0                      " fix quotes not showing in JSON files

" preservim/nerdtree
" close vim if NERDTree is last open window
autocmd BufEnter * if (winnr("$") == 1 &&
      \ exists("b:NERDTree") &&
      \ b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowHidden = 1                      " show hidden (dot) files
let NERDTreeHighlightCursorline = 0
let NERDTreeMinimalUI = 1                       " hide Help message

" xuyuanp/nerdtree-git-plugin
let g:NERDTreeIndicatorMapCustom = {
  \ "Modified": "M",
  \ "Staged": "S",
  \ "Untracked": "U",
  \ "Renamed": "R",
  \ "Deleted": "D",
  \ "Dirty": "*",
  \ }

" tiagofumo/vim-nerdtree-syntax-highlight
let g:NERDTreeSyntaxDisableDefaultExtensions = 1
let g:NERDTreeDisableExactMatchHighlight = 1
let g:NERDTreeDisablePatternMatchHighlight = 1
let g:NERDTreeSyntaxEnabledExtensions = [
  \ 'css',
  \ 'html',
  \ 'java',
  \ 'jpg',
  \ 'js',
  \ 'json',
  \ 'md',
  \ 'png',
  \ 'py',
  \ 'swift'
  \ ]

" vim-python/python-syntax
let g:python_highlight_all = 1
let g:python_highlight_file_headers_as_comments = 1

" pangloss/vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

" maxmellon/vim-jsx-pretty
let g:vim_jsx_pretty_colorful_config = 1        " highlight styles

" rhysd/vim-clang-format
let g:clang_format#auto_format = 1
let g:clang_format#code_style = 'mozilla'

" prettier/vim-prettier
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

" joshdick/onedark.vim
let g:onedark_hide_endofbuffer = 1              " hide end-of-buffer '~' lines

" arzg/vim-colors-xcode
let g:xcodedark_match_paren_style = 1
let g:xcodedark_dim_punctuation = 0


" -------------------------------------------------------------
syntax on
colorscheme xcodedark


" -------------------------------------------------------------
highlight MatchWord
      \ ctermfg=lightblue guifg=lightblue
      \ ctermbg=NONE guibg=NONE
      \ cterm=italic gui=italic

