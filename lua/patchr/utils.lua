---@class patchr.utils
local M = {}

--- Seraches for a plubin sepc lazy's plugins
--- @param plugin_name string
--- @return LazyPlugin | nil
function M.find_lazy_plugin(plugin_name)
  local plugins = require("lazy").plugins()
  for _, plugin in ipairs(plugins) do
    if plugin.name == plugin_name then
      return plugin
    end
  end
  return nil
end

return M
