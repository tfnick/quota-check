local plugin_config_iterator = require("kong.dao.migrations.helpers").plugin_config_iterator

return {
  {
    name = "2015-06-09-quota",
    up = [[
      CREATE TABLE IF NOT EXISTS quota(
        id uuid,
        consumer_id uuid REFERENCES consumers (id) ON DELETE CASCADE,
        custom_id text UNIQUE,
        status text,
        created_at timestamp without time zone default (CURRENT_TIMESTAMP(0) at time zone 'utc'),
        PRIMARY KEY (id)
      );

      DO $$
      BEGIN
        IF (SELECT to_regclass('quota_custom_id')) IS NULL THEN
          CREATE INDEX quota_custom_id ON quota(custom_id);
        END IF;
        IF (SELECT to_regclass('quota_consumer_id')) IS NULL THEN
          CREATE INDEX quota_consumer_id ON quota(consumer_id);
        END IF;
      END$$;
    ]],
    down = [[
      DROP TABLE quota;
    ]]
  }
}
