local config = require("patchr.config")
local patching = require("patchr.patching")

local M = {}

---Resets the repositories of specified plugins
---If none is specified it will reset all
---@param plugin_names patchr.plugin_names
function M.reset(plugin_names)
  patching.reset_plugin_repositories(plugin_names)
  print("♻️ patchr.nvim: reset called on: " .. table.concat(plugin_names, ", "))
end

---Applies patches to all specified plugins
---@param plugin_names patchr.plugin_names
---@param reset boolean reset repositories before applying any patches
function M.apply(plugin_names, reset)
  patching.apply_patches(plugin_names, reset)
  print("📦 patchr.nvim: applied patches on: " .. table.concat(plugin_names, ", "))
end

--- Handles a :Patchr command
---@params opts vim.api.keyset.create_user_command.command_args
function M.handle(opts)
  local args = opts.fargs
  local cmd = args[1]

  if cmd == nil or cmd == "" then
    vim.notify("❓patchr.nvim: Specify one of apply or reset", vim.log.levels.WARN)
    return
  end

  ---@type table<string>
  local plugin_names = unpack(args, 2)
  plugin_names = plugin_names or config.get_plugin_names()

  if cmd == "reset" then
    M.reset(plugin_names)
  elseif cmd == "apply" then
    M.apply(plugin_names, false)
  else
    vim.notify("❓patchr.nvim: Unknown Patchr command", vim.log.levels.WARN)
  end
end

function M.complete(arg_lead, cmd_line, cursor_pos)
  local args = vim.split(cmd_line, "%s+")
  if #args <= 2 then
    return { "apply", "reset" }
  else
    return config.get_plugin_names()
  end
end

return M
