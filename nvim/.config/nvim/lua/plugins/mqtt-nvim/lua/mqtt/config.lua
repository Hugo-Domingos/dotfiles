local M = {}

local json = vim.fn.json_decode
local encode = vim.fn.json_encode

local config_path = vim.fn.stdpath("config") .. "/mqtt_config.json"

local default_config = { brokers = {} }

function M.load()
	local f = io.open(config_path, "r")
	if not f then return default_config end
	local content = f:read("*a")
	f:close()
	local ok, data = pcall(json, content)
	return ok and data or default_config
end

function M.save(data)
	local encoded = encode(data)
	local f = io.open(config_path, "w")
	if not f then return false end
	f:write(encoded)
	f:close()
	return true
end

return M
