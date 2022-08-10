local fzf = require("fzf")

-- Helpers
-- =======

local function prepend_on_all (suffix, lines)
	return vim.fn.map(lines, '"' .. suffix .. '" .. v:val')
end

-- Current line
-- ------------

local function current_line_column ()
	return vim.api.nvim_win_get_cursor(0)[2]
end

-- Return the matched content based on the current line, or empty string on no match.
local function current_line_match (pattern)
	local line = vim.api.nvim_get_current_line()
	-- Cannot use `line:match(pattern)`, since Lua pattern matching is different to regex.
	local start, stop = vim.regex(pattern):match_str(line)
	if start and stop then
		return string.sub(line, start, stop)
	else
		return ""
	end
end

local function current_line_indent ()
	return current_line_match("^\\s\\+")
end

-- Return true if the current line matches the given pattern.
local function current_line_matches (pattern)
	return vim.regex(pattern):match_str(vim.api.nvim_get_current_line()) ~= nil
end

local function current_line_number ()
	-- Get line number in Vimscript: `line(".")`
	return vim.api.nvim_win_get_cursor(0)[1]
end

local function current_line_size ()
	-- Get line content in Vimscript: `getline(".")`
	return #vim.api.nvim_get_current_line()
end

-- Current word
-- ------------

local function current_word_matches (pattern)
	return current_line_matches(pattern)
end

-- Navigation
-- ==========

-- Move cursor
-- -----------

local function move_down ()
	vim.cmd("call cursor(line('.') + 1, 0)")
end

local function move_left ()
	vim.cmd("call cursor(0, col('.') - 1)")
end

local function move_right ()
	vim.cmd("call cursor(0, col('.') + 1)")
end

local function move_to_end_of_line ()
	vim.cmd("call cursor(0, col('$'))")
end

local function move_up ()
	vim.cmd("call cursor(line('.') - 1, 0)")
end

-- Editing
-- =======

-- Insert
-- ------

-- Adds the given text above the current line.
local function add_lines_above (text)
	vim.fn.append(vim.fn.line('.') - 1, text)
end

-- Adds the given text below the current line.
local function add_lines_below (text)
	-- Using `current_line_number()` will fail when it is in a different window (like fzf)
	vim.fn.append(vim.fn.line('.'), text)
end

-- Data
-- ====

local snippet_keys = {}
local snippet_values = {}
-- Could also use `vim.env.HOME`
local lines = vim.fn.readfile(vim.fn.glob("~/act.ini"))
for i, line in pairs(lines) do
	local k, v = string.match(line, "^([^=]+)=(.*)$")
	table.insert(snippet_keys, k)
	snippet_values[k] = v
end

-- Actions
-- =======

local function add_new_line ()
	add_lines_above("")
end

-- Vimscript: inoremap <tab> <esc>:s/^\(\s\+\)\([^ ]\+\) "\(.*\)"$/\1\2 <<END\r\1\3\r\1END/<cr>:nohlsearch<cr><up>A
local function expand_quote (default)
	return function ()
		if current_line_matches("^\\s*[^ ]\\+ \".*\"$") then
			vim.cmd('s/^\\(\\s*\\)\\([^ ]\\+\\) "\\(.*\\)"$/\\1\\2 <<END\\r\\1\\3\\r\\1END/')
			vim.cmd('nohlsearch')
			move_up()
			move_to_end_of_line()
		else
			default()
		end
	end
end

-- If on a number, set it to the current time.
local function fix_time (default)
	return function ()
		if default and (not current_word_matches("\\d{4}")) then
			default()
		else
			-- TODO: Replace word at cursor with current time.
		end
	end
end

local function insert_snippet (with_block, default)
	return function ()
		if default and current_line_matches("^\\s*$") then
			default()
		else
			-- TODO: If "~/act.ini" does not exist, then show a warning explaining how to create the file.
			local indent = current_line_match("^\\s\\+")
			coroutine.wrap(function ()
				local result = fzf.fzf(snippet_keys, "--reverse", {
					border = true,
					col = 0,
					height = 8,
					relative = "cursor",
					row = 1,
					width = 32,
					window_on_create = function ()
						-- Sets the background to the same as the normal window.
						vim.cmd("set winhl=Normal:Normal")
					end
				})
				if result then
					if with_block then
						local lines = {'(', ')'}
						add_lines_below(prepend_on_all(indent, lines))
						indent = indent .. '\t'
						move_down()
						move_down()
					end
					add_lines_above(indent .. snippet_values[result[1]])
					move_up()
					move_to_end_of_line()
					move_left()
				end
			end)()
		end
	end
end

-- Original Vimscript: inoremap <M-s> start <C-R>=strftime("%H%M")<cr><cr>stop <C-R>=strftime("%H%M")<cr><up><end><esc>
-- Time was from https://vim.fandom.com/wiki/Insert_current_date_or_time
local function insert_time_block ()
	local indent = current_line_indent()
	local time = vim.fn.strftime("%H%M")
	local lines = {'(', '\tstart ' .. time, '\tstop ' .. time, ')'}
	add_lines_below(prepend_on_all(indent, lines))
	move_down()
	move_down()
	move_to_end_of_line()
end

local function insert_writing_time_block ()
	insert_time_block()

	local indent = current_line_indent()
	local lines = {'act writing', 'my times'}
	add_lines_above(prepend_on_all(indent, lines))
end

-- Key bindings
-- ============

local function default_insert_cr ()
	-- vim.cmd("normal o")
	vim.cmd('exe "normal! i\\<cr>"')

	-- add_new_line()
	-- move_down()
end

-- Saw that `<tab>` is normally the same as `<c-i>`
local function default_insert_tab ()
	-- move_to_end_of_line()
	-- TODO: Insert another tab.
end

-- vim.keymap.set("i", "<cr>", expand_quote(default_insert_cr), {buffer = true})
vim.keymap.set("i", "<tab>", expand_quote(default_insert_tab), {buffer = true})

vim.keymap.set("n", "<m-a>", insert_snippet(false), {buffer = true})
vim.keymap.set("n", "<m-s-a>", insert_snippet(true), {buffer = true})
vim.keymap.set("n", "<m-s>", insert_time_block, {buffer = true})
vim.keymap.set("n", "<m-w>", insert_writing_time_block, {buffer = true})

-- vim.keymap.set("n", "<c-.>", fix_time(), {buffer = true}) -- Replace the time at the cursor with the current time.
-- vim.keymap.set("n", "<c-s-.>", set_to_last_time(), {buffer = true}) -- Find the last time (before the current line) and replace the time at the cursor with that.
