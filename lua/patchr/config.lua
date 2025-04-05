---@class patchr.config.mod
local M = {
  ---@class patchr.config
  opts = {
    autocmds = true,
    plugins = {},
    ---@class patchr.config.git
    git = {
      ---@class patchr.config.git.reset
      reset = {
        hard = true,
      },
    },
  },
}

---@param opts? patchr.config
---@return patchr.config
function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", {}, M.opts, opts or {})
  return M.opts
end

--- extract plugin names as table
--- @param plugins? patchr.plugins plugins to extract names fromm - falls back to plugin options
--- @return patchr.plugin_names names of the plugins provided
function M.get_plugin_names(plugins)
  plugins = plugins or M.opts.plugins
  local plugin_names = {}
  for plugin_name, _ in pairs(plugins) do
    table.insert(plugin_names, plugin_name)
  end
  return plugin_names
end

return M
