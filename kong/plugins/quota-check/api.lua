local crud = require "kong.api.crud_helpers"

return {
    ["/quotas/:username_or_id/"] = {
        before = function(self, dao_factory, helpers)
            crud.find_consumer_by_username_or_id(self, dao_factory, helpers)
            self.params.consumer_id = self.consumer.id
            self.params.custom_id = self.custom_id

            local exist_quotas, err = crud.find_by_id_or_field(
                    dao_factory.quota,
                    { consumer_id = self.params.consumer_id },
                    self.params.custom_id,
                    "custom_id"
            )

            if err then
                return helpers.yield_error(err)
            elseif next(exist_quotas) == nil then
                return helpers.responses.send_HTTP_NOT_FOUND()
            end
            self.params.username_or_id = nil
            self.quota = exist_quotas[1]
        end,

        GET = function(self, dao_factory)
            crud.paginated_set(self, dao_factory.quota)
        end,

        PATCH = function(self, dao_factory, helpers)
            crud.patch(self.params, dao_factory.quota,self.quota)
        end
    }
}