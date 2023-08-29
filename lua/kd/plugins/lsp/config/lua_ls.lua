local function get_quarto_resource_path()
  local f = assert(io.popen("quarto --paths", "r"))
  local s = assert(f:read("*a"))
  f:close()
  return require("kd.utils").strsplit(s, "\n")[2]
end

local resource_path = get_quarto_resource_path()

local lua_library_files = vim.api.nvim_get_runtime_file("", true)
table.insert(lua_library_files, resource_path .. "/lua-types")
table.insert(lua_library_files, vim.fn.expand("$VIMRUNTIME/lua"))

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
table.insert(runtime_path, "?.lua")
table.insert(runtime_path, "?/init.lua")
table.insert(runtime_path, resource_path .. "/lua-plugin/plugin.lua")

return {
  settings = {
    Lua = {
      runtime = {
        special = {
          req = "require",
        },
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = {
        globals = {
          "vim",
          "require",
          "rocks",
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = lua_library_files,
        ignoreDir = "tmp/",
        useGitIgnore = false,
        maxPreload = 100000000,
        preloadFileSize = 500000,
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },

  server_capabilities = {
    definition = true,
    typeDefinition = true,
  },
}
