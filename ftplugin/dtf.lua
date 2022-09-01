-- My modules
local add = require "add"
local current = require "current"
local fzf_pick = require "fzf_pick"
local keymap = require "keymap"
local move = require "move"

local ABOVE = -1
local BELOW = 1

local WITH_BLOCK = true
local WITHOUT_BLOCK = false

-- Options
-- =======

-- See https://vim.fandom.com/wiki/Folding
vim.opt_local.foldmethod = "syntax"

vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

-- Helpers
-- =======

-- Inspiration: https://docs.microsoft.com/en-au/dotnet/api/system.string.split?view=net-6.0
local function string_split (sep)
	return function (text)
	end
end

local function substitute (pattern, action)
	-- Using `\v` to simplify brackets and plus.
	vim.cmd("s/\\v" .. pattern .. "/" .. action)
	vim.cmd('nohlsearch')
end

-- Data
-- ====

local function read_flat_ini (file_name)
	local keys = {}
	local values = {}
	local lines = vim.fn.readfile(vim.fn.glob(file_name))
	for i, line in pairs(lines) do
		local k, v = string.match(line, "^([^=]+)=(.*)$")
		table.insert(keys, k)
		values[k] = v
	end
	return keys, values
end

-- Could also use `vim.env.HOME`
local snippet_keys, snippet_values = read_flat_ini("~/act.ini")
local tags = read_flat_ini("~/tag.ini")

-- Actions
-- =======

-- In `note ""`, it should expand to `note <<END\nEND`.
-- In `()`, it should expand to `(\n\t\n)`
--
-- Original Vimscript: inoremap <tab> <esc>:s/^\(\s\+\)\([^ ]\+\) "\(.*\)"$/\1\2 <<END\r\1\3\r\1END/<cr>:nohlsearch<cr><up>A
--
local function expand_line (default)
	return function ()
		if current.line.matches [[^\s*[^ ]\+ ".*"$]] then
			substitute([[^(\s*)([^ ]+) "(.*)"$]], [[\1\2 <<END\r\1\3\r\1END]])
			move.up()
			move.to.end_of_line()
		else
			default()
		end
	end
end

local function fix_line ()
	if current.line.matches [[\v^\t+[^ ]+ .+$]] then
		substitute([[^(\t+)([^ ]+) (.*)$]], [[\1\2 (\r\1\t\3\r\1)]])
		move.up()
		move.to.end_of_line()
	end
end

-- If on a number, set it to the current time.
local function fix_time (default)
	return function ()
		if default and (not current.word.matches("\\d{4}")) then
			default()
		else
			-- TODO: Replace word at cursor with current time.
		end
	end
end

local function insert_snippet (with_block, default)
	return function ()
		if default and current.line.matches("^\\s*$") then
			default()
		else
			-- TODO: If "~/act.ini" does not exist, then show a warning explaining how to create the file.
			local indent = current.line.indent()
			fzf_pick.at_cursor_with_lookup(snippet_keys, snippet_values, function (result)
				if with_block then
					local lines = {'(', ')'}
					add.lines.below(add.prefix(indent, lines))
					indent = indent .. '\t'
					move.down()
					move.down()
				end
				add.lines.above(indent .. result)
				move.up()
				move.to.end_of_line()
				move.left() -- Need to do this or the cursor is beyond the end.
			end)
		end
	end
end

-- Original Vimscript: inoremap <M-s> start <C-R>=strftime("%H%M")<cr><cr>stop <C-R>=strftime("%H%M")<cr><up><end><esc>
-- Time was from https://vim.fandom.com/wiki/Insert_current_date_or_time
local function insert_time_block (with_block)
	return function ()
		local indent = current.line.indent()
		local time = vim.fn.strftime("%H%M")
		local lines = {}
		if with_block then
			lines = {'(', '\tstart ' .. time, '\tstop ' .. time, ')'}
		else
			lines = {'start ' .. time, 'stop ' .. time}
		end
		add.lines.below(add.prefix(indent, lines))
		if with_block then
			move.down()
			move.down()
		else
			vim.cmd("normal J")
		end
		move.to.end_of_line()
	end
end

-- Original Vimscript: imap <M-w> (act writing<cr>my times<cr><M-s><esc>
-- This made use of my `insert_time_block` code with `<m-s>`.
local function insert_writing_time_block ()
	insert_time_block(WITH_BLOCK)()

	local indent = current.line.indent()
	local lines = {'act write', 'my times'}
	add.lines.above(add.prefix(indent, lines))
end

local function wrap_selection_in_block ()
	local indent = current.line.indent()
	add.lines.above(indent .. '(')
	add.lines.below(indent .. ')')
	-- `o` in visual mode will switch to the other end of the selection.
	vim.cmd("normal ojo>>")
end

-- Key bindings
-- ============

-- keymap.buffer.insert("<cr>", expand_line(keymap.default.insert.cr))
keymap.buffer.insert("<tab>", expand_line(keymap.default.insert.tab))
keymap.buffer.insert("<m-s>", insert_time_block(WITHOUT_BLOCK))

keymap.buffer.normal("<tab>", fix_line)
keymap.buffer.normal("<m-a>", insert_snippet(WITHOUT_BLOCK))
keymap.buffer.normal("<m-s-a>", insert_snippet(WITH_BLOCK))
-- keymap.buffer.normal("<m-j>", insert_tag(WITHOUT_BLOCK))
-- keymap.buffer.normal("<m-n>", insert_note(BELOW))
-- keymap.buffer.normal("<m-s-n>", insert_note(ABOVE))
keymap.buffer.normal("<m-s>", insert_time_block(WITH_BLOCK))
keymap.buffer.normal("<m-w>", insert_writing_time_block)
-- keymap.buffer.normal("<m-x>", pick_command_with_fzf)

-- keymap.buffer.normal("<c-.>", fix_time()) -- Replace the time at the cursor with the current time.
-- keymap.buffer.normal("<c-s-.>", set_to_last_time()) -- Find the last time (before the current line) and replace the time at the cursor with that.

keymap.buffer.visual("<tab>", wrap_selection_in_block)
