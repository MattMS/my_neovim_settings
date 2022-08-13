local fzf = require("fzf")

-- Given a file path, split into the file path and the file name.
-- Also fix Windows path separators.
local function split_path_and_name (path)
	local fixed = string.gsub(path, "\\", "/")
	return fixed, ""
end

local function switch_buffer ()
	coroutine.wrap(function ()
		local buffers = {}
		for i, buffer_number in pairs(vim.api.nvim_list_bufs()) do
			local path, name = split_path_and_name(vim.api.nvim_buf_get_name(buffer_number))
			table.insert(buffers, string.format("%d (%s) %s", buffer_number, name, path))
		end
		local result = fzf.fzf(buffers, "", {
			border = true,
			window_on_create = function ()
				-- Sets the background to the same as the normal window.
				vim.cmd("set winhl=Normal:Normal")
			end
		})
		if result then
			local buffer_number = string.match(result[1], "%d+")
			vim.api.nvim_win_set_buf(0, tonumber(buffer_number))
		end
	end)()
end

-- File-type settings
-- ==================
--
-- - Get current file type: `:set filetype?`
--   From https://stackoverflow.com/questions/2779379/find-what-filetype-is-loaded-in-vim

vim.cmd("autocmd BufNewFile,BufRead *.dtf set filetype=dtf")
vim.cmd("autocmd BufNewFile,BufRead *.fs,*.fsi,*.fsx set filetype=fsharp")
vim.cmd("autocmd BufNewFile,BufRead *.fsproj set filetype=msbuild")

-- Variables
-- =========

-- Use space as the mapleader character.
-- let mapleader=" "
vim.g.mapleader = " "

-- Hide banner in file browser.
-- let g:netrw_banner=0
vim.g.netrw_banner = 0

-- Ignore case when sorting files.
-- let g:netrw_sort_options='i'
vim.g.netrw_sort_options = 'i'

-- Sneak
-- -----
--
-- - https://github.com/justinmk/vim-sneak
-- - https://github.com/justinmk/vim-sneak/blob/master/doc/sneak.txt
--
-- 0 is always case-insensitive.
-- 1 follows `ignorecase` and `smartcase`.
vim.cmd("let g:sneak#use_ic_scs=1")

-- Options
-- =======
--
-- - Help: `:help options`
-- - Access Set by Let: `let-option` `let-&`
-- - View Option: `:set laststatus?`

-- 0 = show on horizontal split.
-- 1 = show if 2+ windows.
-- 2 = always show.

vim.opt.laststatus = 0

vim.opt.ignorecase = true

vim.opt.mouse = "a"

vim.opt.ruler = false

vim.opt.smartcase = true

vim.opt.title = true

-- Normal-mode key-mappings
-- ========================

local function bind_insert (key, action)
	vim.keymap.set("i", key, action)
end

local function bind_normal (key, action)
	vim.keymap.set("n", key, action)
end

local function bind_normal_leader (key, action)
	vim.keymap.set("n", "<leader>" .. key, action)
end

local function bind_visual (key, action)
	vim.keymap.set("v", key, action)
end

local function cmd (action)
	return ":" .. action .. "<cr>"
end

-- Arrow
-- -----

local function bind_normal_arrows_hjkl (h, j, k, l)
	bind_normal("<down>", j)
	bind_normal("<left>", h)
	bind_normal("<right>", l)
	bind_normal("<up>", k)
end

local function bind_normal_ctrl_arrows_hjkl (h, j, k, l)
	bind_normal("<c-down>", j)
	bind_normal("<c-left>", h)
	bind_normal("<c-right>", l)
	bind_normal("<c-up>", k)
end

local function bind_normal_shift_arrows_hjkl (h, j, k, l)
	bind_normal("<s-down>", j)
	bind_normal("<s-left>", h)
	bind_normal("<s-right>", l)
	bind_normal("<s-up>", k)
end

-- Use arrow keys for buffer navigation.
local function bind_buf_nav (bind_hjkl)
	bind_hjkl("<c-b>", "<c-e>", "<c-y>", "<c-f>")
end

-- Use arrow keys for window navigation.
local function bind_win_nav (bind_hjkl)
	bind_hjkl("<c-w>h", "<c-w>j", "<c-w>k", "<c-w>l")
end

bind_buf_nav(bind_normal_arrows_hjkl)
bind_win_nav(bind_normal_shift_arrows_hjkl)
-- TODO: Ctrl+Arrows to create splits.

-- Arrow
-- -----

-- Add a new line after the current one.
-- nnoremap <Return> o<ESC>
bind_normal("<return>", "o<esc>")

-- Add a new line before the current one.
-- nnoremap <S-Return> O<ESC>j
bind_normal("<s-return>", "o<esc>j")

-- Split line.
-- nnoremap K i<CR><Esc>
bind_normal("<s-k>", "i<cr><esc>")

-- Sneak key-mappings
-- ------------------
--
-- `s-s` and `s` are bound to Sneak, after adding the plugin.
-- Normally `s` would be "substitute", behaving like `cl`.

-- This resets the binding for `s`.
-- nnoremap s cl
bind_normal("s", "cl")

-- nmap S <Plug>Sneak_S
bind_normal("<s-s>", "<plug>Sneak_S")

-- Reverse sneak with `s-s` is still possible.
-- nmap <m-s> <Plug>Sneak_s
bind_normal("<m-s>", "<plug>Sneak_s")

-- Ctrl key-mappings
-- -----------------

-- nmap <C-/> <Plug>CommentaryLine
bind_normal("<c-/>", "<Plug>CommentaryLine")

-- Ctrl-S to save.
-- nnoremap <silent> <c-s> :write<cr>
bind_normal("<c-s>", cmd("write"))

-- Ctrl-Q to quit completely.
-- nnoremap <silent> <c-q> :quitall<cr>
bind_normal("<c-q>", cmd("quitall"))

-- Leader key-mappings
-- -------------------

-- Stop highlighting matching text from the last search.
-- http://www.bestofvim.com/tip/switch-off-current-search/
bind_normal_leader("/", cmd("nohlsearch"))

-- [Set working directory to the current file](http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file)
bind_normal_leader("c", cmd("cd %:p:h"))

-- Delete the current buffer.
-- Same as `:bd`.
bind_normal_leader("d", cmd("bdelete"))

-- View files in folder of current buffer.
bind_normal_leader("e", cmd("Explore"))

-- Toggle relative line numbers in gutter.
-- Same as `:rnu`.
bind_normal_leader("i", cmd("set relativenumber!"))

-- Show last-modified time for current file.
bind_normal_leader("m", cmd("echo strftime('%F %T %z', getftime(@%))"))

-- Change to next buffer.
-- Same as `:bn`.
bind_normal_leader("n", cmd("bnext"))

-- Change to previous buffer.
-- Same as `:bp`.
bind_normal_leader("p", cmd("bprevious"))

bind_normal_leader("s", switch_buffer)

-- Show current local time.
-- From https://vim.fandom.com/wiki/Insert_current_date_or_time
bind_normal_leader("t", cmd("echo strftime('%F %T %z')"))

-- Control window splits with `space w` instead of `ctrl+w`
bind_normal_leader("w", "<c-w>")

-- Insert-mode key-mappings
-- ========================

-- inoremap <c-s> <esc>:write<cr>
bind_insert("<c-s>", "<esc>:write<cr>")

 -- Ctrl-V pastes from clipboard
 -- TODO: Fix issues with smart-comments.
bind_insert("<c-v>", "<c-r>*")

-- Visual-mode key-mappings
-- ------------------------

-- vmap <C-/> <Plug>Commentary
bind_visual("<c-/>", "<Plug>Commentary")

-- Cannot replace <C-C> with `"+y` since it always cancels the current mode.
-- vmap <S-y> "+y
bind_visual("<s-y>", '"+y')
