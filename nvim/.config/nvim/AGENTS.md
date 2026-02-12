# AGENTS.md

## Build, Lint, and Test Commands
- **No automated test or build scripts.**
- To check configuration health, open Neovim and run `:LazyHealth`.
- To reload config, use `:source %` or restart Neovim.
- Formatting is enforced with [stylua](https://github.com/JohnnyMorganz/StyLua):
  - Indent: 2 spaces
  - Max line width: 120
- To format Lua files: `stylua <file>`

## Code Style Guidelines
- **Imports:** Use `require` with relative module paths.
- **Formatting:** Follow stylua.toml (2 spaces, 120 columns).
- **Types:** Lua is dynamically typed; use clear variable names and tables for structure.
- **Naming:**
  - Modules: PascalCase or snake_case (e.g., `local M = {}`)
  - Functions/variables: snake_case
  - Constants: ALL_CAPS (rare)
- **Error Handling:** Use `pcall` or check return values; notify users with `vim.notify`.
- **Keymaps:** Use descriptive names and `vim.keymap.set`.
- **Commands:** Register with `vim.api.nvim_create_user_command` and provide usage info on error.

## References
- See [LazyVim documentation](https://lazyvim.github.io/installation) for more details.
- This repo is a Neovim config; most testing is manual via Neovim itself.
