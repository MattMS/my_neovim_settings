-- From https://stackoverflow.com/questions/11983282/vim-how-to-map-command-according-to-buffer-type
-- autocmd BufReadPost quickfix nnoremap <buffer> <cr> <cr>
vim.keymap.set("n", "<cr>", "<cr>", {buffer = true})
