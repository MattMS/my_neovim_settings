" - Copy to clipboard: `"+y`
" - Paste from clipboard: `"+p`
" - Reload init.vim (if editing): `:so %`
"
" - Get current file type: `:set filetype?`
"   From https://stackoverflow.com/questions/2779379/find-what-filetype-is-loaded-in-vim

" colorscheme slate 

" Use space as the mapleader character.
let mapleader=" "

" Hide banner in file browser.
let g:netrw_banner=0

" Ignore case when sorting files.
let g:netrw_sort_options='i'

" Interface settings
" ==================

" 0 = show on horizontal split.
" 1 = show if 2+ windows.
" 2 = always show.
set laststatus=0

set title

" File-type settings
" ==================

" F#
" --

autocmd BufNewFile,BufRead *.fs,*.fsi,*.fsx set filetype=fsharp
autocmd BufNewFile,BufRead *.fsproj set filetype=fsharp_project

autocmd FileType fsharp setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Markdown
" --------

autocmd FileType markdown setlocal tabstop=4

" Quickfix
" --------

" From https://stackoverflow.com/questions/11983282/vim-how-to-map-command-according-to-buffer-type
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

" Yaml
" ----

" From https://stackoverflow.com/questions/26962999/wrong-indentation-when-editing-yaml-in-vim
" And https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Normal-mode key-mappings
" ========================

" Add a new line after the current one.
nnoremap <Return> o<ESC>

" Add a new line before the current one.
nnoremap <S-Return> O<ESC>j

" Split line.
nnoremap K i<CR><Esc>

" `S` and `s` around bound to Sneak.
" Normally `s` would be "substitute", behaving like `cl`.

" Ctrl key-mappings
" -----------------

" Ctrl-S to save.
nnoremap <silent> <C-S> :write<CR>

" Ctrl-Q to quit completely.
nnoremap <silent> <C-Q> :quitall<CR>

" Leader key-mappings
" -------------------

" Stop highlighting matching text from the last search.
" http://www.bestofvim.com/tip/switch-off-current-search/
nnoremap <silent> <Leader>/ :nohlsearch<CR>

" [Set working directory to the current file](http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file)
nnoremap <Leader>C :cd %:p:h<CR>

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

" Show current local time.
" From https://vim.fandom.com/wiki/Insert_current_date_or_time
nnoremap <Leader>t :echo strftime('%F %T %z')<CR>

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

