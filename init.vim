" - Copy to clipboard: `"+y`
" - Paste from clipboard: `"+p`
" - Reload init.vim (if editing): `:so %`

" colorscheme slate 

" Variables
" =========
"
" - View Variable: `:echo g:mapleader`
"
" https://stackoverflow.com/questions/9193066/how-do-i-inspect-vim-variables

" Use space as the mapleader character.
let mapleader=" "

" Hide banner in file browser.
let g:netrw_banner=0

" Ignore case when sorting files.
let g:netrw_sort_options='i'

" Sneak
" -----
"
" - https://github.com/justinmk/vim-sneak
" - https://github.com/justinmk/vim-sneak/blob/master/doc/sneak.txt

" 0 is always case-insensitive.
" 1 follows `ignorecase` and `smartcase`.
let g:sneak#use_ic_scs=1

" Options
" =======
"
" - Help: `:help options`
" - Access Set by Let: `let-option` `let-&`
" - View Option: `:set laststatus?`

" 0 = show on horizontal split.
" 1 = show if 2+ windows.
" 2 = always show.
set laststatus=0

set ignorecase

set noruler

set smartcase

set title

" File-type settings
" ==================
"
" - Get current file type: `:set filetype?`
"   From https://stackoverflow.com/questions/2779379/find-what-filetype-is-loaded-in-vim

" F#
" --

autocmd BufNewFile,BufRead *.fs,*.fsi,*.fsx set filetype=fsharp
autocmd BufNewFile,BufRead *.fsproj set filetype=fsharp_project

autocmd FileType fsharp setlocal commentstring=//%s
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

nmap <C-/> <Plug>CommentaryLine

" Add a new line after the current one.
nnoremap <Return> o<ESC>

" Add a new line before the current one.
nnoremap <S-Return> O<ESC>j

" Split line.
nnoremap K i<CR><Esc>

" `S` and `s` are bound to Sneak, after adding the plugin.
" Normally `s` would be "substitute", behaving like `cl`.
" This resets the binding for `s` and adds Alt+s and Alt+S for Vim Sneak.
" Reverse sneak with `S` is still possible.
nnoremap s cl
nmap S <Plug>Sneak_S
nmap <M-s> <Plug>Sneak_s

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

" Show last-modified time for current file.
nnoremap <Leader>m :echo strftime('%F %T %z', getftime(@%))<CR>

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

inoremap <C-S> <Esc>:write<CR>

" Ctrl-V pastes from clipboard
" TODO: Fix issues with smart-comments.
inoremap <C-V> <C-R>*

" Visual-mode key-mappings
" ========================

vmap <C-/> <Plug>Commentary

" Cannot replace <C-C> with `"+y` since it always cancels the current mode.
" vnoremap <C-C> "+y

