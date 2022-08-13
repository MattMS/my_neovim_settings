M = {}

M.down = function ()
	vim.cmd("call cursor(line('.') + 1, 0)")
end

M.left = function ()
	vim.cmd("call cursor(0, col('.') - 1)")
end

M.right = function ()
	vim.cmd("call cursor(0, col('.') + 1)")
end

M.up = function ()
	vim.cmd("call cursor(line('.') - 1, 0)")
end

M.to = {}

-- This behaves differently in Insert and Normal mode.
-- Insert-mode (like `A`) is `col($)`.
-- Normal-mode (like `$`) is `col($) - 1`.
M.to.end_of_line = function ()
	vim.cmd("call cursor(0, col('$'))")
end

return M
