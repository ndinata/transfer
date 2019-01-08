set ic
set is
set autoindent
set ruler
set softtabstop=4
set shiftwidth=4
set expandtab
set number
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
