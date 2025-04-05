local patchr = require("patchr")
local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error
local info = vim.health.info or vim.health.report_info

local M = {}

function M.check()
  start("patchr.nvim")
  if patchr.did_setup then
    ok("setup called")
  else
    error("setup not called")
  end
  if patchr.did_setup_autocmds then
    ok("autocmds are setup")
  else
    warn("autocmds are not setup")
  end
  if vim.fn.exists(":Lazy") == 2 then
    ok("Lazy is available")
  else
    error("Lazy is not available")
  end
  if vim.fn.executable("git") then
    ok("Git command found")
  else
    error("Git command missing")
  end
end

return M
