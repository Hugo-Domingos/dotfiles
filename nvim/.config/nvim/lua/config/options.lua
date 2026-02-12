-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.signcolumn = "yes"

vim.opt.winborder = "rounded"
vim.opt.inccommand = "split"

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"

vim.opt.termguicolors = true

vim.opt.scrolloff = 10

vim.g.snacks_animate = false

local opts = { noremap = true, silent = false }

-- To reload neovim config
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
