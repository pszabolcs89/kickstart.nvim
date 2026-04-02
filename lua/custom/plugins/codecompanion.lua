-- https://codecompanion.olimorris.dev/installation
-- https://github.com/olimorris/codecompanion.nvim

return {
  'olimorris/codecompanion.nvim',
  version = '^19.0.0',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    interactions = {
      chat = {
        -- You can specify an adapter by name and model (both ACP and HTTP)
        adapter = {
          name = 'codex',
          -- model = 'gpt-4.1',
        },
      },
    },
    adapters = {
      acp = {
        codex = function()
          return require('codecompanion.adapters').extend('codex', {
            defaults = {
              -- auth_method = 'openai-api-key', -- "openai-api-key"|"codex-api-key"|"chatgpt"
              auth_method = 'codex-api-key',
            },
            env = {
              -- OPENAI_API_KEY = 'open-api-key',
              CODEX_API_KEY = 'cmd:dcli read dl://2D1E84F5-FD9F-4C7A-B940-7BC22B4C56F3/password',
            },
          })
        end,
      },
    },
    -- NOTE: The log_level is in `opts.opts`
    opts = {
      -- log_level = 'DEBUG', -- or "TRACE"
      log_level = 'TRACE',
    },
  },
}
