-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    'saifulapm/neotree-file-nesting-config',
    {
      's1n7ax/nvim-window-picker',
      version = '2.*',
      config = function()
        require('window-picker').setup {
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { 'terminal', 'quickfix' },
            },
          },
        }
      end,
    },
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  config = function(_, opts)
    -- Adding rules from plugin
    opts.nesting_rules = require('neotree-file-nesting-config').nesting_rules
    require('neo-tree').setup(opts)
  end,
  opts = {
    hide_root_node = true,
    retain_hidden_root_indent = true,
    commands = {
      -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/370#discussioncomment-6679447
      copy_path = function(state)
        local node = state.tree:get_node()
        local filepath = node:get_id()
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local vals = {
          ['Basename'] = modify(filename, ':r'),
          ['Extension'] = modify(filename, ':e'),
          ['Filename'] = filename,
          ['Path (cwd)'] = modify(filepath, ':.'),
          ['Path (home)'] = modify(filepath, ':~'),
          ['Fullpath'] = filepath,
          ['Uri'] = vim.uri_from_fname(filepath),
        }

        -- filter out empty values from the table
        local options = vim.tbl_filter(function(val)
          return vals[val] ~= ''
        end, vim.tbl_keys(vals))

        if vim.tbl_isempty(options) then
          vim.notify('No values to copy', vim.log.levels.WARN)
          return
        end

        table.sort(options)

        vim.ui.select(options, {
          prompt = 'Choose to copy to clipboard:',
          format_item = function(item)
            return ('%s: %s'):format(item, vals[item])
          end,
        }, function(choice)
          local result = vals[choice]
          if result then
            vim.notify(('Copied: `%s`'):format(result))
            vim.fn.setreg('+', result)
          end
        end)
      end,
      system_open = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()

        -- macOs: open file in default application in the background.
        -- vim.fn.jobstart({ 'open', path }, { detach = true })
        -- Linux: open file in default application
        -- vim.fn.jobstart({ 'xdg-open', path }, { detach = true })

        if vim.fn.has 'win32' == 1 then
          -- Windows: Without removing the file from the path, it opens in code.exe instead of explorer.exe
          local p
          local lastSlashIndex = path:match '^.+()\\[^\\]*$' -- Match the last slash and everything before it
          if lastSlashIndex then
            p = path:sub(1, lastSlashIndex - 1) -- Extract substring before the last slash
          else
            p = path -- If no slash found, return original path
          end
          vim.cmd('silent !start explorer ' .. p)
        end
      end,
    },
    window = {
      mappings = {
        Y = 'copy_path',
      },
    },
    filesystem = {
      filtered_items = {
        show_hidden_count = false,
        never_show = {
          '.DS_Store',
        },
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['o'] = 'system_open',
        },
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = '',
        expander_expanded = '',
      },
    },
  },
}
