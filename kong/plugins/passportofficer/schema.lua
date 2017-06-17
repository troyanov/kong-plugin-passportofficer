return {
  no_consumer = false, -- this plugin is available on APIs as well as on Consumers,
  fields = {
    -- Describe your plugin's configuration's schema here.
    cache_expiration = { required = false, type = "number", default = 30 },
    passport_fetch_url = { required = true, type = "string" },    
  },
  self_check = function(schema, plugin_t, dao, is_updating)
    -- perform any custom verification
    return true
  end
}
