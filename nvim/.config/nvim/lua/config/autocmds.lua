-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- local harpoon = require("harpoon")
--
-- require("telescope").load_extension("harpoon")
--
-- -- REQUIRED
-- harpoon:setup()
-- REQUIRED

-- vim.keymap.set("n", "<leader>a", function()
--   harpoon:list():add()
-- end)
-- vim.keymap.set("n", "<leader>hl", function()
--   harpoon.ui:toggle_quick_menu(harpoon:list())
-- end)
--
-- vim.keymap.set("n", "<leader>1", function()
--   harpoon:list():select(1)
-- end)
-- vim.keymap.set("n", "<leader>2", function()
--   harpoon:list():select(2)
-- end)
-- vim.keymap.set("n", "<leader>3", function()
--   harpoon:list():select(3)
-- end)
-- vim.keymap.set("n", "<leader>4", function()
--   harpoon:list():select(4)
-- end)
--
-- -- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<leader>hp", function()
--   harpoon:list():prev()
-- end)
-- vim.keymap.set("n", "<leader>hn", function()
--   harpoon:list():next()
-- end)


local project_root = vim.fn.getcwd() -- Or detect it dynamically
local bazelversion_path = project_root .. "/.bazelversion"
local backup_path = project_root .. "/.bazelversion.bak"
local fake_version = "nonexistent-version"

-- Backup and replace .bazelversion on startup
vim.api.nvim_create_autocmd("BufRead", {
	callback = function()
		local uv = vim.loop
		if uv.fs_stat(bazelversion_path) and not uv.fs_stat(backup_path) then
			local ok1, err1 = os.rename(bazelversion_path, backup_path)
			if not ok1 then
				return
			end
			local f = io.open(bazelversion_path, "w")
			if f then
				f:write(fake_version .. "\n")
				f:close()
			end
		end
	end,
})

-- Restore .bazelversion on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		local uv = vim.loop
		if uv.fs_stat(backup_path) then
			os.remove(bazelversion_path)
			local ok2, err2 = os.rename(backup_path, bazelversion_path)
		end
	end,
})

-- Close the "No Name" buffer when opening a real file
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local name = vim.api.nvim_buf_get_name(bufnr)
		if name ~= "" and vim.fn.bufexists(1) == 1 and vim.fn.bufname(1) == "" then
			vim.cmd("silent! bwipeout 1")
		end
	end,
})
