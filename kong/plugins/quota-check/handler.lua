local BasePlugin = require "kong.plugins.base_plugin"
local singletons = require "kong.singletons"
local responses = require "kong.tools.responses"
local constants = require "kong.constants"
local cache = require "kong.tools.database_cache"

local QuotaCheckHandler = BasePlugin:extend()

-- the number is more big and the priority is more high
QuotaCheckHandler.PRIORITY = 9980


function QuotaCheckHandler:new()
    QuotaCheckHandler.super.new(self, "quota-check")
end

function QuotaCheckHandler:access(conf)
    QuotaCheckHandler.super.access(self)

    -- get csutom_id form header
    local custom_id_header = ngx.req.get_headers()["X-Consumer-Custom-ID"]

    if not custom_id_header or custom_id_header == nil then
        return responses.send_HTTP_FORBIDDEN("Invalid custom_id for access")
    end

    -- load quota status form cache ,cache expired time is 24h,cluster node update in 5 seconds
    -- this command will load data from M1 -> M2 - M3 level cache if parent level not hit the cache
    local status = cache.get("quota."..custom_id)

    if not status or status == nil then
        return responses.send_HTTP_FORBIDDEN("Unrecharged account")
    end

    if status == "offline" then
        return responses.send_HTTP_FORBIDDEN("Insufficient account balance")
    else

    end
end

return QuotaCheckHandler


