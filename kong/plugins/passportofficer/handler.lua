-- load the base plugin object and create a subclass
local plugin = require("kong.plugins.base_plugin"):extend()
local http = require "socket.http"
local cache = require "kong.tools.database_cache"
local log = require "kong.cmd.utils.log"

local function load_passport_last_modified_date(id, passport_fetch_url)
  local passport_url = passport_fetch_url.."/"..id
  local body, code, headers, status = http.request(passport_url)
  
  if (headers["last-modified"]) then
    return headers["last-modified"]
  end  
end

-- constructor
function plugin:new()
  plugin.super.new(self, "passportofficer")
  
  -- do initialization here, runs in the 'init_by_lua_block', before worker processes are forked

end

---------------------------------------------------------------------------------------------
-- In the code below, just remove the opening brackets; `[[` to enable a specific handler
--
-- The handlers are based on the OpenResty handlers, see the OpenResty docs for details
-- on when exactly they are invoked and what limitations each handler has.
--
-- The call to `.super.xxx(self)` is a call to the base_plugin, which does nothing, except logging
-- that the specific handler was executed.
---------------------------------------------------------------------------------------------


--[[ handles more initialization, but AFTER the worker process has been forked/created.
-- It runs in the 'init_worker_by_lua_block'
function plugin:init_worker()
  plugin.super.access(self)

  -- your custom code here
  
end --]]

--[[ runs in the ssl_certificate_by_lua_block handler
function plugin:certificate(plugin_conf)
  plugin.super.access(self)

  -- your custom code here
  
end --]]

--[[ runs in the 'rewrite_by_lua_block' (from version 0.10.2+)
-- IMPORTANT: during the `rewrite` phase neither the `api` nor the `consumer` will have
-- been identified, hence this handler will only be executed if the plugin is 
-- configured as a global plugin!
function plugin:rewrite(plugin_conf)
  plugin.super.rewrite(self)

  -- your custom code here
  
end --]]

---[[ runs in the 'access_by_lua_block'
function plugin:access(plugin_conf)
  plugin.super.access(self)

  -- your custom code here  
  local headers = ngx.req.get_headers()
  if not (headers["x-authenticated-userid"]) then 
    return
  end

  local user_id = headers["x-authenticated-userid"]
  local cache_expiration = plugin_conf.cache_expiration
  local passport_fetch_url = plugin_conf.passport_fetch_url

  passport_last_modified_date, err = cache.get_or_set("passport.modified."..user_id, cache_expiration, load_passport_last_modified_date, user_id, passport_fetch_url)
  if err then
    return
  end
  
  ngx.header["X-Passport-Last-Modified"] = passport_last_modified_date
  
end --]]

--[[ runs in the 'header_filter_by_lua_block'
function plugin:header_filter(plugin_conf)
  plugin.super.access(self)

  -- your custom code here

end --]]

--[[ runs in the 'body_filter_by_lua_block'
function plugin:body_filter(plugin_conf)
  plugin.super.access(self)

  -- your custom code here
  
end --]]

--[[ runs in the 'log_by_lua_block'
function plugin:log(plugin_conf)
  plugin.super.access(self)

  -- your custom code here
  
end --]]


-- set the plugin priority, which determines plugin execution order
plugin.PRIORITY = 1000

-- return our plugin object
return plugin
