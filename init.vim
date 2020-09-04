" - Copy to clipboard: `"+y`
" - Paste from clipboard: `"+p`
" - Reload init.vim (if editing): `:so %`

" colorscheme slate 

" Use space as the mapleader character.
let mapleader=" "

" Normal-mode key-mappings
" ========================

" Add a new line after the current one.
nnoremap <Return> o<ESC>

" Add a new line before the current one.
nnoremap <S-Return> O<ESC>j

" Ctrl key-mappings
" -----------------

" Ctrl-S to save.
nnoremap <silent> <C-S> :write<CR>

" Ctrl-Q to quit completely.
nnoremap <silent> <C-Q> :quitall<CR>

" Leader key-mappings
" -------------------

" Delete the current buffer.
" Same as `:bd`.
nnoremap <Leader>d :bdelete<CR>

" View files in folder of current buffer.
nnoremap <Leader>e :Explore<CR>

" Toggle relative line numbers in gutter.
" Same as `:rnu`.
nnoremap <Leader>i :set relativenumber!<CR>

" Change to next buffer.
" Same as `:bn`.
nnoremap <Leader>n :bnext<CR>

" Change to previous buffer.
" Same as `:bp`.
nnoremap <Leader>p :bprevious<CR>

" Control window splits with `Space w` instead of `Ctrl+w`
nnoremap <Leader>w <C-W>

" Insert-mode key-mappings
" ========================

" Ctrl-V pastes from clipboard
" TODO: Fix issues with smart-comments.
inoremap <C-V> <C-R>*

" Visual-mode key-mappings
" ========================

" Cannot replace <C-C> with `"+y` since it always cancels the current mode.
" vnoremap <C-C> "+y

