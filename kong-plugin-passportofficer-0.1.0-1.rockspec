package = "kong-plugin-passportofficer" 
version = "0.1.0-1"

supported_platforms = {"linux", "macosx"}
source = {
  -- these are initially not required to make it work
  url = "",
  tag = ""
}

description = {
  summary = "",
  homepage = "",
  license = "MIT"
}

dependencies = {
}

local pluginName = "passportofficer"
build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
  }
}
