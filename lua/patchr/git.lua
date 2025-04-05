local config = require("patchr.config")

---@class patchr.git.mod
local M = {}

--- resets the repository
--- @param repository_path string
--- @param opts? patchr.config.git.reset
--- @return vim.SystemCompleted returns process completion
function M.reset(repository_path, opts)
  opts = vim.tbl_deep_extend("force", {}, config.opts.git.reset, opts or {})
  local cmd = {
    "git",
    "reset",
  }
  if opts.hard == true then
    table.insert(cmd, "--hard")
  end
  return vim.system(cmd, { cwd = repository_path }):wait()
end

--- resets the repository
--- @param repository_path string
--- @param patch_path string path to patch file
--- @return vim.SystemCompleted returns process completion
function M.apply(repository_path, patch_path)
  local cmd = {
    "git",
    "apply",
    patch_path,
  }
  return vim.system(cmd, { cwd = repository_path }):wait()
end

return M
