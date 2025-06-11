-- https://github.com/nanozuki/tabby.nvim

return {
  lazy = false,
  keys = {
    { '<leader>tj', '<cmd>Tabby jump_to_tab<cr>', desc = 'Tabby: [J]ump to tab' },
  },
  'nanozuki/tabby.nvim',
  ---@type TabbyConfig
  opts = {
    -- configs...
  },
}
