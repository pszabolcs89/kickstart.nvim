local powershell_found = vim.fn.executable 'powershell' == 1
local migrator_script = [[Tools\Build\RunFluentMigrator.ps1]]

local function get_migrator_script()
  if vim.fn.filereadable(migrator_script) ~= 1 then
    return nil
  end

  return vim.fn.fnamemodify(migrator_script, ':p')
end

---@type overseer.TemplateFileProvider
return {
  generator = function(search, callback)
    if not powershell_found then
      return 'PowerShell not found in PATH'
    end

    local script = get_migrator_script()
    if not script then
      return [[Tools\Build\RunFluentMigrator.ps1 not found in current directory]]
    end

    local cwd = vim.fn.getcwd()
    callback {
      {
        name = 'Migrations: Run FluentMigrator',
        tags = { require('overseer').TAG.RUN },
        builder = function()
          return {
            cmd = { 'powershell' },
            args = { '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', [[.\]] .. migrator_script },
            cwd = cwd,
            components = {
              { 'user.fidget_progress', in_progress_message = 'Running migrations' },
              'default',
            },
          }
        end,
      },
    }
  end,

  cache_key = function(search)
    return get_migrator_script()
  end,
}
