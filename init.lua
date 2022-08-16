local add = require "add"
local fzf_pick = require("fzf_pick")
local keymap = require "keymap"
local move = require "move"
local Rx = require 'rx'

local function compose (f, g)
	return function (v)
		return g(f(v))
	end
end

local function equals (v1)
	return function (v2)
		return v1 == v2
	end
end

local function list_append (list, value)
	table.insert(list, value)
	return list
end

-- Given a file path, split into the file path and the file name.
-- Also fix Windows path separators.
local function split_path_and_name (path)
	local fixed = string.gsub(path, "\\", "/")
	return fixed, ""
end

local function buffer_is_listed (buffer_number)
	return vim.bo[buffer_number].buflisted
end

local function switch_buffer_2 ()
	local buffers = Rx.Observable.fromTable(vim.api.nvim_list_bufs())

	buffers
	:filter(buffer_is_listed)
	:map(function (buffer_number)
		local path, name = split_path_and_name(vim.api.nvim_buf_get_name(buffer_number))
		return string.format("%d (%s) %s", buffer_number, name, path)
	end)
	:reduce(list_append, {})
	:subscribe(function (buffers)
		-- print(vim.inspect(buffers))
		fzf_pick.full(buffers, function (result)
			local buffer_number = string.match(result, "%d+")
			vim.api.nvim_win_set_buf(0, tonumber(buffer_number))
		end)
	end)
end

local function switch_buffer ()
	local buffers = {}
	for i, buffer_number in pairs(vim.api.nvim_list_bufs()) do
		local path, name = split_path_and_name(vim.api.nvim_buf_get_name(buffer_number))
		table.insert(buffers, string.format("%d (%s) %s", buffer_number, name, path))
	end
	fzf_pick.full(buffers, function (result)
		local buffer_number = string.match(result, "%d+")
		vim.api.nvim_win_set_buf(0, tonumber(buffer_number))
	end)
end

local function switch_file ()
	fzf_pick.shell("fd --path-separator / --strip-cwd-prefix --type file", function (result)
		vim.cmd("e " .. result)
	end)
end

local function switch_folder ()
	fzf_pick.shell("fd --path-separator / --strip-cwd-prefix --type directory", function (result)
		vim.cmd("cd " .. result)
	end)
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
--
-- These are set in Vimscript using `let`, like `let mapleader=" "` and `let g:netrw_banner=0`

-- Use space as the mapleader character.
vim.g.mapleader = " "

-- Hide banner in file browser.
vim.g.netrw_banner = 0

-- Ignore case when sorting files.
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

-- Hide display of cursor position in file, normally at right edge of the status bar.
-- This can be seen by pressing Ctrl+G.
vim.opt.ruler = false

vim.opt.smartcase = true

-- Enable display of current file name in the GUI title area.
vim.opt.title = true

-- Normal-mode key-mappings
-- ========================

local function cmd (action)
	return ":" .. action .. "<cr>"
end

-- Arrow
-- -----

local function bind_normal_arrows_hjkl (h, j, k, l)
	keymap.global.normal("<down>", j)
	keymap.global.normal("<left>", h)
	keymap.global.normal("<right>", l)
	keymap.global.normal("<up>", k)
end

local function bind_normal_ctrl_arrows_hjkl (h, j, k, l)
	keymap.global.normal("<c-down>", j)
	keymap.global.normal("<c-left>", h)
	keymap.global.normal("<c-right>", l)
	keymap.global.normal("<c-up>", k)
end

local function bind_normal_shift_arrows_hjkl (h, j, k, l)
	keymap.global.normal("<s-down>", j)
	keymap.global.normal("<s-left>", h)
	keymap.global.normal("<s-right>", l)
	keymap.global.normal("<s-up>", k)
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

-- New-line
-- --------

-- Add a new line after the current one.
-- nnoremap <return> o<esc>
keymap.global.normal("<return>", function ()
	add.lines.below("")
	move.down()
end)

-- Add a new line before the current one.
-- nnoremap <s-return> O<esc>j
keymap.global.normal("<s-return>", function ()
	add.lines.above("")
end)

-- Split line.
-- nnoremap K i<cr><esc>
keymap.global.normal("<s-k>", "i<cr><esc>")

-- Sneak key-mappings
-- ------------------
--
-- `s-s` and `s` are bound to Sneak, after adding the plugin.
-- Normally `s` would be "substitute", behaving like `cl`.

-- This resets the binding for `s`.
-- nnoremap s cl
keymap.global.normal("s", "cl")

-- nmap S <Plug>Sneak_S
keymap.global.normal("<s-s>", "<plug>Sneak_S")

-- Reverse sneak with `s-s` is still possible.
-- nmap <m-s> <Plug>Sneak_s
keymap.global.normal("<m-s>", "<plug>Sneak_s")

-- Ctrl key-mappings
-- -----------------

-- nmap <C-/> <Plug>CommentaryLine
keymap.global.normal("<c-/>", "<Plug>CommentaryLine")

-- Ctrl-S to save.
-- nnoremap <silent> <c-s> :write<cr>
keymap.global.normal("<c-s>", cmd("write"))

-- Ctrl-Q to quit completely.
-- nnoremap <silent> <c-q> :quitall<cr>
keymap.global.normal("<c-q>", cmd("quitall"))

-- Leader key-mappings
-- -------------------

-- Stop highlighting matching text from the last search.
-- http://www.bestofvim.com/tip/switch-off-current-search/
keymap.global.normal_leader("/", cmd("nohlsearch"))

keymap.global.normal_leader("c", switch_folder)

-- [Set working directory to the current file](http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file)
keymap.global.normal_leader("<s-c>", cmd("cd %:p:h"))

-- Delete the current buffer.
-- Same as `:bd`.
keymap.global.normal_leader("d", cmd("bdelete"))

keymap.global.normal_leader("e", switch_file)

-- View files in folder of current buffer.
keymap.global.normal_leader("<s-e>", cmd("Explore"))

-- Toggle relative line numbers in gutter.
-- Same as `:rnu`.
keymap.global.normal_leader("i", cmd("set relativenumber!"))

-- Show last-modified time for current file.
keymap.global.normal_leader("m", cmd("echo strftime('%F %T %z', getftime(@%))"))

-- Change to next buffer.
-- Same as `:bn`.
keymap.global.normal_leader("n", cmd("bnext"))

-- Change to previous buffer.
-- Same as `:bp`.
keymap.global.normal_leader("p", cmd("bprevious"))

keymap.global.normal_leader("s", switch_buffer_2)

keymap.global.normal_leader("<s-s>", switch_buffer)

-- Show current local time.
-- From https://vim.fandom.com/wiki/Insert_current_date_or_time
keymap.global.normal_leader("t", cmd("echo strftime('%F %T %z')"))

-- Control window splits with `space w` instead of `ctrl+w`
keymap.global.normal_leader("w", "<c-w>")

-- Insert-mode key-mappings
-- ========================

-- inoremap <c-s> <esc>:write<cr>
keymap.global.insert("<c-s>", "<esc>:write<cr>")

-- Ctrl-V pastes from clipboard
-- TODO: Fix issues with smart-comments.
-- inoremap <c-v> <c-r>*
keymap.global.insert("<c-v>", "<c-r>*")

-- Visual-mode key-mappings
-- ========================

-- vmap <C-/> <Plug>Commentary
keymap.global.visual("<c-/>", "<Plug>Commentary")

-- Cannot replace <C-C> with `"+y` since it always cancels the current mode.
-- vmap <S-y> "+y
keymap.global.visual("<s-y>", '"+y')
