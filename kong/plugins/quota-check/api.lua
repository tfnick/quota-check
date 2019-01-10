local crud = require "kong.api.crud_helpers"

return {
    ["/quotas/:username_or_id/"] = {
        before = function(self, dao_factory, helpers)
            crud.find_consumer_by_username_or_id(self, dao_factory, helpers)
            self.params.consumer_id = self.consumer.id

            --ngx.log(ngx.NOTICE," username_or_id ", self.consumer.custom_id)
            self.params.custom_id = self.consumer.custom_id

            local exist_quotas, err = crud.find_by_id_or_field(
                    dao_factory.quota,
                    { consumer_id = self.params.consumer_id },
                    self.params.custom_id,
                    "custom_id"
            )

            if err then
                return helpers.yield_error(err)
            end
            self.params.username_or_id = nil

            -- judge is create or update
            if next(exist_quotas) == nil then
                self.quota = nil
            else
                self.quota = exist_quotas[1]
            end
        end,

        GET = function(self, dao_factory)
            crud.paginated_set(self, dao_factory.quota)
        end,

        POST = function(self, dao_factory, helpers)
            if self.quota == nil then
                -- create
                local res = crud.post(self.params, dao_factory.quota)
            else
                -- update
                local res = crud.patch(self.params, dao_factory.quota, self.quota)
            end
        end
    }
}


