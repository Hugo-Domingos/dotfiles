return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- "hrsh7th/cmp-nvim-lsp",
		"saghen/blink.cmp",
		{ "antosha417/nvim-lsp-file-operations", onfig = true },
		-- { "folke/neodev.nvim",                   opts = {} },
		{
			"folke/lazydev.nvim",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local keymap = vim.keymap -- for conciseness

		-- -- Telescope
		local function lsp_references_with_context()
			local builtin = require("telescope.builtin")
			local entry_display = require("telescope.pickers.entry_display")
			local utils = require("telescope.utils")
			local lsp = vim.lsp

			-- Cache document symbols per file so we don’t spam LSP
			local symbol_cache = {}

			-- Find nearest enclosing function/class for a line
			local function get_symbol_context(bufnr, lnum)
				if not symbol_cache[bufnr] then
					local params = { textDocument = lsp.util.make_text_document_params(bufnr) }
					local result = lsp.buf_request_sync(bufnr, "textDocument/documentSymbol", params, 1000)
					symbol_cache[bufnr] = result
				end

				local symbols = {}
				local results = symbol_cache[bufnr]
				if not results then
					return ""
				end

				for _, res in pairs(results) do
					if res.result then
						local function collect(symbols_list, parent)
							for _, sym in ipairs(symbols_list) do
								local range = sym.range or (sym.location and sym.location.range)
								if range then
									if lnum >= range.start.line and lnum <= range["end"].line then
										local name = sym.name
										if parent then
											name = parent .. "->" .. name
										end
										table.insert(symbols, name)
										if sym.children then
											collect(sym.children, name)
										end
									end
								end
							end
						end
						collect(res.result, nil)
					end
				end

				return symbols[#symbols] or "" -- return innermost symbol
			end

			builtin.lsp_references({
				entry_maker = function(entry)
					-- Extract URI
					local uri = entry.uri
						or entry.targetUri
						or (entry.user_data and entry.user_data.uri)
					if not uri then
						return nil
					end

					local filename = entry.filename or vim.uri_to_fname(uri)
					local bufnr = vim.uri_to_bufnr(uri)

					-- Extract range
					local range = entry.range
						or entry.targetSelectionRange
						or entry.targetRange
						or (entry.user_data and entry.user_data.range)
					if not range then
						return nil
					end

					local start = range.start
					local lnum = start.line + 1
					local col = start.character + 1

					-- Fetch code line
					local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, lnum - 1, lnum, false)
					local line = (ok and lines[1]) and lines[1] or ""
					line = line:gsub("^%s*", "")

					-- Fetch context
					local context = get_symbol_context(bufnr, lnum - 1)
					if context ~= "" then
						context = "[" .. context .. "] "
					end

					local displayer = entry_display.create({
						separator = " │ ",
						items = {
							{ width = 50 }, -- context + filename:line
							{ remaining = true }, -- code line
						},
					})

					local function make_display()
						return displayer({
							context .. utils.path_tail(filename) .. ":" .. lnum,
							line,
						})
					end

					return {
						valid = true,
						value = entry,
						ordinal = filename .. " " .. line,
						display = make_display,
						filename = filename,
						lnum = lnum,
						col = col,
						text = line,
					}
				end,
			})
		end
		-- --





		-- Helper to check if any client supports a given method
		local function has(bufnr, method)
			if type(method) == "table" then
				for _, m in ipairs(method) do
					if has(bufnr, m) then
						return true
					end
				end
				return false
			end

			method = method:find("/") and method or ("textDocument/" .. method)

			for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
				if client.supports_method and client.supports_method(method) then
					return true
				end
			end
			return false
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See :help vim.lsp.* for documentation on any of the below functions
				local bufnr = ev.buf
				local opts = { buffer = bufnr, silent = true }

				local tel = require("telescope.builtin")

				keymap.set("n", "<leader>cl", function() Snacks.picker.lsp_config() end, { desc = "Lsp Info" })
				if has(bufnr, "definition") then
					keymap.set("n", "gd", tel.lsp_definitions, { desc = "Goto Definition" })
				end

				keymap.set("n", "gr", lsp_references_with_context, { desc = "References with context", nowait = true })
				-- keymap.set("n", "gr", tel.lsp_references, { desc = "References", nowait = true })
				keymap.set("n", "gI", tel.lsp_implementations, { desc = "Goto Implementation" })
				keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto T[y]pe Definition" })
				keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
				keymap.set("n", "K", function() return vim.lsp.buf.hover() end, { desc = "Hover" })
				if has(bufnr, "signatureHelp") then
					keymap.set("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
					keymap.set({ "n", "i" }, "<c-k>", function() return vim.lsp.buf.signature_help() end,
						{ desc = "Signature Help" })
				end
				if has(bufnr, "codeAction") then
					keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
				end
				if has(bufnr, "codeLens") then
					keymap.set({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run,
						{ desc = "Run Codelens" })
					keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh,
						{ desc = "Refresh & Display Codelens" })
				end
				if has(bufnr, { "workspace/didRenameFiles", "workspace/willRenameFiles" }) then
					keymap.set("n", "<leader>cR", function() Snacks.rename.rename_file() end,
						{ desc = "Rename File" })
				end
				if has(bufnr, "rename") then
					keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
				end
				if has(bufnr, "documentHighlight") and Snacks.words.is_enabled() then
					keymap.set("n", "]]", function() Snacks.words.jump(vim.v.count1) end,
						{
							desc = "Next Reference"
						})
					keymap.set("n", "[[", function() Snacks.words.jump(-vim.v.count1) end,
						{
							desc = "Prev Reference"
						})
					keymap.set("n", "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end,
						{
							desc = "Next Reference"
						})
					keymap.set("n", "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end,
						{
							desc = "Prev Reference"
						})
				end
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		-- local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			virtual_text = true,
			-- virtual_lines = true,
			virtual_lines = {
				current_line = true,
			}
		})

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- -- Auto-format on save for every supported filetype
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('my.lsp', {}),
			callback = function(args)
				local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
				if not client then return end

				-- Auto-format ("lint") on save.
				-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
				if not client:supports_method('textDocument/willSaveWaitUntil')
					and client:supports_method('textDocument/formatting') then
					vim.api.nvim_create_autocmd('BufWritePre', {
						group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
						buffer = args.buf,
						callback = function()
							vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
						end,
					})
				end
			end,
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		vim.lsp.config("java_language_server", {
			filetypes = { "java" },
			handlers = {
				["client/registerCapability"] = function(err, result, ctx, config)
					local registration = {
						registrations = { result },
					}
					return vim.lsp.handlers["client/registerCapability"](err, registration, ctx, config)
				end,
			},
			on_attach = function(client, bufnr)
				-- You can also disable auto-import or formatting here if needed
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.codeActionProvider = false
			end,
		})

		-- Go formatter
		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					gofumpt = true,
				},
			},
		})

		vim.lsp.config("clangd", {
			cmd = require("devcontainers").lsp_cmd({ "clangd", "--background-index" })
		})
		vim.lsp.enable("clangd")
	end,
}
