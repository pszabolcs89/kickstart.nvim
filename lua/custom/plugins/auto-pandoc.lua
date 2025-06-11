-- https://github.com/jghauser/auto-pandoc.nvim

return {
  'jghauser/auto-pandoc.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ft = 'markdown',
  keys = {
    {
      '<leader>go',
      function()
        require('auto-pandoc').run_pandoc()
      end,
      desc = 'auto-pandoc: Generate file using pandoc',
      ft = 'markdown',
    },
  },
}
