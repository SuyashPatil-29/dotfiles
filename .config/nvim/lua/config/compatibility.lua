-- Compatibility layer for deprecated Neovim functions
-- This file provides shims for deprecated functions to avoid warnings

-- Suppress deprecation warnings by temporarily overriding vim.deprecate
local original_deprecate = vim.deprecate
local function silent_deprecate(name, alternative, version, plugin, backtrace)
  -- Only suppress specific deprecations we're handling
  if name == "vim.tbl_add_reverse_lookup" then
    return -- Silently ignore this specific deprecation
  end
  -- Call original deprecate for other warnings
  return original_deprecate(name, alternative, version, plugin, backtrace)
end

-- Apply the silent deprecate function
vim.deprecate = silent_deprecate

-- Restore the original deprecate function after plugins load
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Restore original deprecate after a delay to let plugins load
    vim.defer_fn(function()
      vim.deprecate = original_deprecate
    end, 1000)
  end,
})
