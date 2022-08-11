-- From https://stackoverflow.com/questions/26962999/wrong-indentation-when-editing-yaml-in-vim
-- And https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces
-- autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
vim.b.expandtab = true
vim.b.shiftwidth = 2
vim.b.softtabstop = 2
vim.b.tabstop = 2
