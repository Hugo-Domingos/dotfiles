-- return {
--   -- add gruvbox
--   { "ellisonleao/gruvbox.nvim" },
--
--   -- configure lazyvim to load gruvbox
--   {
--     "lazyvim/lazyvim",
--     opts = {
--       colorscheme = "gruvbox",
--     },
--   },
-- }
-- return {
--   -- add gruvbox
--   { "wittyjudge/gruvbox-material.nvim" },
--
--   -- Configure LazyVim to load gruvbox
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "gruvbox-material",
--     },
--   },
-- }

return {
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_transparent_background = "1"
      vim.g.gruvbox_material_enable_italic = "1"
      vim.g.gruvbox_material_style = "original"
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
}
