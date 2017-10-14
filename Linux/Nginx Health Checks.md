---
title: [Nginx] 服务健康检查
tags: nginx
notebook: Linux
---


### 默认检查规则


在默认请情况下， 可以设置 `proxy_next_upstream` 指令来解决一台代理服务器错出时是否将请求代理到另一台服务器;值的注意的是，当服务器出现故障不能请求时，请求还是会发送到该台服务器，然后再切换到另一台，会造成一次请求浪费。

[官方文档](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream)

可选配置项：
```
proxy_next_upstream error | timeout | invalid_header | http_500 | http_502 | http_503 | http_504 | http_403 | http_404 | http_429 | non_idempotent | off ...;
```

