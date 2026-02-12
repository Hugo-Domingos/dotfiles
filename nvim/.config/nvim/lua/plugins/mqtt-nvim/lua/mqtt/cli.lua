local should_scroll = true

local M = {}

local function setup_scroll_controls(buf, win)
	vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = buf,
		callback = function()
			local curr_line = vim.api.nvim_win_get_cursor(win)[1]
			local last_line = vim.api.nvim_buf_line_count(buf)
			if curr_line < last_line then
				should_scroll = false
			end
		end
	})

	vim.keymap.set("n", "G", function()
		should_scroll = true
		local last_line = vim.api.nvim_buf_line_count(buf)
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_set_cursor(win, { last_line, 0 })
		end
	end, { buffer = buf, nowait = true, silent = true })
end

local function try_pretty_json(line)
	local ok, decoded = pcall(vim.json.decode, line)
	if not ok then
		return { line }
	end
	local pretty = vim.split(vim.inspect(decoded), "\n")
	return pretty
end

function M.subscribe(topic, win, buf, opts, config)
	opts = opts or {}
	local cmd = { "mqtt", "sub", "-t", topic, "-h", config.broker, "-p", config.port }

	if opts.json then
		table.insert(cmd, "-J")
	end

	setup_scroll_controls(buf, win)

	local proc = vim.system(cmd, {
		stdout = function(_, data)
			if data then
				vim.schedule(function()
					local lines = vim.split(data, "\n", { trimempty = true })
					for _, line in ipairs(lines) do
						local display_lines = opts.json and try_pretty_json(line) or { line }
						vim.api.nvim_buf_set_lines(buf, -1, -1, false, display_lines)
						-- vim.api.nvim_buf_set_option(buf, "filetype", "json")
						vim.api.nvim_set_option_value("filetype", "json", { buf = buf })
					end

					-- vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(data, "\n"))
					local line_count = vim.api.nvim_buf_line_count(buf)
					if should_scroll and vim.api.nvim_win_is_valid(win) then
						vim.api.nvim_win_set_cursor(win, { line_count, 0 })
						-- vim.api.nvim_buf_set_option(buf, "filetype", "json")
						vim.api.nvim_set_option_value("filetype", "json", { buf = buf })
					end
				end)
			end
		end,
		stderr = function(_, data)
			if data then
				vim.schedule(function()
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split("[stderr] " .. data, "\n"))
					local line_count = vim.api.nvim_buf_line_count(buf)
					if should_scroll and vim.api.nvim_win_is_valid(win) then
						vim.api.nvim_win_set_cursor(win, { line_count, 0 })
					end
				end)
			end
		end,
	})

	return proc, win, buf
end

function M.publish(config, message)
	local cmd = {
		"mqtt", "pub",
		"-t", config.topic,
		"-m", message,
		"-h", config.broker,
		"-p", config.port
	}

	local proc = vim.system(cmd, {
		stdout = function(_, data)
			if data then
				vim.schedule(function()
					vim.notify("MQTT publish success:\n" .. data, vim.log.levels.INFO)
				end)
			end
		end,
		stderr = function(_, data)
			if data then
				vim.schedule(function()
					vim.notify("MQTT publish error:\n" .. data, vim.log.levels.ERROR)
				end)
			end
		end,
	})
end

function M.publish_file(opts)
	local broker = opts.broker
	local topic = opts.topic
	local port = opts.port or "1883"
	local filepath = opts.filepath

	local file = io.open(filepath, "r")
	if not file then
		vim.notify("Failed to open file: " .. filepath, vim.log.levels.ERROR)
		return
	end

	local content = file:read("*a")
	file:close()

	if content == "" then
		vim.notify("File is empty" .. filepath, vim.log.levels.WARN)
		return
	end

	local cmd = {
		"mqtt", "pub",
		"-t", topic,
		"-m", content,
		"-h", broker,
		"-p", port
	}

	local proc = vim.system(cmd, {
		stdout = function(_, data)
			if data then
				vim.schedule(function()
					vim.notify("MQTT publish success:\n" .. data, vim.log.levels.INFO)
				end)
			end
		end,
		stderr = function(_, data)
			if data then
				vim.schedule(function()
					vim.notify("MQTT publish error:\n" .. data, vim.log.levels.ERROR)
				end)
			end
		end,
	})
end

function M.publish_buffer(opts)
	local broker = opts.broker
	local topic = opts.topic
	local port = opts.port or "1883"
	local lines = opts.lines

	if not lines or #lines == 0 then
		vim.notify("Buffer is empty", vim.log.levels.WARN)
		return
	end

	local content = table.concat(lines, "\n")

	local cmd = {
		"mqtt", "pub",
		"-t", topic,
		"-m", content,
		"-h", broker,
		"-p", port
	}

	local proc = vim.system(cmd, {
		stdout = function(_, data)
			if data then
				vim.schedule(function()
					vim.notify("MQTT publish success:\n" .. data, vim.log.levels.INFO)
				end)
			end
		end,
		stderr = function(_, data)
			if data then
				vim.schedule(function()
					vim.notify("MQTT publish error:\n" .. data, vim.log.levels.ERROR)
				end)
			end
		end,
	})
end

return M
