local M = {}

M.last_insert_layout = 0

local function get_cmd_output(cmd)
	local handle = io.popen(cmd)
	if handle then
		local result = handle:read("*a")
		handle:close()
		return result:gsub("\n", "")
	end
	return ""
end

-- switch layout
local function switch_layout(id)
	os.execute("hyprctl switchxkblayout active " .. id)
end

function M.on_leave_insert()
	local layout = get_cmd_output("hyprctl devices -j | jq '.keyboards[0].active_layout_index'")
	if layout ~= "" then
		M.last_insert_layout = tonumber(layout)
	end
	switch_layout(0)
end

function M.on_enter_insert()
	switch_layout(M.last_insert_layout)
end

function M.setup()
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = M.on_leave_insert,
	})
	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = M.on_enter_insert,
	})
end

return M
