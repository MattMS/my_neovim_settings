-- Uses `v` along with `.` so it works in Visual and other modes.
--
-- Using `current_line_number()` will fail when it is in a different window (like fzf)

M = {}

M.lines = {}

-- TODO: Fix when `v` is below `.`
local function get_start_line ()
	return math.min(vim.fn.line('.'), vim.fn.line('v') - 1)
end

local function get_stop_line ()
	return math.max(vim.fn.line('.'), vim.fn.line('v') - 1)
end

-- Adds the given text above the current line.
M.lines.above = function (text)
	vim.fn.append(get_start_line(), text)
end

-- Adds the given text below the current line.
M.lines.below = function (text)
	vim.fn.append(get_stop_line(), text)
end

M.prefix = function (prefix, lines)
	return vim.fn.map(lines, '"' .. prefix .. '" .. v:val')
end

return M
