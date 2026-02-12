return {
	'nvim-telescope/telescope.nvim',
	-- tag = '0.1.8',
	dependencies = {
		'nvim-lua/plenary.nvim',
		"neovim/nvim-lspconfig",
	},
	config = function()
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files,
			{ desc = 'Telescope find files' })
		vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Telescope live grep' })
		vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
		vim.keymap.set("n", "<leader>fc", function()
			local config_path = vim.fn.stdpath("config")

			builtin.find_files({
				cwd = config_path,
				attach_mappings = function(_, map)
					local actions = require("telescope.actions")
					local action_state = require("telescope.actions.state")

					-- When a file is selected
					map("i", "<CR>", function(prompt_bufnr)
						local entry = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						-- Change Neovim's cwd to the config directory
						vim.cmd.cd(config_path)
						-- Open the selected file
						vim.cmd.edit(entry.path)
					end)

					map("n", "<CR>", function(prompt_bufnr)
						local entry = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						vim.cmd.cd(config_path)
						vim.cmd.edit(entry.path)
					end)

					return true
				end,
			})
		end, { desc = "Find and open config file (sets cwd to config)" })
		require("telescope").setup({
			defaults = {
				color_devicons = true,
				sorting_strategy = "descending",
				borderchars = { "", "", "", "", "", "", "", "" },
				path_displays = "smart",
				layout_strategy = "horizontal",
				layout_config = {
					height = 100,
					width = 400,
					prompt_position = "bottom",
					preview_cutoff = 40,
				}
			}
			-- defaults = {
			-- 	layout_config = {
			-- 		vertical = {
			-- 			width = 0.95,
			-- 			height = 0.95,
			-- 		},
			-- 	},
			-- 	layout_strategy = "vertical"
			-- },
		})
	end
}
