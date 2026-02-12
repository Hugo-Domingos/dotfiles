return {
	dir = "~/.config/nvim/lua/plugins/mqtt-nvim", -- path to your local plugin
	name = "mqtt.nvim",                        -- optional, to avoid inferred names
	config = function()
		require("mqtt").setup()
	end,
}
