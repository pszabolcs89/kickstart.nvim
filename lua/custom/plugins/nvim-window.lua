-- https://github.com/yorickpeterse/nvim-window

return {
  'yorickpeterse/nvim-window',
  keys = {
    {
      '<leader>wj',
      function()
        require('nvim-window').pick()
      end,
      desc = 'nvim-window: Jump to window',
    },
  },
  config = true,
}
