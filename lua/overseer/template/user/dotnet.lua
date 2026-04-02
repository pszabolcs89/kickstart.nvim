-- check once at load time whether dotnet is on PATH
local dotnet_found = vim.fn.executable 'dotnet' == 1

---@type overseer.TemplateFileProvider
return {
  generator = function(search, callback)
    if not dotnet_found then
      return 'dotnet not found in PATH'
    end

    local slns = vim.fn.glob('*.sln', false, true)
    if #slns == 0 then
      return 'no .sln file found in current directory'
    end

    local commands = {
      {
        label = 'Build',
        cmd = { 'dotnet' },
        args = { 'build' },
        tag = require('overseer').TAG.BUILD,
      },
      {
        label = 'Clean',
        cmd = { 'dotnet' },
        args = { 'clean' },
        tag = require('overseer').TAG.BUILD,
      },
    }

    local tasks = {}

    for _, sln in ipairs(slns) do
      local sln_name = vim.fn.fnamemodify(sln, ':t:r')

      for _, command in ipairs(commands) do
        table.insert(tasks, {
          name = string.format('dotnet: %s - %s', sln_name, command.label),
          tags = { command.tag },
          builder = function()
            local args = vim.list_extend(vim.deepcopy(command.args), { sln })
            return {
              cmd = command.cmd,
              args = args,
              components = {
                { 'user.fidget_progress', in_progress_message = 'dotnet build in progress' },
                { 'on_output_parse', problem_matcher = '$msCompile' },
                { 'on_result_diagnostics_quickfix', set_empty_results = true, open = true },
                'default',
              },
            }
          end,
        })
      end
    end

    callback(tasks)
  end,

  cache_key = function(search)
    return vim.fn.glob('*.sln', false, true)[1]
  end,
}
