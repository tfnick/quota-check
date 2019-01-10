package = "quota-check"
version = "1.0-0"
local pluginName = "quota-check"

source = {
  url = "git://github.com/tfnick/quota-check.git",
}

description = {
  summary = "A Kong plugin quota-check",
  license = "Apache 2.0"
}
dependencies = {
  "lua ~> 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.quota-check.hooks"] = "kong/plugins/quota-check/hooks.lua",
    ["kong.plugins.quota-check.api"] = "kong/plugins/quota-check/api.lua",
    ["kong.plugins.quota-check.daos"] = "kong/plugins/quota-check/daos.lua",
    ["kong.plugins.quota-check.handler"] = "kong/plugins/quota-check/handler.lua",
    ["kong.plugins.quota-check.schema"]  = "kong/plugins/quota-check/schema.lua"
  }
}