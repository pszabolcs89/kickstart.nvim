-- check once at load time whether msbuild is on PATH
local msbuild_found = vim.fn.executable 'msbuild' == 1
local solution_kind = require 'overseer.template.user.solution_kind'

---@type overseer.TemplateFileProvider
return {
  generator = function(search, callback)
    if not msbuild_found then
      return 'msbuild not found in PATH — did you run Launch-VsDevShell?'
    end

    local slns = vim.fn.glob('*.sln', false, true)
    if #slns == 0 then
      return 'no .sln file found in current directory'
    end

    local commands = {
      {
        label = 'Build',
        args = { '/restore', '/t:Build', '/p:RestorePackagesConfig=true' },
        tag = require('overseer').TAG.BUILD,
      },
      {
        label = 'Clean',
        args = { '/t:Clean' },
        tag = require('overseer').TAG.BUILD,
      },
      {
        label = 'Rebuild',
        args = { '/restore', '/t:Rebuild', '/p:RestorePackagesConfig=true' },
        tag = require('overseer').TAG.BUILD,
      },
    }

    local tasks = {}

    for _, sln in ipairs(slns) do
      if not solution_kind.solution_supports_dotnet_cli(sln) then
        local sln_name = vim.fn.fnamemodify(sln, ':t:r')

        for _, cmd in ipairs(commands) do
          table.insert(tasks, {
            name = string.format('MSBuild: %s – %s', sln_name, cmd.label),
            tags = { cmd.tag },
            builder = function()
              local args = { sln }
              vim.list_extend(args, cmd.args)
              return {
                cmd = { 'msbuild' },
                args = args,
                components = {
                  { 'user.fidget_progress', in_progress_message = 'MSBuild in progress' },
                  { 'on_output_parse', problem_matcher = '$msCompile' },
                  { 'on_result_diagnostics_quickfix', set_empty_results = true, open = true },
                  'default',
                },
              }
            end,
          })
        end
      end
    end

    callback(tasks)
  end,

  -- condition = {
  --   callback = function()
  --     if not msbuild_found then
  --       return false, 'msbuild not found in PATH — did you run Launch-VsDevShell?'
  --     end
  --     if vim.fn.glob '*.sln' == '' then
  --       return false, 'no .sln file found in current directory'
  --     end
  --     return true
  --   end,
  -- },

  cache_key = function(search)
    return vim.fn.glob('*.sln', false, true)[1]
  end,
}
