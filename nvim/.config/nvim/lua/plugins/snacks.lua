return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("snacks").setup({
				bufdelete = { enabled = true },
				terminal = { enabled = true },
				input = { enabled = true },
				picker = { enabled = true },
				notifier = { enabled = true, timeout = 3000 },
				dim = { enabled = true },
			})
		end
	},
}
