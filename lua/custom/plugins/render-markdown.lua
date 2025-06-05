-- https://github.com/MeanderingProgrammer/render-markdown.nvim

return {
  'MeanderingProgrammer/render-markdown.nvim',
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ft = { 'markdown' },
  keys = {
    {
      '<leader>mt',
      function()
        require('render-markdown').buf_toggle()
      end,
      ft = { 'markdown' },
      desc = 'Render-markdown: Toggle for current buffer',
    },
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = { completions = { blink = { enabled = true } } },
}
