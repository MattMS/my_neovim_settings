-- autocmd FileType fsharp setlocal commentstring=//%s
vim.cmd("setlocal commentstring=//%s")
-- Does not appear to work when doing `vim.b.commentstring = "//%s"`

-- autocmd FileType fsharp setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
vim.b.expandtab = true
vim.b.shiftwidth = 4
vim.b.softtabstop = 4
vim.b.tabstop = 4
