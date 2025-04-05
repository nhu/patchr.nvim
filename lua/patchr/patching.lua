local config = require("patchr.config")
local git = require("patchr.git")
local utils = require("patchr.utils")
local uv = vim.uv or vim.loop

---@class patchr.patching
local M = {}

--- Resets repositories of the specified plugins
--- @param plugin_names? patchr.plugin_names
function M.reset_plugin_repositories(plugin_names)
  plugin_names = plugin_names or config.get_plugin_names()
  for _, plugin in ipairs(plugin_names) do
    local lazy_plugin = utils.find_lazy_plugin(plugin)
    if lazy_plugin ~= nil then
      local reset = git.reset(lazy_plugin.dir)

      if reset.code ~= 0 then
        vim.notify(
          ("patchr.nvim: Failed to reset %s repository:\n%s"):format(lazy_plugin.name, reset.stderr),
          vim.log.levels.ERROR
        )
      end
    end
  end
end

--- Applies a unified diff patch to the specified target file
---@param lazy_plugin LazyPlugin the lazy plugin to patche
---@param patch patchr.plugin.patch local patch file
---@return boolean result whether the patch was successfully applied
function M.apply_patch(lazy_plugin, patch)
  if vim.fn.filereadable(patch) == 0 then
    vim.notify(("patchr.nvim: File `%s` is not readable"):format(patch), vim.log.levels.ERROR)
    return false
  end
  if uv.fs_stat(lazy_plugin.dir) == false then
    vim.notify(("patchr.nvim: Plugin dir `%s` does not exist"):format(lazy_plugin.dir), vim.log.levels.ERROR)
    return false
  end

  local apply = git.apply(lazy_plugin.dir, patch)
  if apply.code ~= 0 then
    vim.notify(("patchr.nvim: Failed to apply patch:\n%s"):format(apply.stderr), vim.log.levels.ERROR)
    return false
  end
  local filename = vim.fn.fnamemodify(patch, ":t")
  vim.notify(("patchr.nvim: applied %s to %s"):format(filename, lazy_plugin.name), vim.log.levels.INFO)
  return true
end

--- Apply configured patches for the specified plugins
---@param plugin_names patchr.plugin_names the plugins to target
---@param reset boolean reset repositories before applying any patches
---@return boolean returns true on success and false when errors occurred
function M.apply_patches(plugin_names, reset)
  if reset == true then
    M.reset_plugin_repositories(plugin_names)
  end

  for _, plugin_name in ipairs(plugin_names) do
    local lazy_plugin = utils.find_lazy_plugin(plugin_name)
    local patches = config.opts.plugins[plugin_name]

    if lazy_plugin == nil then
      vim.notify(("patchr.nvim: LazyPlugin %s not found"):format(plugin_name), vim.log.levels.ERROR)
      return false
    end

    if patches == nil then
      vim.notify(("patchr.nvim: No patches found for %s"):format(plugin_name), vim.log.levels.ERROR)
      return false
    end

    local result = true
    for _, patch in ipairs(patches) do
      if M.apply_patch(lazy_plugin, patch) == false then
        result = false
      end
    end
    return result
  end
end

return M
