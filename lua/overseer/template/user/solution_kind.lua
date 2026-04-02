local M = {}

local dotnet_project_extensions = {
  csproj = true,
  fsproj = true,
  vbproj = true,
}

local always_msbuild_extensions = {
  vcproj = true,
  vcxproj = true,
  vdproj = true,
  shproj = true,
  sqlproj = true,
  wixproj = true,
}

local function read_file(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end

  return table.concat(lines, '\n')
end

local function normalize_path(path)
  return (path:gsub('\\', '/'))
end

local function project_paths_from_solution(sln)
  local root = vim.fn.fnamemodify(sln, ':p:h')
  local lines = vim.fn.readfile(sln)
  local project_paths = {}

  for _, line in ipairs(lines) do
    local relative_path = line:match '^Project%b() = ".-", "(.-)", ".-"$'
    if relative_path and relative_path ~= '' then
      local extension = vim.fn.fnamemodify(relative_path, ':e'):lower()
      if dotnet_project_extensions[extension] or always_msbuild_extensions[extension] then
        table.insert(project_paths, normalize_path(root .. '/' .. relative_path))
      end
    end
  end

  return project_paths
end

local function project_supports_dotnet_cli(project_path)
  local extension = vim.fn.fnamemodify(project_path, ':e'):lower()
  if always_msbuild_extensions[extension] then
    return false
  end

  if not dotnet_project_extensions[extension] then
    return false
  end

  local contents = read_file(project_path)
  if not contents then
    return false
  end

  if contents:match '<Project[^>]-Sdk%s*=' or contents:match '<Sdk%s+Name%s*=' then
    return true
  end

  if contents:match '<TargetFrameworkVersion>%s*v4' then
    return false
  end

  return false
end

function M.solution_supports_dotnet_cli(sln)
  local project_paths = project_paths_from_solution(sln)
  if vim.tbl_isempty(project_paths) then
    return false
  end

  for _, project_path in ipairs(project_paths) do
    if not project_supports_dotnet_cli(project_path) then
      return false
    end
  end

  return true
end

return M
