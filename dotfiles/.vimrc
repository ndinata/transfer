set nocompatible

" Plugins
" -------------------------------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'yggdroot/indentline'
Plug 'joshdick/onedark.vim'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'json', 'graphql', 'markdown', 'html', 'yaml'] }
Plug 'jiangmiao/auto-pairs'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'vim-python/python-syntax'
Plug 'SolaWing/vim-objc-syntax'
Plug 'rhysd/vim-clang-format', {
  \ 'for': ['c', 'cpp', 'objc']
  \ }

call plug#end()


" Settings
" -------------------------------------------------------------
filetype plugin indent on   " Load plugins according to detected filetype.

set autoindent              " Indent according to previous line.
set backspace=indent,eol,start
set cmdheight=2             " Set command-line height to 2 lines
set cursorline              " Improve visual indicator of current line.
set display=lastline        " Show as much as possible of the last line.
set encoding=utf-8
set expandtab               " Use spaces instead of tabs.
set ignorecase              " Case-insensitive search.
set incsearch               " Highlight while searching with / or ?.
set laststatus=2            " Always show status line.
set lazyredraw              " Only redraw when necessary.
set mouse=a                 " Enable use of mouse.
set noswapfile              " Load new buffer without creating a swapfile
set number                  " Display line numbers.
set ruler                   " Show cursor row and column position.
set scrolloff=3             " Show context above/below cursor line.
set shiftround              " Indents to next multiple of 'shiftwidth'.
set shiftwidth=2            " Indents by 2 spaces.
set signcolumn=yes          " Always show sign column next to line number column
set smartcase               " Case-sensitive search if any uppercase chars.
set softtabstop=2           " Tab key indents by 2 spaces.
set ttyfast                 " Faster redrawing.


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

" joshdick/onedark.vim
let g:onedark_hide_endofbuffer = 1              " hide end-of-buffer '~' lines

" prettier/vim-prettier
let g:prettier#autoformat = 1                   " enable auto formatting
let g:prettier#autoformat_require_pragma = 0    " auto formatting doesn't require @pragma

" pangloss/vim-javascript
let g:javascript_plugin_jsdoc = 1               " enable syntax highlighting for JSDocs
let g:javascript_plugin_flow = 1                " enable syntax highlighting for Flow

" vim-python/python-syntax
let g:python_highlight_all = 1
let g:python_highlight_file_headers_as_comments = 1

" rhysd/vim-clang-format
let g:clang_format#code_style = 'mozilla'
let g:clang_format#auto_format = 1              " enable format on save


" -------------------------------------------------------------
syntax on
colorscheme onedark
