return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	keys = {
		{ "<C-h>", "<Cmd>TmuxNavigateLeft<CR>",  desc = "Navigate left (tmux/nvim)" },
		{ "<C-j>", "<Cmd>TmuxNavigateDown<CR>",  desc = "Navigate down (tmux/nvim)" },
		{ "<C-k>", "<Cmd>TmuxNavigateUp<CR>",    desc = "Navigate up (tmux/nvim)" },
		{ "<C-l>", "<Cmd>TmuxNavigateRight<CR>", desc = "Navigate right (tmux/nvim)" },
	},
}
