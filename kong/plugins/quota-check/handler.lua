local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local cache = kong.cache

local QuotaCheckHandler = BasePlugin:extend()

-- the number is more big and the priority is more high
QuotaCheckHandler.PRIORITY = 9970


local function load_entity_custom_id(custom_id)
    -- IMPORTANT: the callback is executed inside a lock, hence we cannot terminate
    -- a request here, we MUST always return.
    local quotas, err = kong.dao.quota:find_all({custom_id = custom_id}) -- Lookup in the datastore
    if err then
        error(err) -- caught by kong.cache and logged
    end
    if not quotas then
        return nil -- nothing was found (cached for `neg_ttl`)
    end
    -- assuming the key was unique, we always only have 1 value...
    return quotas[1] -- cache the credential (cached for `ttl`)
end


function QuotaCheckHandler:new()
    QuotaCheckHandler.super.new(self, "quota-check")
end

function QuotaCheckHandler:access(conf)
    QuotaCheckHandler.super.access(self)

    -- get csutom_id form header
    local custom_id_in_header = ngx.req.get_headers()["X-Consumer-Custom-ID"]

    if not custom_id_in_header or custom_id_in_header == nil then
        return responses.send_HTTP_FORBIDDEN("Invalid custom_id for access")
    end

    -- load quota status form cache ,cache expired time is 24h,cluster node update in 5 seconds
    -- this command will load data from M1 -> M2 - M3 level cache if parent level not hit the cache
    local quota = cache:get("quota."..custom_id_in_header,nil,load_entity_custom_id,custom_id_in_header)

    if not quota or quota == nil then
        return responses.send_HTTP_FORBIDDEN("Unrecharged account")
    end

    if quota.status == "offline" then
        return responses.send_HTTP_FORBIDDEN("Insufficient account balance")
    else
        -- continue access
    end
end

return QuotaCheckHandler


