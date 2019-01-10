
### 插件顺序

jwt-header-rewrite -> jwt | sign-verify -> quota-check -> charge-msg-produce

### 插件级别

jwt-header-rewrite(global) -> jwt | sign-verify(route) -> quota-check(route) -> charge-msg-produce(route)


### quota-check主要功能

基于全局共享缓存ngx-sharr-DICT实现，当计费系统发现账户余额不足，调用网关的admin-api更新数据库以及全局缓存，实现客户quota不足的访问控制

- 提供创建创建客户admin API，更新appKey appSecret的联合api

- 更新客户状态admin API, 当费用不足时调用或者充值成功后调用，由本插件提供

- 本插件创建quota表

### 新接口改为3个

> 创建客户

```
curl -X POST \
    --data "username=own" \
    --data "custom_id=1"
   http://127.0.0.1:8001/consumers/ \

```

> 创建appKey appSecret

```
curl -X POST \
    --data "key=111111111111111111111111" \
    --data "secret=2222222222222222222222" \
   http://127.0.0.1:8001/consumers/:custom_id/jwt/ \
   
```

> 更新账户状态

```
curl -X PATCH \
    --data "status=offline" \
   http://127.0.0.1:8001/quotas/:custom_id/ \
  
```

返回值

```json
{"custom_id":"111","created_at":1547038327000,"id":"dd96df74-6e79-4e9b-a611-294b253fa4f7","status":"normal","consumer_id":"be3517b2-8406-4dd5-9337-b8c89b30c72e"}
```

错误返回
```json
{"message":"Not Found"}
```

> 查看账户状态

```
curl -X GET http://127.0.0.1:8001/quotas/:custom_id/
   
```

返回值

```json
{"total":1,"data":[{"custom_id":"111","created_at":1547038327000,"id":"dd96df74-6e79-4e9b-a611-294b253fa4f7","status":"normal","consumer_id":"be3517b2-8406-4dd5-9337-b8c89b30c72e"}]}
```

错误返回
```json
{"message":"Not Found"}
```

### 安装

shell
```
/bin/install.sh

```
plugin will location in /usr/local/share/lua/5.1/kong/plugins

enable plugin in /etc/kong/kong.conf

```

```
execute migrations

```
cd /etc/kong/kong.conf
kong  migrations up -c kong.conf
```

restart kong ,add --vv option if debug

```

kong restart

```

