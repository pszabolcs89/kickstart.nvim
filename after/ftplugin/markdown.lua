-- ~/.config/nvim/after/ftplugin/markdown.lua
-- Reads .markdownlint.yaml up the directory tree and sets colorcolumn/textwidth
-- based on the MD013/line-length setting.

local M = {}

--- Find .markdownlint.yaml by walking up from the given directory.
---@param start_dir string
---@return string|nil path to the file, or nil
local function find_markdownlint_yaml(start_dir)
  local dir = start_dir
  while true do
    local candidate = dir .. '/.markdownlint.yaml'
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end
    local parent = vim.fn.fnamemodify(dir, ':h')
    if parent == dir then
      break
    end -- reached filesystem root
    dir = parent
  end
  return nil
end

--- Use Tree-sitter to extract the line_length value from a markdownlint YAML file.
--- Handles these common shapes:
---   MD013:
---     line_length: 120
---
---   MD013:
---     line_length: 100
---
---   line-length: 80          (top-level alias, less common)
---@param filepath string
---@return number|nil
local function parse_line_length(filepath)
  local content = table.concat(vim.fn.readfile(filepath), '\n')

  -- Make sure the yaml parser is available
  local ok, parser = pcall(vim.treesitter.get_string_parser, content, 'yaml')
  if not ok or not parser then
    vim.notify('markdown.lua: yaml Tree-sitter parser not available, falling back to regex', vim.log.levels.WARN)
    return nil
  end

  local tree = parser:parse()[1]
  if not tree then
    return nil
  end

  local root = tree:root()

  -- Query for block_mapping_pair nodes where the key is "line_length"
  -- and whose ancestor has a key of "MD013".
  --
  -- YAML structure (simplified):
  --   block_mapping
  --     block_mapping_pair          <- key: "MD013"
  --       key: flow_node "MD013"
  --       value:
  --         block_node
  --           block_mapping
  --             block_mapping_pair  <- key: "line_length", value: <number>
  --               key: ...
  --               value: ...
  local query_src = [[
    (block_mapping_pair
      key: (flow_node) @md013_key
      value: (block_node
        (block_mapping
          (block_mapping_pair
            key: (flow_node) @ll_key
            value: (flow_node) @ll_value
          )
        )
      )
    )
  ]]

  local query_ok, query = pcall(vim.treesitter.query.parse, 'yaml', query_src)
  if not query_ok or not query then
    vim.notify('markdown.lua: failed to compile Tree-sitter query: ' .. tostring(query), vim.log.levels.WARN)
    return nil
  end

  for _, match, _ in query:iter_matches(root, content, 0, -1) do
    local md013_key_node, ll_key_node, ll_value_node

    -- iter_matches returns a table indexed by capture id
    for id, nodes in pairs(match) do
      local name = query.captures[id]
      -- nodes can be a list in newer nvim versions
      local node = type(nodes) == 'table' and nodes[1] or nodes
      if name == 'md013_key' then
        md013_key_node = node
      elseif name == 'll_key' then
        ll_key_node = node
      elseif name == 'll_value' then
        ll_value_node = node
      end
    end

    if md013_key_node and ll_key_node and ll_value_node then
      local md013_key_text = vim.treesitter.get_node_text(md013_key_node, content)
      local ll_key_text = vim.treesitter.get_node_text(ll_key_node, content)

      if md013_key_text == 'MD013' and ll_key_text == 'line_length' then
        local ll_value_text = vim.treesitter.get_node_text(ll_value_node, content)
        local value = tonumber(ll_value_text)
        if value then
          return value
        end
      end
    end
  end

  return nil
end

--- Fallback: simple line-by-line search when Tree-sitter yaml is unavailable.
---@param filepath string
---@return number|nil
local function parse_line_length_fallback(filepath)
  local in_md013 = false
  for _, line in ipairs(vim.fn.readfile(filepath)) do
    if line:match '^MD013%s*:' then
      in_md013 = true
    elseif in_md013 then
      -- Indented key under MD013
      local v = line:match '^%s+line_length%s*:%s*(%d+)'
      if v then
        return tonumber(v)
      end
      -- If we hit a non-indented, non-blank line we've left the MD013 block
      if line:match '^%S' and not line:match '^%s*$' then
        in_md013 = false
      end
    end
    -- Top-level line-length (rare, but handle it)
    local top = line:match '^line.length%s*:%s*(%d+)'
    if top then
      return tonumber(top)
    end
  end
  return nil
end

--- Apply colorcolumn and textwidth for the current buffer.
---@param line_length number
local function apply_settings(line_length)
  vim.opt_local.textwidth = line_length
  vim.opt_local.colorcolumn = tostring(line_length + 1)
end

--- Main entry point.
local function setup()
  local bufpath = vim.api.nvim_buf_get_name(0)
  if bufpath == '' then
    return
  end

  local dir = vim.fn.fnamemodify(bufpath, ':p:h')
  local yaml_path = find_markdownlint_yaml(dir)
  if not yaml_path then
    return
  end

  -- Try Tree-sitter first, then regex fallback
  local line_length = parse_line_length(yaml_path)
  if not line_length then
    line_length = parse_line_length_fallback(yaml_path)
  end

  if line_length then
    apply_settings(line_length)
  end
end

setup()
