local crud = require "kong.api.crud_helpers"

return {
    ["/quotas/:username_or_id/"] = {
        before = function(self, dao_factory, helpers)
            crud.find_consumer_by_username_or_id(self, dao_factory, helpers)
            self.params.consumer_id = self.consumer.id
        end,

        GET = function(self, dao_factory)
            crud.get(self, dao_factory.quota)
        end,

        PUT = function(self, dao_factory, helpers)
            crud.put(self.params, dao_factory.quota)
        end,

        POST = function(self, dao_factory, helpers)
            crud.post(self.params, dao_factory.quota)
        end
    }
}
