-- https://github.com/nvim-orgmode/orgmode

return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    -- Setup orgmode
    require('orgmode').setup({
      org_agenda_files = '~/mnotes/orgfiles/**/*',
      org_default_notes_file = '~/mnotes/orgfiles/refile.org',
      org_capture_templates = {
        t = { description = 'Task', template = '* TODO %?\n  %u' },
        J = {
              description = 'Journal',
              template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
              target = '~/mnotes/orgfiles/journal/%<%Y>/%<%m>/%<%Y-%m-%d>.org'
            },
        }
    })

    -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
    -- add ~org~ to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
  end,
}

