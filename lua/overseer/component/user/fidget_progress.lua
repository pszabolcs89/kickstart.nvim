local constants = require 'overseer.constants'
local util = require 'overseer.util'

local STATUS = constants.STATUS

local function close_handle(handle, method)
  if not handle then
    return
  end
  pcall(function()
    handle[method](handle)
  end)
end

---@type overseer.ComponentFileDefinition
return {
  desc = 'Show concise task progress in Fidget without forwarding task output',
  params = {
    statuses = {
      desc = 'List of completion statuses that should be reflected in the final message',
      type = 'list',
      subtype = {
        type = 'enum',
        choices = STATUS.values,
      },
      default = {
        STATUS.FAILURE,
        STATUS.SUCCESS,
        STATUS.CANCELED,
      },
    },
    in_progress_message = {
      desc = 'Message to show while the task is running',
      type = 'string',
      default = 'In progress',
    },
    title = {
      desc = 'Optional title override for the Fidget progress item',
      type = 'string',
      optional = true,
    },
    client_name = {
      desc = 'Logical client name shown by Fidget',
      type = 'string',
      default = 'Overseer',
    },
  },
  constructor = function(params)
    if type(params.statuses) == 'string' then
      params.statuses = { params.statuses }
    end
    local statuses = util.list_to_map(params.statuses)

    return {
      handle = nil,

      on_start = function(self, task)
        local ok, progress = pcall(require, 'fidget.progress')
        if not ok then
          return
        end

        self.handle = progress.handle.create {
          title = params.title or task.name,
          message = params.in_progress_message,
          lsp_client = { name = params.client_name },
          cancellable = true,
        }
      end,

      on_complete = function(self, task, status)
        if not self.handle then
          return
        end

        if statuses[status] then
          self.handle.message = status
        end

        self.handle:finish()
        self.handle = nil
      end,

      on_reset = function(self)
        close_handle(self.handle, 'cancel')
        self.handle = nil
      end,

      on_dispose = function(self)
        close_handle(self.handle, 'cancel')
        self.handle = nil
      end,
    }
  end,
}
