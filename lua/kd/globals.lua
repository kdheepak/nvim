_G.prequire = function(m)
  local ok, err = pcall(require, m)
  if not ok then
    return nil, err
  end
  -- if ok, err == m
  return err
end

local plenary_reload = pcall(require, "plenary.reload")
if plenary_reload then
  ---@diagnostic disable-next-line: undefined-field
  RELOADER = plenary_reload.reload_module
else
  RELOADER = require
end

RELOAD = function(...)
  return RELOADER(...)
end

-- Reload a module
R = function(name)
  RELOAD(name)
  return require(name)
end

-- Print the string representation of a Lua table
P = function(v)
  print(vim.inspect(v))
  return v
end
