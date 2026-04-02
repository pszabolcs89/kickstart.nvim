# Codex Agent Guide

## Project Shape

- This repo is a personal Neovim configuration based on `kickstart.nvim`.
- `init.lua` is still the primary entrypoint and contains most core options, keymaps, plugin setup, LSP configuration, and formatting setup.
- `lua/custom/plugins/*.lua` contains user plugin specs and plugin-specific configuration. Prefer adding new plugin definitions here instead of expanding `init.lua` further unless the change is tightly coupled to existing core setup.
- `lua/kickstart/plugins/*.lua` contains upstream-style Kickstart plugin modules. Treat these as existing project code, not generated files.
- `after/ftplugin/*.lua` contains filetype-local settings and keymaps.
- `doc/kickstart.txt` is local help text for the config.

## Editing Rules

- Prefer minimal, local changes that match the existing style in the touched file.
- Keep Lua code compatible with Neovim's embedded LuaJIT runtime.
- Preserve the current plugin architecture:
  - core/editor behavior in `init.lua`
  - plugin specs in `lua/custom/plugins/`
  - filetype-specific behavior in `after/ftplugin/`
- Do not hardcode secrets. The Codex adapter config already expects secrets to come from external commands or environment variables.
- When changing LSP behavior, extend the existing `lazydev.nvim` and `nvim-lspconfig` setup in `init.lua` instead of introducing a second Lua or LSP bootstrap path.

## Useful Commands

- Format Lua files:
  ```powershell
  stylua init.lua lua after
  ```
- Check formatting without changing files:
  ```powershell
  stylua --check init.lua lua after
  ```
- Validate that Neovim can start with this config:
  ```powershell
  nvim --headless "+qa"
  ```
- Search the repo quickly:
  ```powershell
  rg "pattern"
  ```

## Notes For Agents

- This is a Windows/PowerShell workspace rooted at `%LOCALAPPDATA%\\nvim`.
- The repo already configures `lua_ls` and `lazydev.nvim`; prefer improving those rather than adding overlapping Lua tooling.
- The repo already contains a Codex-related Neovim integration in `lua/custom/plugins/codecompanion.lua`. Keep terminal Codex setup separate from in-editor adapter configuration unless the user asks to connect them.
- There is no dedicated test suite. For most changes, `stylua --check` plus a headless Neovim startup check is the minimum validation bar.
