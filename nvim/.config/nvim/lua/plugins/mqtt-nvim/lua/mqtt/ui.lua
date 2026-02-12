local M = {}

function M.open_window(title)
	local buf = vim.api.nvim_create_buf(false, true) -- (listed = false, scratch = true)
	-- vim.api.nvim_buf_set_option(buf, "filetype", "mqttlog")
	vim.api.nvim_set_option_value("filetype", "mqttlog", { buf = buf })

	-- window size
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local opts = {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "single",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	-- add title line (optional)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { title or "MQTT Log", "" })

	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, { buffer = buf, nowait = true, silent = true })

	return win, buf
end

return M
