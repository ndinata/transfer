set nocompatible

" Plugins
" -------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" General
Plug 'jiangmiao/auto-pairs'
Plug 'yggdroot/indentline'
Plug 'airblade/vim-gitgutter'
Plug 'andymass/vim-matchup'
Plug 'tpope/vim-surround'

" Language syntax
Plug 'vim-python/python-syntax'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'SolaWing/vim-objc-syntax'
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
set history=1000            " History of : commands and search patterns.
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
set smarttab
set softtabstop=2           " Tab key indents by 2 spaces.
set ttimeout                " Allow timeout on key codes.
set ttimeoutlen=100         " Wait for 100ms before timing out.
set ttyfast                 " Faster redrawing.
set updatetime=100          " Set delay before updates happen (ms)
set viewoptions-=options    " Disable saving/restoring local options and mappings.
set wildmenu                " Show options when attempting autocomplete.

" set italic escape codes
set t_ZH=[3m
set t_ZR=[23m

" Allow colour schemes to do bright colours without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif


" Onedark color scheme settings
" -------------------------------------------------------------
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif


" Plugin configs
" -------------------------------------------------------------

" yggdroot/indentline
let g:indentLine_char = '▏'
let g:vim_json_conceal = 0                      " fix quotes not showing in JSON files

" vim-python/python-syntax
let g:python_highlight_all = 1
let g:python_highlight_file_headers_as_comments = 1

" pangloss/vim-javascript
let g:javascript_plugin_jsdoc = 1               " enable syntax highlighting for JSDocs
let g:javascript_plugin_flow = 1                " enable syntax highlighting for Flow

" maxmellon/vim-jsx-pretty
let g:vim_jsx_pretty_colorful_config = 1        " highlight styles

" rhysd/vim-clang-format
let g:clang_format#auto_format = 1              " enable format on save
let g:clang_format#code_style = 'mozilla'

" prettier/vim-prettier
let g:prettier#autoformat = 1                   " enable auto formatting
let g:prettier#autoformat_require_pragma = 0    " auto formatting doesn't require @pragma

" joshdick/onedark.vim
let g:onedark_hide_endofbuffer = 1              " hide end-of-buffer '~' lines

" arzg/vim-colors-xcode
let g:xcodedark_match_paren_style = 1
let g:xcodedark_dim_punctuation = 0


" -------------------------------------------------------------
syntax on
colorscheme xcodedark


" -------------------------------------------------------------
highlight MatchWord ctermfg=lightblue guifg=lightblue ctermbg=NONE guibg=NONE cterm=italic gui=italic

