return {

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = {
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true,
				integrations = {
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = "italic",
							hints = "italic",
							warnings = "italic",
							information = "italic",
						},
						underlines = {
							errors = "underline",
							hints = "underline",
							warnings = "underline",
							information = "underline",
						},
					},
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},


	-- {
	-- 	"sainnhe/gruvbox-material",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.gruvbox_material_transparent_background = "1"
	-- 		vim.g.gruvbox_material_enable_italic = "1"
	-- 		vim.g.gruvbox_material_style = "original"
	-- 		vim.cmd.colorscheme("gruvbox-material")
	-- 	end,
	-- },

	-- {
	-- 	"rose-pine/neovim",
	-- 	name = "rose-pine",
	-- 	config = function()
	-- 		require("rose-pine").setup({
	-- 			styles = {
	-- 				transparency = true,
	-- 			},
	-- 		})
	-- 		vim.cmd("colorscheme rose-pine")
	-- 	end,
	-- },

	-- {
	-- 	"vague2k/vague.nvim",
	-- 	name = "vague",
	-- 	config = function()
	-- 		-- NOTE: you do not need to call setup if you don't want to.
	-- 		require("vague").setup({
	-- 			-- optional configuration here
	-- 			transparent = true, -- Enable transparent background
	-- 		})
	-- 		vim.cmd.colorscheme("vague")
	-- 	end,
	-- },

	-- {
	-- 	"webhooked/kanso.nvim",
	-- 	name = "kanso",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("kanso").setup({
	-- 			transparent = true, -- Enable transparent background
	-- 		})
	-- 		vim.cmd.colorscheme("kanso-zen")
	-- 	end,
	-- },


	-- {
	-- 	"frenzyexists/aquarium-vim",
	-- 	name = "aquarium",
	-- 	config = function()
	-- 		vim.g.aqua_transparency = 1
	-- 		vim.g.aqua_bold = 1
	-- 		vim.cmd.colorscheme("aquarium")
	-- 		-- make completion popup fit Aquarium style
	-- 		vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1b1d28", fg = "#c0caf5" }) -- popup background
	-- 		vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#334155", fg = "#ffffff" }) -- selected item
	-- 		vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#1b1d28" })            -- scrollbar bg
	-- 		vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#4a5568" })           -- scrollbar thumb
	-- 		vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#c0caf5" })          -- normal text
	-- 		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#7aa2f7", bold = true }) -- matched text
	-- 		vim.api.nvim_set_hl(0, "CmpItemKind", { fg = "#9ece6a" })          -- icon/kind
	-- 		-- make main background transparent
	-- 		vim.api.nvim_set_hl(0, "Whitespace", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "MsgArea", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" })
	-- 	end,
	-- },

	-- {
	-- 	"cdmill/neomodern.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("neomodern").setup({
	-- 			theme = "hojicha",
	-- 			transparent = true,
	-- 		})
	-- 		require("neomodern").load()
	-- 	end,
	-- },

	-- {
	-- 	"gmr458/cold.nvim",
	-- 	lazy = false, -- Load during startup
	-- 	priority = 1000, -- Load before other plugins
	-- 	config = function()
	-- 		vim.api.nvim_create_autocmd("ColorScheme", {
	-- 			pattern = "cold",
	-- 			callback = function()
	-- 				local highlights = {
	-- 					"Normal",
	-- 					"NormalNC",
	-- 					"SignColumn",
	-- 					"StatusLine",
	-- 					"StatusLineNC",
	-- 					"EndOfBuffer",
	-- 					"MsgArea",
	-- 					"Folded",
	-- 					"FoldColumn",
	-- 					"WinBar",
	-- 					"WinBarNC",
	-- 					"FloatBorder",
	-- 					"NormalFloat", -- Makes popups/telescope transparent too
	-- 					"Whitespace",
	-- 					"LineNr",
	-- 					"CursorLine",
	-- 					"CursorLineNr",
	-- 					"TabLine",
	-- 					"TabLineFill",
	-- 				}
	-- 				for _, group in ipairs(highlights) do
	-- 					vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
	-- 				end
	-- 			end,
	-- 		})
	-- 		vim.cmd("colorscheme cold")
	-- 	end,
	-- }


}
