M = {}

M.lines = {}

-- Adds the given text above the current line.
M.lines.above = function (text)
	-- Uses `v` instead of `.` so it works in Visual and other modes.
	vim.fn.append(vim.fn.line('v') - 1, text)
end

-- Adds the given text below the current line.
M.lines.below = function (text)
	-- Using `current_line_number()` will fail when it is in a different window (like fzf)
	vim.fn.append(vim.fn.line('.'), text)
end

M.prefix = function (prefix, lines)
	return vim.fn.map(lines, '"' .. prefix .. '" .. v:val')
end

return M
