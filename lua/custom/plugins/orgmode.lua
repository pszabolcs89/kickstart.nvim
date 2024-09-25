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
        W = {
              description = 'Daily work journal',
              template = '\n*** %<%Y-%m-%d> %<%A> :work:\n\n%?',
              target = '~/mnotes/orgfiles/work/journal/%<%Y>/%<%m>/%<%Y-%m-%d>.org'
            },
        },
      org_id_link_to_org_use_id = true,
      org_id_method = 'ts',
      org_startup_folded = 'showeverything',
    })

    -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
    -- add ~org~ to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
  end,
}

