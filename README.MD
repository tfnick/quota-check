
### 插件顺序

jwt-header-rewrite -> jwt | sign-verify -> quota-check -> charge-msg-produce

### 插件级别

jwt-header-rewrite(global) -> jwt | sign-verify(route) -> quota-check(route) -> charge-msg-produce(route)


### quota-check主要功能

基于全局共享缓存ngx-sharr-DICT实现，当计费系统发现账户余额不足，调用网关的admin-api更新数据库以及全局缓存，实现客户quota不足的访问控制

- 提供创建创建客户admin API，kong自带

- 更新客户状态admin API, 当费用不足时调用或者充值成功后调用，由本插件提供

- 本插件创建quota表