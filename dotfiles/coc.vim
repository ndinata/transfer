" General
Plug 'neoclide/coc.nvim', { 'branch' : 'release' }


" Plugin Settings
" -------------------------------------------------------------------
" neoclide/coc.nvim
" let g:coc_global_extensions = [
"   \ 'coc-css',
"   \ 'coc-html',
"   \ 'coc-json',
"   \ 'coc-tsserver',
"   \ 'coc-flow',
"   \ 'coc-eslint',
"   \ 'coc-python',
"   \ 'coc-sourcekit',
"   \ 'coc-snippets',
"   \ 'coc-emoji'
"   \ ]

" use <tab> to trigger completion options
inoremap <silent><expr> <Tab>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" use <C-Space> to trigger completion
inoremap <silent><expr> <C-Space> coc#refresh()

" use <CR> to select first completion item when no item is selected
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" navigate diagnostics
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)

" go-to code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" search workspace symbols
nnoremap <silent> <leader>fs :CocList -I symbols<CR>

" show commands
nnoremap <silent> <leader>fc :CocList commands<CR>

" use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" highlight the symbol and its references when holding the cursor
au CursorHold * silent call CocActionAsync('highlight')

