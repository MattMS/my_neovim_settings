M = {}

-- Line
-- ====

M.line = {}

M.line.column = function ()
	return vim.api.nvim_win_get_cursor(0)[2]
end

-- Return the matched content based on the current line, or empty string on no match.
local function line_match (pattern)
	local line = vim.api.nvim_get_current_line()
	-- Cannot use `line:match(pattern)`, since Lua pattern matching is different to regex.
	local start, stop = vim.regex(pattern):match_str(line)
	if start and stop then
		return string.sub(line, start, stop)
	else
		return ""
	end
end
M.line.match = line_match

M.line.indent = function ()
	-- Cannot seem to use `M.line.match("^\\s\\+")`, as it says `line` is `nil`.
	return line_match("^\\s\\+")
end

-- Return true if the current line matches the given pattern.
local function line_matches (pattern)
	return vim.regex(pattern):match_str(vim.api.nvim_get_current_line()) ~= nil
end
M.line.matches = line_matches

M.line.number = function ()
	-- Get line number in Vimscript: `line(".")`
	return vim.api.nvim_win_get_cursor(0)[1]
end

M.line.size = function ()
	-- Get line content in Vimscript: `getline(".")`
	return #vim.api.nvim_get_current_line()
end

-- Word
-- ----

M.word = {}

M.word.matches = function (pattern)
	-- TODO: Implement this properly.
	return line_matches(pattern)
end

return M
