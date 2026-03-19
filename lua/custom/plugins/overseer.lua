-- https://github.com/stevearc/overseer.nvim

return {
  'stevearc/overseer.nvim',
  keys = {
    { '<leader>doo', '<cmd>OverseerToggle<CR>', desc = 'Overseer: Toggle window' },
    { '<leader>dor', '<cmd>OverseerRun<CR>', desc = 'Overseer: Run task' },
    { '<leader>doa', '<cmd>OverseerTaskAction<CR>', desc = 'Overseer: Select a task to run an action on' },
    { '<leader>dos', '<cmd>OverseerShell<CR>', desc = 'Overseer: Run a shell command as an overseer task' },
  },
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {},
}
