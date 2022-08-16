local fzf = require "fzf"

local function fix_background ()
	-- Sets the background to the same as the normal window.
	vim.cmd "set winhl=Normal:Normal"
end

local at_cursor_args = "--reverse"
local at_cursor_options = {
	border = true,
	col = 0,
	height = 8,
	relative = "cursor",
	row = 1,
	width = 32,
	window_on_create = fix_background
}

local full_args = ""
local full_options = {
	border = true,
	window_on_create = fix_background
}

local function create_picker (args, options)
	return function (contents, callback)
		coroutine.wrap(function ()
			local result = fzf.fzf(contents, args, options)
			if result then
				callback(result[1])
			end
		end)()
	end
end

M = {}

M.at_cursor = create_picker(at_cursor_args, at_cursor_options)

M.at_cursor_with_lookup = function (display_items, lookup, callback)
	create_picker(at_cursor_args, at_cursor_options)(display_items, function (picked)
		callback(lookup[picked])
	end)
end

M.full = create_picker(full_args, full_options)

M.full_with_lookup = function (display_items, lookup, callback)
	create_picker(full_args, full_options)(display_items, function (picked)
		callback(lookup[picked])
	end)
end

M.shell = create_picker("", full_options)

return M
