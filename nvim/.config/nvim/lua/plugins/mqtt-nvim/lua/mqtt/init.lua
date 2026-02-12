local M = {}

local cli = require("plugins.mqtt-nvim.lua.mqtt.cli")
local ui = require("plugins.mqtt-nvim.lua.mqtt.ui")
local config = require("plugins.mqtt-nvim.lua.mqtt.config")

local current_proc = nil
local current_win = nil
local current_buf = nil

function M.setup()
	vim.api.nvim_create_user_command("MQTTSubscribe", function(args)
		local input = vim.split(args.args, " ")
		local broker, topic, port
		local win_type = "float"

		-- Extract flag and positional arguments
		local positional = {}
		for _, v in ipairs(input) do
			if v == "--window=normal" then
				win_type = "normal"
			elseif v == "--window=float" then
				win_type = "float"
			else
				table.insert(positional, v)
			end
		end

		broker = positional[1]
		topic = positional[2]
		port = positional[3]
		if not port then
			port = "1883"
		end

		if not broker or not topic then
			vim.notify("Usage: :MQTTSubscribe <broker> <port?optional> <topic> [--window=normal|float]",
				vim.log.levels.WARN)
			return
		end

		-- Close old subscription if any
		if current_proc then
			current_proc.kill(current_proc, 9)
		end
		if current_win and vim.api.nvim_win_is_valid(current_win) then
			vim.api.nvim_win_close(current_win, true)
		end

		-- Create appropriate window
		if win_type == "split" then
			current_buf = vim.api.nvim_create_buf(true, false)
			vim.cmd("split") -- or `vsplit` for vertical
			vim.api.nvim_win_set_buf(0, current_buf)
			current_win = vim.api.nvim_get_current_win()
		elseif win_type == "normal" then
			current_buf = vim.api.nvim_create_buf(true, false)
			vim.cmd("tabnew") -- or `vsplit` for vertical
			vim.api.nvim_win_set_buf(0, current_buf)
			current_win = vim.api.nvim_get_current_win()
		else
			current_win, current_buf = ui.open_window("MQTT Subscribe: " .. topic)
		end

		-- Start subscribing
		current_proc, _, _ = cli.subscribe(topic, current_win, current_buf, { json = true }, {
			broker = broker,
			port = port,
			topic = topic,
		})

		-- Floating window: allow q to close
		if win_type == "float" then
			vim.keymap.set("n", "q", function()
				if current_proc then
					current_proc.kill(current_proc, 9)
				end
				if current_win and vim.api.nvim_win_is_valid(current_win) then
					vim.api.nvim_win_close(current_win, true)
				end
			end, { buffer = current_buf, nowait = true, silent = true })
		end
	end, {
		nargs = "+",
		desc = "Subscribe to an MQTT topic.",
	})

	vim.api.nvim_create_user_command("MQTTPublish", function(args)
		local input = vim.split(args.args, " ")
		if #input < 3 then
			vim.notify("Usage: :MQTTPublish <broker> <port?optional> <topic> <message>", vim.log.levels.WARN)
			return
		end

		local broker = input[1]
		local port, topic, message_start_index

		if tonumber(input[2]) then
			port = input[2]
			topic = input[3]
			message_start_index = 4
		else
			port = "1883"
			topic = input[2]
			message_start_index = 3
		end

		local message = table.concat(input, " ", message_start_index)

		if not broker or not topic or message == " " then
			vim.notify("Usage: :MQTTPublish <broker> <port?optional> <topic> <message>", vim.log.levels.WARN)
			return
		end

		cli.publish({ broker = broker, port = port, topic = topic }, message)
		print("Publishing to topic: " .. topic)
	end, {
		nargs = "+",
		desc = "Publish to an MQTT topic."
	})

	vim.api.nvim_create_user_command("MQTTPublishFile", function(args)
		local input = vim.split(args.args, " ")
		local broker = input[1]
		local topic = input[2]
		local filepath = input[3]
		local port = input[4] or "1883"

		if not broker or not topic or not filepath then
			vim.notify("Usage: :MQTTPublishFile <broker> <port?optional> <filepath> [port]", vim.log.levels.WARN)
			return
		end

		cli.publish_file({
			broker = broker,
			topic = topic,
			filepath = filepath,
			port = port
		})
	end, {
		nargs = "+",
		desc = "Publish the contents of a file to an MQTT topic."
	})

	vim.api.nvim_create_user_command("MQTTPublishCurrentFile", function(args)
		local input = vim.split(args.args, " ")
		local broker = input[1]
		local topic = input[2]
		local port = input[4] or "1883"

		if not broker or not topic then
			vim.notify("Usage: :MQTTPublishCurrentFile <broker> <topic> [port]", vim.log.levels.WARN)
			return
		end

		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

		cli.publish_buffer({
			broker = broker,
			topic = topic,
			port = port,
			lines = lines
		})
	end, {
		nargs = "+",
		desc = "Publish the contents of the current buffer to an MQTT topic."
	})

	vim.api.nvim_create_user_command("MQTTPublishCurrentFileTelescope", function(args)
		local cfg = config.load()
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local conf = require("telescope.config").values

		local entries = {}

		for broker_name, broker in pairs(cfg.brokers or {}) do
			for _, topic in ipairs(broker.topics or {}) do
				table.insert(entries, {
					display = string.format("%s → %s → %s → %s", broker_name, broker.host, broker.port, topic),
					host = broker.host,
					port = broker.port,
					broker = broker_name,
					topic = topic,
				})
			end
		end

		if #entries == 0 then
			vim.notify("No saved topics found in brokers.", vim.log.levels.INFO)
			return
		end

		pickers.new({}, {
			prompt_title = "MQTT Topics",
			finder = finders.new_table {
				results = entries,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.display,
						ordinal = entry.display,
					}
				end,
			},
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry().value

					local command = string.format("MQTTPublishCurrentFile %s",
						selection.host ..
						" " .. selection.topic .. " " .. selection.port)
					print(command)

					vim.cmd(command)
				end)
				return true
			end,
		}):find()
	end, {
		desc = "Publish the contents of the current buffer to an MQTT topic."
	})

	vim.api.nvim_create_user_command("MQTTAddBroker", function(args)
		local input = vim.split(args.args, " ")
		local name, host, port = input[1], input[2], tonumber(input[3])
		if not name or not host or not port then
			vim.notify("Usage: :MQTTAddBroker <name> <host> <port>", vim.log.levels.WARN)
			return
		end

		local cfg = config.load()
		cfg.brokers[name] = { host = host, name = name, port = port, topics = {} }
		config.save(cfg)
	end, {
		nargs = "+",
		desc = "Add and save a named MQTT broker."
	})

	vim.api.nvim_create_user_command("MQTTGetBrokers", function(args)
		local cfg = config.load()

		local brokers = cfg.brokers
		if vim.tbl_isempty(brokers) then
			vim.notify("No saved brokers found.", vim.log.levels.INFO)
			return
		end

		local lines = { "Saved MQTT Brokers: " }

		for name, info in pairs(brokers) do
			local host = info.host or "?"
			local port = info.port or "?"
			local topics = info.topics or "?"
			local topic_line = (#topics > 0) and table.concat(topics, ", ") or "None"

			table.insert(lines, string.format(
				"• %s (%s:%s)\n    Topics: %s", name, host, port, topic_line
			))
		end
		vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
	end, {
		desc = "List all saved MQTT brokers with details."
	})

	vim.api.nvim_create_user_command("MQTTAddTopic", function(args)
		local input = vim.split(args.args, "%s+")
		local broker, topic = input[1], input[2]

		if not broker or not topic then
			vim.notify("Usage: :MQTTAddTopic <broker> <topic>", vim.log.levels.INFO)
			return
		end

		local cfg = config.load()

		if not cfg.brokers[broker] then
			vim.notify("Broker '" .. broker .. "' not found.", vim.log.levels.ERROR)
			return
		end

		local topics = cfg.brokers[broker].topics or {}
		for _, t in ipairs(topics) do
			if t == topic then
				vim.notify("Topic already exists for this broker.", vim.log.levels.WARN)
				return
			end
		end

		table.insert(topics, topic)
		cfg.brokers[broker].topics = topics
		config.save(cfg)
	end, {
		nargs = "+",
		desc = "Add topic to broker."
	})

	vim.api.nvim_create_user_command("MQTTDeleteTopic", function(args)
		local input = vim.split(args.args, " ")
		local broker, topic = input[1], input[2]

		if not broker or not topic then
			vim.notify("Usage: :MQTTDelTopic <broker> <topic>", vim.log.levels.WARN)
			return
		end

		local cfg = config.load()

		local b = cfg.brokers[broker]
		if not b then
			vim.notify("Broker '" .. broker .. "' not found.", vim.log.levels.ERROR)
			return
		end

		local topics = b.topics or {}
		local new_topics = {}

		local found = false
		for _, t in ipairs(topics) do
			if t ~= topic then
				table.insert(new_topics, t)
			else
				found = true
			end
		end

		if not found then
			vim.notify("Topic not found for broker '" .. broker .. "'.", vim.log.levels.WARN)
			return
		end

		b.topics = new_topics
		config.save(cfg)

		vim.notify("Removed topic '" .. topic .. "' from broker '" .. broker .. "'.", vim.log.levels.INFO)
	end, {
		nargs = "+",
		desc = "Delete a topic from a saved broker",
	})

	vim.api.nvim_create_user_command("MQTTSearchTopics", function()
		local cfg = config.load()
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local conf = require("telescope.config").values

		local entries = {}

		for broker_name, broker in pairs(cfg.brokers or {}) do
			for _, topic in ipairs(broker.topics or {}) do
				table.insert(entries, {
					display = string.format("%s → %s → %s → %s", broker_name, broker.host, broker.port, topic),
					host = broker.host,
					port = broker.port,
					broker = broker_name,
					topic = topic,
				})
			end
		end

		if #entries == 0 then
			vim.notify("No saved topics found in brokers.", vim.log.levels.INFO)
			return
		end

		pickers.new({}, {
			prompt_title = "MQTT Topics",
			finder = finders.new_table {
				results = entries,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.display,
						ordinal = entry.display,
					}
				end,
			},
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry().value

					local command = string.format("MQTTSubscribe %s",
						selection.host .. " " .. selection.topic .. " " .. selection.port .. " --window=normal")
					vim.cmd(command)
				end)
				return true
			end,
		}):find()
	end, {
		desc = "Search for a topic across brokers and subscribe",
	})
end

return M
