local BasePlugin = require "kong.plugins.base_plugin"
local singletons = require "kong.singletons"
local responses = require "kong.tools.responses"
local constants = require "kong.constants"

local QuotaCheckHandler = BasePlugin:extend()

-- the number is more big and the priority is more high
QuotaCheckHandler.PRIORITY = 9980


function QuotaCheckHandler:new()
    QuotaCheckHandler.super.new(self, "quota-check")
end

function QuotaCheckHandler:access(conf)
    QuotaCheckHandler.super.access(self)


end

return QuotaCheckHandler


