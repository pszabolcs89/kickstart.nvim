-- https://github.com/stevearc/oil.nvim

local detail = false
return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<leader>fl'] = { 'actions.select', opts = { vertical = true } },
      ['<leader>fj'] = { 'actions.select', opts = { horizontal = true } },
      ['<leader>ft'] = { 'actions.select', opts = { tab = true } },
      ['<leader>fp'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['<leader>fr'] = 'actions.refresh',
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
      ['gd'] = {
        desc = 'Toggle file detail view',
        callback = function()
          detail = not detail
          if detail then
            require('oil').set_columns { 'icon', 'permissions', 'size', { 'mtime', format = '%Y-%m-%d %H:%M:%S' } }
          else
            require('oil').set_columns { 'icon' }
          end
        end,
      },
    },
    use_default_keymaps = false,
  },
  -- Optional dependencies
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
