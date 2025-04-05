local cmd = require("patchr.cmd")
local config = require("patchr.config")

local function setup_commands()
  vim.api.nvim_create_user_command("Patchr", function(opts)
    cmd.handle(opts)
  end, {
    nargs = "+",
    complete = cmd.complete,
  })
end

local function setup_autocmds()
  local group = vim.api.nvim_create_augroup("patchr", {
    clear = false,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyUpdatePre",
    callback = function()
      cmd.reset(config.get_plugin_names())
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = { "LazyInstall", "LazyUpdate" },
    callback = function()
      cmd.apply(config.get_plugin_names(), true)
    end,
    group = group,
  })
end

---@class patchr
local M = {}
M.did_setup = false
M.did_setup_autocmds = false

_G.Patchr = M

---@param opts patchr.config?
function M.setup(opts)
  opts = config.setup(opts)
  setup_commands()
  if opts.autocmds == true then
    setup_autocmds()
    M.did_setup_autocmds = true
  end

  M.did_setup = true
end

--- Apply configured patches for the specified plugins
---@param plugins patchr.plugin_names | patchr.plugin_name | nil the plugins to target
---@param reset? boolean the plugins to target
function M.apply_patches(plugins, reset)
  if plugins == nil then
    plugins = config.get_plugin_names()
  elseif type(plugins) == "table" then
    plugins = plugins
  elseif type(plugins) == "string" then
    plugins = { plugins }
  end

  reset = reset or false
  cmd.apply(plugins, reset)
end

return M
