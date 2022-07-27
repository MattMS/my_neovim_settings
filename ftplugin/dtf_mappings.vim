" Insert mode

inoremap " ""<left>
inoremap ( (<cr>)<up><end><cr><tab>

inoremap <M-c> ```<cr>```<up><end><cr>

inoremap <tab> <esc>:s/^\(\s\+\)\([^ ]\+\) "\(.*\)"$/\1\2 <<END\r\1\3\r\1END/<cr>:nohlsearch<cr><up>A

" inoremap <M-n> note<space><lt><lt>END<cr>END<up><end><cr>
inoremap <M-n> note<space>""<left>

" https://vim.fandom.com/wiki/Insert_current_date_or_time
inoremap <M-s> start <C-R>=strftime("%H%M")<cr><cr>stop <C-R>=strftime("%H%M")<cr><up><end><esc>

imap <M-w> (act writing<cr>my times<cr><M-s><esc>

" Normal mode

nnoremap <M-o> %

" Visual mode

vnoremap <M-o> %
