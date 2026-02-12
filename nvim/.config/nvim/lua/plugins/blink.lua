return {
	{
		'saghen/blink.cmp',
		dependencies = { 'rafamadriz/friendly-snippets' },
		version = '1.*',
		opts = {
			keymap = { preset = "enter" },
			sources = {
				providers = {
					lsp = {
						module = 'blink.cmp.sources.lsp',
						fallbacks = { 'buffer' },
					},
					path = {
						module = 'blink.cmp.sources.path',
						score_offset = -3,
						fallbacks = { 'buffer' },
					},
					buffer = {
						module = 'blink.cmp.sources.buffer',
						score_offset = -3,
						opts = {
							get_bufnrs = function()
								return vim.iter(vim.api.nvim_list_wins())
									:map(function(win) return vim.api.nvim_win_get_buf(win) end)
									:filter(function(buf) return vim.bo[buf].buftype ~= 'nofile' end)
									:totable()
							end,
							-- 👇 THIS enables buffer completion inside :s
							enable_in_ex_commands = true,
						}
					},
				},
				default = { "lsp", "path", "buffer" },
			},

			completion = {
				documentation = {
					window = {
						border = "none",
						winblend = 15,
					},
				},
				menu = {
					draw = { treesitter = { "lsp" } },
					border = "none",
					winblend = 15,
				},
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = 'mono',
			},
			cmdline = {
				keymap = { preset = "super-tab" },
				completion = {
					menu = {
						auto_show = true
					}
				}
			},
		},
	}
}
