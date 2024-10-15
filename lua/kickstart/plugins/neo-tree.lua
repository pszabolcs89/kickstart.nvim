-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    {
        's1n7ax/nvim-window-picker',
        version = '2.*',
        config = function()
            require 'window-picker'.setup({
                filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    -- filter using buffer options
                    bo = {
                        -- if the file type is one of following, the window will be ignored
                        filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                        -- if the buffer type is one of following, the window will be ignored
                        buftype = { 'terminal', "quickfix" },
                    },
            },
        })
        end,
      },
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    commands = {
      -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/370#discussioncomment-6679447
      copy_path = function(state)
        local node = state.tree:get_node()
        local filepath = node:get_id()
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local vals = {
          ["Basename"] = modify(filename, ":r"),
          ["Extension"] = modify(filename, ":e"),
          ["Filename"] = filename,
          ["Path (cwd)"] = modify(filepath, ":."),
          ["Path (home)"] = modify(filepath, ":~"),
          ["Fullpath"] = filepath,
          ["Uri"] = vim.uri_from_fname(filepath),
        }

        -- filter out empty values from the table
        local options = vim.tbl_filter(
          function(val)
            return vals[val] ~= ""
          end,
          vim.tbl_keys(vals)
        )

        if vim.tbl_isempty(options) then
          vim.notify("No values to copy", vim.log.levels.WARN)
          return
        end

        table.sort(options)

        vim.ui.select(options, {
          prompt = "Choose to copy to clipboard:",
          format_item = function(item)
            return ("%s: %s"):format(item, vals[item])
          end,
        }, function(choice)
          local result = vals[choice]
          if result then
            vim.notify(("Copied: `%s`"):format(result))
            vim.fn.setreg("+", result)
          end
        end)
      end,
    },
    window = {
      mappings = {
        Y = "copy_path",
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
    },
  },
}
