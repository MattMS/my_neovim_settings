# My Neovim settings

These are my configuration files for [Neovim](https://neovim.io/).

## File location

Windows settings location: `~/AppData/Local/nvim/init.vim`

To create a link to a folder in another location:

```
mklink /D %userprofile%\AppData\Local\nvim %userprofile%\Documents\GitHub\my_neovim_settings
```

Make sure to use `\` instead of `/` in the path, otherwise `mklink` will complain.

Found at: [.vimrc file in Windows](https://github.com/neovim/neovim/wiki/Installing-Neovim#vimrc-file-in-windows)

## File types

[File Type dependent key mapping](https://vi.stackexchange.com/questions/10664/file-type-dependent-key-mapping)

- Suggests `~/.vim/ftplugin/{filetype}_mappings.vim`.
- Requires `:filetype plugin on`.

## Packages

[How do I install Plugins in NeoVim Correctly @ Stack Overflow](https://stackoverflow.com/questions/48700563/how-do-i-install-plugins-in-neovim-correctly)

## License

[MIT](./LICENSE)
