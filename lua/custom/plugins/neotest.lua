-- https://github.com/nvim-neotest/neotest

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- adapters
    'nvim-neotest/neotest-python',
    'nsidorenco/neotest-vstest',
  },
  keys = {
    {
      '<leader>dtt',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run nearest test',
    },
    {
      '<leader>dtf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Run file',
    },
    {
      '<leader>dts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle summary',
    },
    {
      '<leader>dto',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Toggle output panel',
    },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-python' {
          dap = { justMyCode = false },
          runner = 'pytest',
          -- python = function()
          --   -- prefer virtualenv python if present
          --   local venv = vim.fn.getcwd() .. "/.venv/bin/python"
          --   if vim.fn.executable(venv) == 1 then return venv end
          --   return "python"
          -- end,
        },

        require 'neotest-vstest' {
          dap_settings = {
            type = 'coreclr',
          },
        },
      },
    }
  end,
}
