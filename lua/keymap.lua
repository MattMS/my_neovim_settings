M = {}

-- Buffer bindings
-- ===============

M.buffer = {}

M.buffer.insert = function (key, action)
	vim.keymap.set("i", key, action, {buffer = true})
end

M.buffer.normal = function (key, action)
	vim.keymap.set("n", key, action, {buffer = true})
end

M.buffer.visual = function (key, action)
	vim.keymap.set("v", key, action, {buffer = true})
end

-- Default bindings
-- ================

M.default = {}

M.default.insert = {}

M.default.insert.cr = function ()
	-- vim.cmd("normal o")
	vim.cmd('exe "normal! i\\<cr>"')

	-- add_new_line()
	-- move_down()
end

-- Saw that `<tab>` is normally the same as `<c-i>`
M.default.insert.tab = function ()
	-- move_to_end_of_line()
	-- TODO: Insert another tab.
end

-- Global bindings
-- ===============

M.global = {}

M.global.insert = function (key, action)
	vim.keymap.set("i", key, action)
end

M.global.normal = function (key, action)
	vim.keymap.set("n", key, action)
end

M.global.normal_leader = function (key, action)
	vim.keymap.set("n", "<leader>" .. key, action)
end

M.global.visual = function (key, action)
	vim.keymap.set("v", key, action)
end

return M
