local utils = require "kong.tools.utils"
local Errors = require "kong.dao.errors"

local SCHEMA = {
  primary_key = {"id"},
  table = "quota",
  cache_key = { "custom_id" },
  fields = {
    id = {type = "id", dao_insert_value = true},
    created_at = {type = "timestamp", immutable = true, dao_insert_value = true},
    consumer_id = {type = "id", required = true, foreign = "consumers:id"},
    custom_id = {type = "string", unique = true},
    status = {type = "string", default = "normal"}
  },

  -- when update must be careful
  self_check = function(schema, plugin_t, dao, is_update)
    if plugin_t.custom_id == nil then
      return false, Errors.schema "no mandatory 'custom_id'"
    end

    if plugin_t.consumer_id == nil then
      return false, Errors.schema "no mandatory 'consumer_id'"
    end

    if plugin_t.status ~= "offline" and plugin_t.status ~= "normal" then
      return false, Errors.schema "value of 'status' invalid"
    end

    return true
  end,
}

return {quota = SCHEMA}
