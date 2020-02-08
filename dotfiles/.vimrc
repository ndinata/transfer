set nocompatible
filetype plugin indent on   " Load plugins according to detected filetype.
syntax on                   " Enable syntax highlighting.

set autoindent              " Indent according to previous line.
set expandtab               " Use spaces instead of tabs.
set softtabstop=2           " Tab key indents by 2 spaces.
set shiftwidth=2            " Indents by 2 spaces.
set shiftround              " Indents to next multiple of 'shiftwidth'.

set backspace=indent,eol,start
set display=lastline        " Show as much as possible of the last line.

set mouse=a                 " Enable use of mouse.

set ignorecase              " Case-insensitive search.
set incsearch               " Highlight while searching with / or ?.
set number                  " Display line numbers.
" set list                    " Show non-printable, e.g. '\n', characters.
set ruler                   " Show cursor row and column position.

set ttyfast                 " Faster redrawing.
set lazyredraw              " Only redraw when necessary.

set cursorline              " Improve visual indicator of current line.
set wrapscan                " Searches wrap around EOF.
"
colorscheme onedark

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

" let Vundle manage Vundle
" Plug 'altercation/vim-colors-solarized'
" Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-sleuth'
" Plug 'tpope/vim-rhubarb'
" Plug 'chrisbra/Recover.vim'
" " Plug 'scrooloose/syntastic'
" Plug 'dense-analysis/ale'
" Plug 'scrooloose/nerdcommenter'
" Plug 'scrooloose/nerdtree'
" Plug 'MattesGroeger/vim-bookmarks' "See :help Bookmarks
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'ctrlpvim/ctrlp.vim'
" Plug 'majutsushi/tagbar'
" Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'junegunn/vim-peekaboo'
" Plug 'hdima/python-syntax'
" Plug 'skielbasa/vim-material-monokai'
" Plug 'ayu-theme/ayu-vim'
" Plug 'vim-scripts/BufOnly.vim'
" Plug 'lervag/vimtex'

