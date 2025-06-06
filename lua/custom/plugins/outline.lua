-- https://github.com/hedyhli/outline.nvim

return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  keys = { -- Example mapping to toggle outline
    { '<leader>wo', '<cmd>Outline<CR>', desc = 'outline: Toggle outline' },
  },
  opts = {
    -- Your setup opts here
  },
}
