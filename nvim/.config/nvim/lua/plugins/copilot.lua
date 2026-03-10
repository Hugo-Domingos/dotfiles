return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<C-a>",
					accept_word = "<C-Right>",
					accept_line = "<C-Left>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			panel = {
				enabled = true,
			},
			filetypes = {
				markdown = true,
				yaml = true,
			},
		})
	end,
}
